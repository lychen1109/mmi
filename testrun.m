%script to run test
%running test with standard rbf kernel, direct method for A and B, smoothed
%error as objective fun
%[theta,output]=paramlearnotb2(label(cvp.training),feat(cvp.training,:),[0 0],@mysvmfun,@paramgrad,@logistregdirect,@smootherror,@svmoutputgraderr);
%decheck(label(cvp.training),feat(cvp.training,:),[0 0],@mysvmfun,@paramgrad,@logistregdirect,@smootherror,@svmoutputgraderr);

%single gamma, max likelihood
%[theta,output]=paramlearnotb2(label(cvp.training),feat(cvp.training,:),[0 0],@mysvmfun,@paramgrad,@logistreg,@svmllhood,@svmoutputgrad);

%row gamma, max likelihood
%[theta,fval,exitflag,output]=paramlearnotb2(label(cvp.training),feat(cvp.training,:),zeros(1,10),@rowsvmfun,@rowparamgrad,@logistreg,@svmllhood,@svmoutputgrad);

%batch learn of row gamma for cvpa
[thetaa_row1,fvala,exitflaga,outputc1]=rowgammalearn(label,feat,cvpa,thetaa_init_zero);