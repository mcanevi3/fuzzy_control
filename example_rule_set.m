clear;clc;

Gs=tf(1,[1,2*0.4*1,1]);
kd=1;
kp=2;
ki=2;
Fs=tf([kd,kp,ki],[1 0]);
Ts=feedback(Fs*Gs,1);

[y,t]=step(Ts);
[u,t]=step(feedback(Gs,Fs),t);
r=ones(size(t));
e=r-y;
de=diff(e)/(t(2)-t(1));
de=[de;de(end)];
q=zeros(size(t));
for i=2:length(q)
    q(i)=q(i-1)+(t(2)-t(1))*e(i-1);
end

figure(1);clf;hold on;grid on;
plot(t,y,'k','LineWidth',2,'DisplayName','y');
plot(t,e,'r','LineWidth',2,'DisplayName','e');
plot(t,de,'b','LineWidth',2,'DisplayName','de');
plot(t,q,'c','LineWidth',2,'DisplayName','q');
plot(t,u,'m','LineWidth',2,'DisplayName','u');
legend("show")

de=q;
temp=ylim;
temp_min=temp(1);
temp_max=temp(2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
indices=(e<0) & (de<0);
indices = indices(:);
d = diff([0; indices; 0]);
startIdx = find(d == 1);
endIdx   = find(d == -1) - 1;
yBottom = temp_min;
yTop = temp_max;
for i = 1:length(startIdx)
    xs = [t(startIdx(i)), t(endIdx(i)), t(endIdx(i)), t(startIdx(i))];
    ys = [yBottom, yBottom, yTop, yTop];
    patch(xs, ys, 'r', 'FaceAlpha', 0.4, 'EdgeColor', 'none','DisplayName','--');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
indices=(e<0) & (de>0);
indices = indices(:);
d = diff([0; indices; 0]);
startIdx = find(d == 1);
endIdx   = find(d == -1) - 1;
yBottom = temp_min;
yTop = temp_max;
for i = 1:length(startIdx)
    xs = [t(startIdx(i)), t(endIdx(i)), t(endIdx(i)), t(startIdx(i))];
    ys = [yBottom, yBottom, yTop, yTop];
    patch(xs, ys, 'm', 'FaceAlpha', 0.4, 'EdgeColor', 'none','DisplayName','-+');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
indices=(e>0) & (de<0);
indices = indices(:);
d = diff([0; indices; 0]);
startIdx = find(d == 1);
endIdx   = find(d == -1) - 1;
yBottom = temp_min;
yTop = temp_max;
for i = 1:length(startIdx)
    xs = [t(startIdx(i)), t(endIdx(i)), t(endIdx(i)), t(startIdx(i))];
    ys = [yBottom, yBottom, yTop, yTop];
    patch(xs, ys, 'c', 'FaceAlpha', 0.4, 'EdgeColor', 'none','DisplayName','+-');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
indices=(e>0) & (de>0);
indices = indices(:);
d = diff([0; indices; 0]);
startIdx = find(d == 1);
endIdx   = find(d == -1) - 1;
yBottom = temp_min;
yTop = temp_max;
for i = 1:length(startIdx)
    xs = [t(startIdx(i)), t(endIdx(i)), t(endIdx(i)), t(startIdx(i))];
    ys = [yBottom, yBottom, yTop, yTop];
    patch(xs, ys, 'b', 'FaceAlpha', 0.4, 'EdgeColor', 'none','DisplayName','++');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% +- -> +
% -- -> + ya da 0
% -+ -> -
% ++ -> +

% +- -> 0
% -- -> -
% -+ -> 0
% ++ -> +

