% MATLAB simulation demonstrating the 12-region behavior of the fuzzy PI controller
% as discussed in Figure 3.3, Tables 3.1 and 3.2 of the fuzzy control PDF.

clear; clc;

% Settings
Ts = 0.1;
T_end = 40;
t = 0:Ts:T_end;
n = length(t);

% Plant: G(s) = 0.02 / (s + 0.2)
x = 0;            % system state
y = zeros(1, n);
u = zeros(1, n);
% Modify reference input to excite different IC regions
r = [zeros(1,20), ones(1,40), -0.5*ones(1,n-60)];

e = zeros(1, n);
de = zeros(1, n);
region_labels = strings(1, n); % track IC region labels

% Adjustable gains
K_e = 1;
K_r = 1;
K_du = 1; % output scaling

% Fuzzy parameters
L = 0.1;  % smaller universe width to magnify transitions

% Output labels (singleton values)
outVals = struct('N', -1, 'Z', 0, 'P', 1);

% Rule base: 4 rules
% r1: P,P -> P
% r2: P,N -> Z
% r3: N,P -> Z
% r4: N,N -> N

% Membership functions (piecewise linear)
membership = @(x,L) struct(...
    'P', max(0, min(1, (x + L)/(2*L))), ...
    'N', 1 - max(0, min(1, (x + L)/(2*L))) ...
);

for k = 2:n
    % Compute error and delta error
    e(k) = r(k) - y(k-1);
    de(k) = e(k) - e(k-1);

    % Fuzzify
    mu_e = membership(e(k), L);
    mu_de = membership(de(k), L);

    % Apply Zadeh AND (min rule firing strengths)
    w1 = min(mu_e.P, mu_de.P);   % rule 1: P,P -> P
    w2 = min(mu_e.P, mu_de.N);   % rule 2: P,N -> Z
    w3 = min(mu_e.N, mu_de.P);   % rule 3: N,P -> Z
    w4 = min(mu_e.N, mu_de.N);   % rule 4: N,N -> N

    % Aggregate and defuzzify (weighted average of singletons)
    num = w1*outVals.P + w2*outVals.Z + w3*outVals.Z + w4*outVals.N;
    den = w1 + w2 + w3 + w4 + 1e-12;  % avoid division by zero
    delta_u = K_du * (num / den);

    % Control input update (incremental PI)
    u(k) = u(k-1) + delta_u;

    % Simulate system
    dx = -0.2 * x + 0.02 * u(k);
    x = x + Ts * dx;
    y(k) = x;

    % Determine region IC1–IC12 (simplified labeling)
    if e(k) > L
        if de(k) > L
            region_labels(k) = "IC9";  % saturated high
        elseif de(k) < -L
            region_labels(k) = "IC5";
        else
            region_labels(k) = "IC7";
        end
    elseif e(k) < -L
        if de(k) > L
            region_labels(k) = "IC6";
        elseif de(k) < -L
            region_labels(k) = "IC11"; % saturated low
        else
            region_labels(k) = "IC8";
        end
    else
        if de(k) > L
            region_labels(k) = "IC2";
        elseif de(k) < -L
            region_labels(k) = "IC4";
        else
            region_labels(k) = "IC1";
        end
    end
end

% Plot
figure;
subplot(4,1,1);
plot(t, r, '--k', t, y, 'b', 'LineWidth', 1.5);
grid on; legend('Reference', 'Output');
title('System Output');

subplot(4,1,2);
plot(t, e, 'm'); grid on;
title('Error e(n)'); ylabel('e');

subplot(4,1,3);
plot(t, u, 'r'); grid on;
title('Control Input u(n)'); ylabel('u');

subplot(4,1,4);
unique_regions = unique(region_labels);
colors = lines(length(unique_regions)); hold on;
for i = 1:length(unique_regions)
    ic = unique_regions(i);
    mask = double(region_labels == ic);
    area(t, mask, 'FaceAlpha', 0.2, 'DisplayName', ic, 'FaceColor', colors(i,:));
end
legend('Location','eastoutside');
title('IC Region over Time'); ylabel('Active Region'); xlabel('Time (s)');