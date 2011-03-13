function [theta,history]=paramlearn(labeltrain,datatrain,theta,mysvmfun)
%paramlearn: learn the best parameter of standard gauss kernel and
%probability params

K=3; %fold number
cvp=cvpartition(labeltrain,'Kfold',K);
%cmd=['-c ' num2str(2^theta(1)) ' -g ' num2str(2^theta(2))];
step=0.01;
thetas=theta; %for record history
ofuns=[];%record of objective fun
ofunold=-1e5;
deltaofun=1e5;
Tol=1e-3;

while deltaofun>Tol
    accus=zeros(K,1);
    grad=zeros(K,size(theta,2));
    Like=zeros(K,1);
    for i=1:K
        fprintf('processing fold:%d\n',i);
        %model=svmtrain(labeltrain(cvp.training(i)),datatrain(cvp.training(i),:),cmd);
        %[~,accu,dvalues]=svmpredict(labeltrain(cvp.test(i)),datatrain(cvp.test(i),:),model);
        [model,accu,dvalues]=mysvmfun(labeltrain(cvp.training(i)),datatrain(cvp.training(i),:),labeltrain(cvp.test(i)),datatrain(cvp.test(i),:),theta);
        %fprintf('accuracy:%g\n',accu(1));
        accus(i)=accu(1);
        [grad(i,:),Like(i)]=paramgrad(labeltrain(cvp.test(i)),datatrain(cvp.test(i),:),dvalues,model,theta);
        disp('grad is');
        disp(grad(i,:));
        fprintf('objective fun is %g\n',Like(i));
    end
    disp('++++++++++++++++++++');
    fprintf('average accuracy: %g\n',mean(accus));
    fullgrad=sum(grad);
    fprintf('full grad is\n');
    disp(fullgrad);
    ofun=sum(Like);
    fprintf('full objective fun is %g\n',ofun);
    deltaofun=(ofun-ofunold)/abs(ofun);
    fprintf('deltaofun:%g\n',deltaofun);
    ofunold=ofun;
    disp('++++++++++++++++++++');
    theta=theta+step*fullgrad;    
    thetas=[thetas;theta];
    ofuns=[ofuns;ofun];
end
history.thetas=thetas;
history.ofuns=ofuns;