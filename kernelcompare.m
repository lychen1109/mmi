function kernelcompare(x,y)
%compare distance and computing time of two kernels

tic;
dist1=norm(x-y)^2;
t=toc;
fprintf('gauss distance is %g, calculated in %d sec\n',dist1,t);

theta=zeros(1,10);
tic;
dist2=rowrbfdist(x,y,theta);
t=toc;
fprintf('row rbf distance is %g, calculated in %d sec\n',dist2,t);