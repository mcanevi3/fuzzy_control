clear;clc;

% Fuzzy definitions
errorSet=-5:0.1:5;
negative_error=@(error)membership(error,"type","zshaped","start",-1,"stop",1);
positive_error =@(error)membership(error,"type","sshaped","start",-1,"stop",1);

deltaErrorSet=-5:0.1:5;
negative_delta_error=@(deltaError)membership(deltaError,"type","zshaped","start",-1,"stop",1);
positive_delta_error =@(deltaError)membership(deltaError,"type","sshaped","start",-1,"stop",1);

controlSet=-3:0.1:3; % A
negative_control=@(control)double(control == -1); %H=1
zero_control=@(control)double(control == 0);
positive_control=@(control)double(control == 1);

figure(1);clf;
subplot(1,4,1);hold on;grid on;xlabel("error");ax1=gca;
subplot(1,4,2);hold on;grid on;xlabel("delta error");ax2=gca;
subplot(1,4,3);hold on;grid on;xlabel("control");ax3=gca;
subplot(1,4,4);hold on;grid on;xlabel("control");ax4=gca;

plot(ax1,errorSet,negative_error(errorSet),'b','LineWidth',2);
plot(ax1,errorSet,positive_error(errorSet),'r','LineWidth',2);

plot(ax2,deltaErrorSet,negative_delta_error(deltaErrorSet),'b','LineWidth',2);
plot(ax2,deltaErrorSet,positive_delta_error(deltaErrorSet),'r','LineWidth',2);

plot(ax3,controlSet,negative_control(controlSet),'b','LineWidth',2);
plot(ax3,controlSet,zero_control(controlSet),'k','LineWidth',2);
plot(ax3,controlSet,positive_control(controlSet),'r','LineWidth',2);

rules = [
    struct('e','N', 'de','N', 'out','N'),
    struct('e','N', 'de','P', 'out','Z'),
    struct('e','P', 'de','N', 'out','Z'),
    struct('e','P', 'de','P', 'out','P')
];
output_mfs=cell(1,length(rules));

% System
Ts = 0.05;                     % Sampling time
T_end = 50;
time = 0:Ts:T_end;
n = length(time);

y = zeros(1,n);               % Output
u = zeros(1,n);               % Control
e = zeros(1,n);
de = zeros(1,n);
r = ones(1,n);                % Reference = 1

x = 0; 
for k = 2:n
    e(k) = r(k) - y(k-1);
    de(k) = e(k) - e(k-1);
    
    %% Fuzzy
    mu_e=struct('N',negative_error(e(k)),'P',positive_error(e(k)));
    mu_de=struct('N',negative_delta_error(de(k)),'P',positive_delta_error(de(k)));

    for i = 1:length(rules)
        rule = rules(i);
        strength = min(mu_e.(rule.e),mu_de.(rule.de)); 
        if strcmp(rule.out,'N')
            output_mfs{i} = strength*negative_control(controlSet);
        elseif strcmp(rule.out,'Z')
            output_mfs{i} = strength*zero_control(controlSet);
        else 
            output_mfs{i} = strength*positive_control(controlSet);
        end
    end

    aggregated_output = zeros(size(controlSet));
    for i = 1:length(output_mfs)
        aggregated_output = max(aggregated_output, output_mfs{i});
    end
    % Defuzzify (centroid method)
    output_control = sum(controlSet .* aggregated_output) / sum(aggregated_output);

    %%
    u(k) = u(k-1)+output_control;
    
    % Forward Euler on dx/dt = -0.2*x + 0.02*u
    dx = -0.2*x + 0.02*u(k);
    x = x + Ts*dx;
    y(k) = x;  
end
plot(ax4,time,y,'k','LineWidth',2);
plot(ax4,time,u,'b','LineWidth',2);
legend("y","u")
