clear; clc;

% Time and plant setup
Ts = 0.1;
T_end = 50;
t = 0:Ts:T_end;
n = length(t);

% Plant state
x = 0;
y = zeros(1,n);
u = zeros(1,n);
r = ones(1,n);  % step reference
e = zeros(1,n);
de = zeros(1,n);

% Output singleton values
outVals = struct('N', -10, 'Z', 0, 'P', 10);

% Rule table (fuzzy output label)
rule = {
    'N','N','N';
    'N','Z','N';
    'N','P','Z';
    
    'Z','N','N';
    'Z','Z','Z';
    'Z','P','P';
    
    'P','N','Z';
    'P','Z','P';
    'P','P','P';
};

% Threshold for fuzzification
thresh = 0.05;

% Tracking labels (numeric: N = -1, Z = 0, P = +1)
e_status = zeros(1,n);
de_status = zeros(1,n);
u_label_status = zeros(1,n);

% Membership function labels as numeric
label2num = struct('N', -1, 'Z', 0, 'P', 1);

for k = 2:n
    % Compute error and delta error
    e(k) = r(k) - y(k-1);
    de(k) = e(k) - e(k-1);

    % Fuzzify error
    if e(k) < -thresh
        eLabel = 'N';
    elseif e(k) > thresh
        eLabel = 'P';
    else
        eLabel = 'Z';
    end

    % Fuzzify delta error
    if de(k) < -thresh
        deLabel = 'N';
    elseif de(k) > thresh
        deLabel = 'P';
    else
        deLabel = 'Z';
    end

    % Track fuzzy labels numerically
    e_status(k) = label2num.(eLabel);
    de_status(k) = label2num.(deLabel);

    % Find matching rule
    matchIdx = find(strcmp(rule(:,1), eLabel) & strcmp(rule(:,2), deLabel));
    labelOut = rule{matchIdx, 3};
    u_label_status(k) = label2num.(labelOut);

    % Defuzzify (singleton value)
    delta_u = outVals.(labelOut);
    u(k) = u(k-1) + delta_u * Ts;

    % Plant dynamics: dx/dt = -0.2x + 0.02u
    dx = -0.2*x + 0.02*u(k);
    x = x + Ts*dx;
    y(k) = x;
end

% --- Plotting ---
figure;

% Subplot 1: System output + error + delta error + control input
subplot(4,1,1); hold on; grid on;
plot(t, r, '--k', 'DisplayName', 'Reference');
plot(t, y, 'b', 'LineWidth', 1.5, 'DisplayName', 'Output y');
plot(t, e, 'm', 'DisplayName', 'Error e');
plot(t, de, 'c', 'DisplayName', 'Delta e');
plot(t, u, 'r', 'DisplayName', 'Control u');
legend;
title('System Output + Error + Control Input');
ylabel('Value');

% Subplot 2: Fuzzy label of error
subplot(4,1,2);
stairs(t, e_status, 'b', 'LineWidth', 1.2);
grid on;
ylim([-1.2 1.2]);
yticks([-1 0 1]);
yticklabels({'N','Z','P'});
title('Fuzzy Label of Error e(n)');

% Subplot 3: Fuzzy label of delta error
subplot(4,1,3);
stairs(t, de_status, 'g', 'LineWidth', 1.2);
grid on;
ylim([-1.2 1.2]);
yticks([-1 0 1]);
yticklabels({'N','Z','P'});
title('Fuzzy Label of \Delta e(n)');

% Subplot 4: Fuzzy label of rule output
subplot(4,1,4);
stairs(t, u_label_status, 'r', 'LineWidth', 1.2);
grid on;
ylim([-1.2 1.2]);
yticks([-1 0 1]);
yticklabels({'N','Z','P'});
title('Fuzzy Rule Output Label \Delta u(n)');
xlabel('Time (s)');
