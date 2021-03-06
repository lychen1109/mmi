function decheck(labeltrain,datatrain,theta,mysvmfun,paramgrad,logistreg,objfun,svmoutputgrad)
%derivative check

deltas=10.^(-8:0);
cvp=cvpartition(labeltrain,'kfold',5);
[L,grad]=obfun(labeltrain,datatrain,cvp,theta,mysvmfun,paramgrad,logistreg,objfun,svmoutputgrad);
fprintf('current obfun is %g\n',L);
fprintf('grad calculated:\n');
disp(grad);

fprintf('calculating forward difference\n');
for i=1:length(deltas)
    delta=deltas(i);
    L1=obfun(labeltrain,datatrain,cvp,theta+[delta,0],mysvmfun,paramgrad,logistreg,objfun,svmoutputgrad);
    L2=obfun(labeltrain,datatrain,cvp,theta+[0,delta],mysvmfun,paramgrad,logistreg,objfun,svmoutputgrad);
    fprintf('difference calculated with delta %g is\n',delta);
    gradf=[L1-L,L2-L]/delta;
    disp(gradf);
end

fprintf('calculating central difference\n');
for i=1:length(deltas)
    delta=deltas(i);
    L1=obfun(labeltrain,datatrain,cvp,theta+[delta/2,0],mysvmfun,paramgrad,logistreg,objfun,svmoutputgrad);
    L2=obfun(labeltrain,datatrain,cvp,theta+[0,delta/2],mysvmfun,paramgrad,logistreg,objfun,svmoutputgrad);
    L3=obfun(labeltrain,datatrain,cvp,theta-[delta/2,0],mysvmfun,paramgrad,logistreg,objfun,svmoutputgrad);
    L4=obfun(labeltrain,datatrain,cvp,theta-[0,delta/2],mysvmfun,paramgrad,logistreg,objfun,svmoutputgrad);
    fprintf('difference calculated with delta %g is\n',delta);
    gradc=[L1-L3,L2-L4]/delta;
    disp(gradc);
end

end
    
    
function [L,grad]=obfun(labeltrain,datatrain,cvp,theta,mysvmfun,paramgrad,logistreg,objfun,svmoutputgrad)

K=cvp.NumTestSets;
modelstructs(1:5)=emptymodelstruct;
dvalues=zeros(size(labeltrain));
for i=1:K
    [modelstructs(i),~,dvalues(cvp.test(i))]=mysvmfun(labeltrain(cvp.training(i)),datatrain(cvp.training(i),:),labeltrain(cvp.test(i)),datatrain(cvp.test(i),:),theta);
end
[A,B]=logistreg(labeltrain,dvalues);
L=objfun(labeltrain,dvalues,A,B);

if nargout>1
    grad=zeros(K,length(theta));
    for i=1:K
        fprintf('processing fold:%d\n',i);
        grad(i,:)=paramgrad(labeltrain(cvp.test(i)),datatrain(cvp.test(i),:),dvalues(cvp.test(i)),modelstructs(i),theta,A,B,svmoutputgrad);
    end
    grad=sum(grad);
end
end
    