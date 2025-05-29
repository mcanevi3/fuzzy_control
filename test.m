clear; clc;

t=0:0.1:8;
% ytriangle=membership(t,"type","triangle","start",1,"peak",3,"stop",3.5);
% ytriangle=membership(t,"type","triangle","start",1,"width",1,"height",1);

% ytrapezoid=membership(t,"type","trapezoid","start_low",1,"start_high",2,"stop_high",5,"stop_low",6);
ytrapezoid=membership(t,"type","trapezoid","start",1,"width_low",1,"width_high",5);
figure(1);clf;hold on;grid on;
plot(t,ytrapezoid,'k','LineWidth',2);
plot([1,2,7,8],[0,1,1,0],'bx','LineWidth',2);
