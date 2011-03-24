function [theta,output]=paramlearnotb(labeltrain,datatrain,theta,mysvmfun,paramgrad)
%paramlearn toolbox version using fminunc

K=5; %fold number
cvp=cvpartition(labeltrain,'Kfold',K);
nf=0; %number of ofun run
ng=0; %number of grad run
opt=optimset('GradObj','on','LargeScale','off','display','iter-detailed','de','on');
[theta,fval,exitflag,output]=fminunc(@myfun,theta,opt);
fprintf('optimization finished with fval=%g, and exitflag %d\n',fval,exitflag);
fprintf('function runed %d times, grad calculated %d times\n',nf,ng);

    function [L,grad]=myfun(theta)
        Like=zeros(K,1);
        if nargout>1
            grad=zeros(K,length(theta));
        end
        for i=1:K
            fprintf('processing fold:%d\n',i);
            [modelstruct,~,dvalues]=mysvmfun(labeltrain(cvp.training(i)),datatrain(cvp.training(i),:),labeltrain(cvp.test(i)),datatrain(cvp.test(i),:),theta);
            Like(i)=svmllhood(labeltrain(cvp.test(i)),dvalues,theta(end-1),theta(end));
            if nargout>1
                grad(i,:)=paramgrad(labeltrain(cvp.test(i)),datatrain(cvp.test(i),:),dvalues,modelstruct,theta);
            end
        end
        L=-sum(Like);
        nf=nf+1;
        if nargout>1
            grad=-sum(grad);
            ng=ng+1;
        end
    end
end