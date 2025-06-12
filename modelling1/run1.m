clear;clc;

x1=[0;2;3];
x2=[2;4;6];
y=[1;5;6];
data=table(x1,x2,y);
data

rule1_x1=@(val)membership(val,"type","gauss","mean",1.5,"deviation",2);
rule1_x2=@(val)membership(val,"type","gauss","mean",3,"deviation",2);
rule2_x1=@(val)membership(val,"type","gauss","mean",3,"deviation",2);
rule2_x2=@(val)membership(val,"type","gauss","mean",5,"deviation",2);


x1_set=-2:0.1:10;
x2_set=-2:0.1:10;

figure(1);clf;
subplot(1,2,1);cla;hold on;grid on;xlabel("x1");legend("show");ax1=gca;
subplot(1,2,2);cla;hold on;grid on;xlabel("x2");legend("show");ax2=gca;
% subplot(1,3,3);cla;hold on;grid on;xlabel("y");ax3=gca;

plot(ax1,x1_set,rule1_x1(x1_set),'b','LineWidth',2,'DisplayName','Rule 1');
plot(ax1,x1_set,rule2_x1(x1_set),'r','LineWidth',2,'DisplayName','Rule 2');
plot(ax2,x2_set,rule1_x1(x2_set),'b','LineWidth',2,'DisplayName','Rule 1');
plot(ax2,x2_set,rule2_x1(x2_set),'r','LineWidth',2,'DisplayName','Rule 2');

f1=@(val)rule1_x1(val)*rule1_x2(val);
f2=@(val)rule2_x1(val)*rule2_x2(val);

b1=1;
b2=5;

fx_theta=(b1*f1+b2*f2)/(f1+f2);

