function [C,G,CV]=svmgrid2(grp,data,display,type,rangec,rangeg,kernel,T,n_test)
%random sample, search for bestcv repeatedly

C=zeros(T,1);
G=zeros(T,1);
CV=zeros(T,1);

for t=1:T
    traincvp=cvpartition(grp,'holdout',n_test);
    [c,g,cv]=svmgrid_np(grp(traincvp.training),data(traincvp.training,:),display,type,rangec,rangeg,kernel);
    C(t)=c;
    G(t)=g;
    CV(t)=cv;
    fprintf('%g %g %g\n',g,c,cv);
end

  