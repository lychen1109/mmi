function [theta,output]=paramlearnotb2(labeltrain,datatrain,theta,mysvmfun,paramgrad)
%paramlearn toolbox version using fminunc

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

n_data=size(datatrain,1);
K=5; %fold number
cvp=cvpartition(labeltrain,'Kfold',K);
opt=optimset('GradObj','on','LargeScale','off','display','iter-detailed','de','on','diffmi',1e-2);
[theta,fval,exitflag,output]=fminunc(@myfun,theta,opt);
fprintf('optimization finished with fval=%g, and exitflag %d\n',fval,exitflag);

    function [L,grad]=myfun(theta)
        fprintf('evaluating myfun with theta\n');
        disp(theta);        
        modelstructs(1:5)=modelstruct;
        dvalues=zeros(n_data,1);
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
end