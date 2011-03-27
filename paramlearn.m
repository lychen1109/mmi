function [theta,history]=paramlearn(labeltrain,datatrain,theta,mysvmfun,paramgrad,step)
%paramlearn: learn the best parameter of standard gauss kernel and
%probability params

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
%cmd=['-c ' num2str(2^theta(1)) ' -g ' num2str(2^theta(2))];
thetas=zeros(200,length(theta)); %for record history
ofuns=zeros(200,1);%record of objective fun
ofunold=-1e5;
deltaofun=1e5;
Tol=1e-3;
iter=0;

while deltaofun>Tol && iter<30
    iter=iter+1;    
    for i=1:K
        [modelstructs(i),~,dvalues(cvp.test(i))]=mysvmfun(labeltrain(cvp.training(i)),datatrain(cvp.training(i),:),labeltrain(cvp.test(i)),datatrain(cvp.test(i),:),theta);
    end
    
    [A,B,ofun]=logistreg(labeltrain,dvalues);
    ofun=-ofun;
    fprintf('full objective fun is %g\n',ofun);
    grad=zeros(K,length(theta));
    
    for i=1:K
        fprintf('processing fold:%d\n',i);
        %model=svmtrain(labeltrain(cvp.training(i)),datatrain(cvp.training(i),:),cmd);
        %[~,accu,dvalues]=svmpredict(labeltrain(cvp.test(i)),datatrain(cvp.test(i),:),model);
        
        %fprintf('accuracy:%g\n',accu(1));        
        %modelstruct=modelparser(model,datatrain(cvp.training(i),:),2^theta(1));
        grad(i,:)=paramgrad(labeltrain(cvp.test(i)),datatrain(cvp.test(i),:),dvalues(cvp.test(i)),modelstructs(i),theta,A,B);
        disp('grad is');
        disp(grad(i,:));
        %fprintf('objective fun is %g\n',Like(i));
    end
    disp('++++++++++++++++++++');
    %fprintf('average accuracy: %g\n',mean(accus));
    fullgrad=sum(grad);
    fprintf('full grad is\n');
    disp(fullgrad);    
    deltaofun=(ofun-ofunold)/abs(ofun);
    fprintf('deltaofun:%g\n',deltaofun);
    ofunold=ofun;
    disp('++++++++++++++++++++');        
    thetas(iter,:)=theta;
    ofuns(iter)=ofun;
    if deltaofun>0
        theta=theta+step*fullgrad;
    else
        theta=thetas(iter-1,:);
    end
end
history.thetas=thetas(1:iter,:);
history.ofuns=ofuns(1:iter);