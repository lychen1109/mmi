function [theta,output]=paramlearnotb2(labeltrain,datatrain,theta,mysvmfun,paramgrad)
%paramlearn toolbox version using fminunc
%move A and B out of theta

%creat an empty struct
modelstruct.SVs=[];
modelstruct.SVsu=[];
modelstruct.SVsc=[];
modelstruct.Y=[];
modelstruct.Yc=[];
modelstruct.Yu=[];
modelstruct.alphau=[];
modelstruct.alphac=[];
modelstruct.rho=[];
modelstructs(1:5)=modelstruct;

n_data=size(datatrain,1);
dvalues=zeros(n_data,1);
K=5; %fold number
cvp=cvpartition(labeltrain,'Kfold',K);
opt=optimset('GradObj','on','LargeScale','off','display','iter-detailed','DerivativeCheck','on');
[theta,fval,exitflag,output]=fminunc(@myfun,theta,opt);
fprintf('optimization finished with fval=%g, and exitflag %d\n',fval,exitflag);

    function [L,grad]=myfun(theta)
        fprintf('evaluating myfun with theta\n');
        disp(theta);        
        for i=1:K
            [modelstructs(i),~,dvalues(cvp.test(i))]=mysvmfun(labeltrain(cvp.training(i)),datatrain(cvp.training(i),:),labeltrain(cvp.test(i)),datatrain(cvp.test(i),:),theta);
        end
        [A,B,L]=logistreg(labeltrain,dvalues);
        fprintf('logistic regression result: A=%g, B=%g, L=%g\n',A,B,L);
        
        if nargout>1
            grad=zeros(K,length(theta));
            for i=1:K
                fprintf('processing fold:%d\n',i);
                grad(i,:)=paramgrad(labeltrain(cvp.test(i)),datatrain(cvp.test(i),:),dvalues(cvp.test(i)),modelstructs(i),theta,A,B);
            end
            grad=-sum(grad);
        end        
    end
end