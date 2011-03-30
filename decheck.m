function decheck(labeltrain,datatrain,theta,mysvmfun,paramgrad)
%derivative check

deltas=10.^(-8:0);
cvp=cvpartition(labeltrain,'kfold',5);
[L,grad]=obfun(labeltrain,datatrain,cvp,theta,mysvmfun,paramgrad);
fprintf('current obfun is %g\n',L);
fprintf('grad calculated:\n');
disp(grad);

fprintf('calculating forward difference\n');
for i=1:length(deltas)
    delta=deltas(i);
    L1=obfun(labeltrain,datatrain,cvp,theta+delta,mysvumfun,paramgrad);
    fprintf('difference calculated with delta %g is %g\n',delta,(L1-L)/delta);
end

fprintf('calculating central difference\n');
for i=1:length(deltas)
    delta=deltas(i);
    L1=obfun(labeltrain,datatrain,cvp,theta+delta/2,mysvmfun,paramgrad);
    L2=obfun(labeltrain,datatrain,cvp,theta-delta/2,mysvmfun,paramgrad);
    fprintf('difference calculated with delta %g is %g\n',delta,(L1-L2)/delta);    
end

end
    
    
function [L,grad]=obfun(labeltrain,datatrain,cvp,theta,mysvmfun,paramgrad)

K=cvp.NumTestSets;
modelstructs(1:5)=emptymodelstruct;
dvalues=zeros(size(labeltrain));
for i=1:K
    [modelstructs(i),~,dvalues(cvp.test(i))]=mysvmfun(labeltrain(cvp.training(i)),datatrain(cvp.training(i),:),labeltrain(cvp.test(i)),datatrain(cvp.test(i),:),theta);
end
[A,B,L]=logistreg(labeltrain,dvalues);

if nargout>1
    grad=zeros(K,length(theta));
    for i=1:K
        fprintf('processing fold:%d\n',i);
        grad(i,:)=paramgrad(labeltrain(cvp.test(i)),datatrain(cvp.test(i),:),dvalues(cvp.test(i)),modelstructs(i),theta,A,B);
    end
    grad=-sum(grad);
end
end
    