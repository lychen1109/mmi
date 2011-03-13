function svmgrid2(grp,data,type,rangec,rangeg,T,n_test)
%random sample, search for bestcv repeatedly

for t=1:T
    traincvp=cvpartition(grp,'holdout',n_test);
    tic;
    [g,c,cv]=svmgrid(grp(traincvp.training),data(traincvp.training,:),type,rangec,rangeg);
    tt=toc;
    fprintf('c=%g g=%g cv=%g in %g sec\n',c,g,cv,tt);
end

  