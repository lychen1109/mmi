%script to run test
%running test with standard rbf kernel, direct method for A and B, smoothed
%error as objective fun
[theta,output]=paramlearnotb2(label(cvp.training),feat(cvp.training,:),[0 0],@mysvmfun,@paramgrad,@logistregdirect,@smootherror,@svmoutputgraderr);
%decheck(label(cvp.training),feat(cvp.training,:),[0 0],@mysvmfun,@paramgrad,@logistregdirect,@smootherror,@svmoutputgraderr);