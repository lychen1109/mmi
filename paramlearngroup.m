function [theta,fval,exitflag,output,history]=paramlearnotbgroup(labeltrain,datatrain,labeltest,datatest,theta,group)
%paramlearn toolbox version using fminunc
%move A and B out of theta

n_data=size(datatrain,1);
K=5; %fold number
cvp=cvpartition(labeltrain,'Kfold',K);
history.thetas=[];
history.fvals=[];
history.accutests=[];
history.accuvalis=[];

opt=optimset('GradObj','on','LargeScale','off','display','iter-detailed','DerivativeCheck','on','diffmin',1e-2,...
            'Tolfun',1e-3,'tolx',1e-3,'outputfcn',@outfun);
[theta,fval,exitflag,output]=fminunc(@myfun,theta,opt);

    function [L,grad]=myfun(theta)
        fprintf('evaluating myfun with theta\n');
        disp(theta);
        modelstructs(1:K)=emptymodelstruct;
        dvalues=zeros(n_data,1);
        ac=zeros(K,1);
        for i=1:K
            [modelstructs(i),accu,dvalues(cvp.test(i))]=groupsvmfun(labeltrain(cvp.training(i)),datatrain(cvp.training(i),:),...
                                            labeltrain(cvp.test(i)),datatrain(cvp.test(i),:),group,theta);
            ac(i)=accu(1);
        end
        fprintf('average validation accuracy is %g (%g)\n',mean(ac),std(ac));
        [A,B]=logistreg(labeltrain,dvalues);
        L=svmllhood(labeltrain,dvalues,A,B);
        fprintf('logistic regression result: A=%g, B=%g, L=%g\n',A,B,L);
        
        if nargout>1
            grad=zeros(K,length(theta));
            for i=1:K
                fprintf('processing fold:%d\n',i);
                grad(i,:)=groupparamgrad(labeltrain(cvp.test(i)),datatrain(cvp.test(i),:),dvalues(cvp.test(i)),modelstructs(i),theta,A,B,@svmoutputgrad,group);
            end
            grad=sum(grad);
        end        
    end

    function stop=outfun(theta,optimValues,state)
        stop=false;
        if strcmp(state,'iter')
            history.thetas=[history.thetas;theta];
            history.fvals=[history.fvals;optimValues.fval];
            [~,accu,~]=groupmysvmfun(labeltrain,datatrain,labeltest,datatest,group,theta);
            history.accutests=[history.accutests;accu(1)];
            
            ac=zeros(K,1);
            for i=1:K
                [~,accu,~]=groupsvmfun(labeltrain(cvp.training(i)),datatrain(cvp.training(i),:),labeltrain(cvp.test(i)),...
                                datatrain(cvp.test(i),:),group,theta);
                ac(i)=accu(1);
            end
            history.accuvalis=[history.accuvalis;mean(ac)];
        end
    end
end