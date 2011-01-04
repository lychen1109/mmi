function svmgrid2(grp,data,display,type,rangec,rangeg,kernel,T,n_test)
%random sample, search for bestcv repeatedly


for t=1:T
    traincvp=cvpartition(grp,'holdout',n_test);
    [c,g,cv]=svmgrid_np(grp(traincvp.training),data(traincvp.training,:),display,type,rangec,rangeg,kernel);    
    fprintf('%g %g %g\n',g,c,cv);
end

  