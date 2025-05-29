clear;clc;

temperatureSet=0:0.1:40;
low_temp =@(temperature)membership(temperature,"type","zshaped","start",10,"stop",20);
medium_temp =@(temperature)membership(temperature,"type","bell","center",20,"width",10,"slope",3);
high_temp =@(temperature)membership(temperature,"type","sshaped","start",25,"stop",30);

speedSet=0:0.1:100;
low_speed =@(speed)membership(speed,"type","zshaped","start",10,"stop",20);
medium_speed =@(speed)membership(speed,"type","bell","center",50,"width",20,"slope",3);
high_speed =@(speed)membership(speed,"type","sshaped","start",60,"stop",80);

figure(1);clf;
subplot(1,3,1);hold on;grid on;xlabel("temperature");ax1=gca;
subplot(1,3,2);hold on;grid on;xlabel("speed");ax2=gca;
subplot(1,3,3);hold on;grid on;xlabel("speed");ax3=gca;

plot(ax1,temperatureSet,low_temp(temperatureSet),'b','LineWidth',2);
plot(ax1,temperatureSet,medium_temp(temperatureSet),'k','LineWidth',2);
plot(ax1,temperatureSet,high_temp(temperatureSet),'r','LineWidth',2);

plot(ax2,speedSet,low_speed(speedSet),'b','LineWidth',1);
plot(ax2,speedSet,medium_speed(speedSet),'k','LineWidth',1);
plot(ax2,speedSet,high_speed(speedSet),'r','LineWidth',1);

% input
u=30;
mu_low=low_temp(u);
mu_medium=medium_temp(u);
mu_high=high_temp(u);

plot(ax1,u,mu_low,'bs','LineWidth',2);
plot(ax1,u,mu_medium,'ks','LineWidth',2);
plot(ax1,u,mu_high,'rs','LineWidth',2);

% Apply rule: IF temp is high THEN speed is high
out1 = mu_low * low_speed(speedSet);
out2 = mu_medium * medium_speed(speedSet);
out3 = mu_high * high_speed(speedSet);

plot(ax3,speedSet,out1,'b','LineWidth',2);
plot(ax3,speedSet,out2,'k','LineWidth',2);
plot(ax3,speedSet,out3,'r','LineWidth',2);

aggregated_output = max(max(out1, out2), out3);

vertices=[speedSet',aggregated_output'];
vertices=[vertices;[speedSet(end),0]];
patch(ax3,'Vertices',vertices,'Faces',[1:size(vertices,1)],'FaceAlpha',0.4,'FaceColor',[0.6,0.6,0.6])

% Defuzzify (centroid method)
output_speed = sum(speedSet .* aggregated_output) / sum(aggregated_output);
plot(ax3,output_speed,low_speed(output_speed),'bs','LineWidth',2)
plot(ax3,output_speed,medium_speed(output_speed),'ks','LineWidth',2)
plot(ax3,output_speed,high_speed(output_speed),'rs','LineWidth',2)

