clear;clc;

figure(1);clf;
subplot(1,2,1);hold on;grid on;xlabel("temperature");ax1=gca;
temperatureSet=0:0.1:40;
temperatureMembership=membership(temperatureSet,"type","sigmoid","slope",1/20,"center",40);

subplot(1,2,2);hold on;grid on;xlabel("speed");ax2=gca;
speedSet=0:0.1:100;
speedMembership=membership(speedSet,"type","sigmoid","slope",1/15,"center",40);

plot(ax1,temperatureSet,temperatureMembership,'k','LineWidth',2);
plot(ax2,speedSet,speedMembership,'k','LineWidth',2);

% input
tempVal=30;
muTemp = membership(tempVal,"type","sigmoid","slope",1/20,"center",40); 
plot(ax1,tempVal,muTemp,'rs','LineWidth',2);
title(ax1,"mu:"+string(muTemp))
% Apply rule: IF temp is high THEN speed is high
mu_result = muTemp * speedMembership;
% Defuzzify (centroid method)
output_speed = sum(speedSet .* mu_result) / sum(mu_result);

plot(ax2,speedSet,muTemp*ones(size(speedSet)),'r--','LineWidth',2);
plot(ax2,speedSet,mu_result,'r','LineWidth',2);
plot(ax2,output_speed,membership(output_speed,"type","sigmoid","slope",1/15,"center",40),'rs','LineWidth',2);
