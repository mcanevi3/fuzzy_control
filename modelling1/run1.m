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

f1=@(x1,x2)rule1_x1(x1)*rule1_x2(x2);
f2=@(x1,x2)rule2_x1(x1)*rule2_x2(x2);

ksi=@(x1,x2)[f1(x1,x2);f2(x1,x2)]/(f1(x1,x2)+f2(x1,x2));

b1=1;
b2=5;

Phi=[ksi(x1(1),x2(1))';ksi(x1(2),x2(2))';ksi(x1(3),x2(3))'];
Y=[y(1);y(2);y(3)];

theta=inv(Phi'*Phi)*Phi'*Y;
% theta=[b1;b2]; for some fuzzy output singleton membership

Yapprox=[
theta'*Phi(1,:)';
theta'*Phi(2,:)';
theta'*Phi(3,:)']
