function subplottest(tm1,tm2)
%test how to change zlim of subplot

subplot(1,2,1);
mesh(tm1);
a1=gca;
zlim1=get(a1,'zlim');
subplot(1,2,2);
mesh(tm2);
a2=gca;
zlim2=get(a2,'zlim');

zmax=max([zlim1(2) zlim2(2)]);
set(a1,'zlim',[0 zmax]);
set(a2,'zlim',[0 zmax]);
