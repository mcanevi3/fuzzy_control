clear; clc;

t=0:0.01:10;
% ytriangle=membership(t,"type","triangle","start",1,"peak",3,"stop",3.5);
% ytriangle=membership(t,"type","triangle","start",1,"width",1,"height",1);

% ytrapezoid=membership(t,"type","trapezoid","start_low",1,"start_high",2,"stop_high",5,"stop_low",6);
% ytrapezoid=membership(t,"type","trapezoid","start",1,"width_low",1,"width_high",5);

% ygauss=membership(t,"type","gauss","mean",4,"deviation",1);

% ybell=membership(t,"type","bell","width",2,"slope",4,"center",4);
% ysigmoid=membership(t,"type","sigmoid","slope",-4,"center",4);

yzshaped=membership(t,"type","zshaped","start",3,"stop",7);

figure(1);clf;hold on;grid on;
plot(t,yzshaped,'k','LineWidth',2);
