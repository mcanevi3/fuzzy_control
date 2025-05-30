clear;clc;

% Fuzzy definitions
errorSet=-50:0.1:50;
negative_error=@(error)membership(error,"type","zshaped","start",-10,"stop",2);
zero_error=@(error)membership(error,"type","bell","center",0,"width",0.01,"slope",5);
positive_error =@(error)membership(error,"type","sshaped","start",-2,"stop",10);

deltaErrorSet=-500:0.1:500;
negative_delta_error=@(deltaError)membership(deltaError,"type","zshaped","start",-100,"stop",10);
zero_delta_error=@(deltaError)membership(deltaError,"type","bell","center",0,"width",2,"slope",3);
positive_delta_error =@(deltaError)membership(deltaError,"type","sshaped","start",-10,"stop",100);

currentSet=-30:0.1:30; % A
negative_current=@(current)membership(current,"type","zshaped","start",-10,"stop",5);
zero_current=@(current)membership(current,"type","bell","center",0,"width",2,"slope",3);
positive_current=@(current)membership(current,"type","sshaped","start",-5,"stop",10);

figure(1);clf;
subplot(1,4,1);hold on;grid on;xlabel("error");ax1=gca;
subplot(1,4,2);hold on;grid on;xlabel("delta error");ax2=gca;
subplot(1,4,3);hold on;grid on;xlabel("current");ax3=gca;
subplot(1,4,4);hold on;grid on;xlabel("current");ax4=gca;

plot(ax1,errorSet,negative_error(errorSet),'b','LineWidth',2);
plot(ax1,errorSet,zero_error(errorSet),'k','LineWidth',2);
plot(ax1,errorSet,positive_error(errorSet),'r','LineWidth',2);

plot(ax2,deltaErrorSet,negative_delta_error(deltaErrorSet),'b','LineWidth',2);
plot(ax2,deltaErrorSet,zero_delta_error(deltaErrorSet),'k','LineWidth',2);
plot(ax2,deltaErrorSet,positive_delta_error(deltaErrorSet),'r','LineWidth',2);

plot(ax3,currentSet,negative_current(currentSet),'b','LineWidth',2);
plot(ax3,currentSet,zero_current(currentSet),'k','LineWidth',2);
plot(ax3,currentSet,positive_current(currentSet),'r','LineWidth',2);

rules = [
    struct('e','N', 'de','N', 'out','N'),
    struct('e','N', 'de','Z', 'out','Z'),
    struct('e','N', 'de','P', 'out','P'),
    struct('e','Z', 'de','N', 'out','N'),
    struct('e','Z', 'de','Z', 'out','Z'),
    struct('e','Z', 'de','P', 'out','P'),
    struct('e','P', 'de','N', 'out','N'),
    struct('e','P', 'de','Z', 'out','Z'),
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
    mu_e=struct('N',negative_error(e(k)),'Z',zero_error(e(k)),'P',positive_error(e(k)));
    mu_de=struct('N',negative_delta_error(de(k)),'Z',zero_delta_error(de(k)),'P',positive_delta_error(de(k)));

    for i = 1:length(rules)
        rule = rules(i);
        strength = mu_e.(rule.e).*mu_de.(rule.de); 
        if strcmp(rule.out,'N')
            output_mfs{i} = strength*negative_current(currentSet);
        elseif strcmp(rule.out,'Z')
            output_mfs{i} = strength*zero_current(currentSet);
        else 
            output_mfs{i} = strength*positive_current(currentSet);
        end
    end

    aggregated_output = zeros(size(currentSet));
    for i = 1:length(output_mfs)
        aggregated_output = max(aggregated_output, output_mfs{i});
    end
    % Defuzzify (centroid method)
    output_current = sum(currentSet .* aggregated_output) / sum(aggregated_output);

    %%
    u(k) = u(k-1)+output_current;
    
    % Forward Euler on dx/dt = -0.2*x + 0.02*u
    dx = -1*x + 0.02*u(k);
    x = x + Ts*dx;
    y(k) = x;  
end
plot(ax4,time,y,'k','LineWidth',2);
plot(ax4,time,u,'b','LineWidth',2);
legend("y","u")
