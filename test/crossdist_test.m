function crossdist_test
%crossdist_test test function crossdist
%   Detailed explanation goes here

NA=1200;
NB=600;
A=rand(NA,81);
B=rand(NB,81);
group=fix(5*rand(81,1))+1; %randomly created 5 groups
theta=randn(1,5);
distmatAA=zeros(NA,NA);
distmatAB=zeros(NA,NB);

tic;
for i=1:NA-1
    for j=i+1:NA
        distmatAA(i,j)=groupdist(A(i,:),A(j,:),group,theta);
    end
end
distmatAA=distmatAA+distmatAA';
t=toc;
fprintf('distmatAA calculated in %g sec\n',t);

tic;
for i=1:NA
    for j=1:NB
        distmatAB(i,j)=groupdist(A(i,:),B(j,:),group,theta);
    end
end
t=toc;
fprintf('distmatAB calculated in %g sec\n',t);

gt=zeros(size(group));
for i=1:5
    gt(group==i)=theta(i);
end
gt=sqrt(2.^gt);

tic;
distmatAA2=crossdist2(A,A,gt);
t=toc;
fprintf('distmatAA2 calculated in %g sec\n',t);

tic;
distmatAB2=crossdist2(A,B,gt);
t=toc;
fprintf('distmatAB2 calculated in %g sec\n',t);

diff1=distmatAA-distmatAA2;
diff2=distmatAB-distmatAB2;
fprintf('max difference in distmatAA is %g\n',max(abs(diff1(:))));
fprintf('max difference in distmatAB is %g\n',max(abs(diff2(:))));


function dist=groupdist(s1,s2,group,theta)
n_group=max(group);
dist=0;
for i=1:n_group
    g=(group==i);
    dist=dist+2^theta(i)*norm(s1(g)-s2(g))^2;
end



