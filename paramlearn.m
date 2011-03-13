function theta=paramlearn(labeltrain,datatrain)
%paramlearn: learn the best parameter of standard gauss kernel and
%probability params

K=3; %fold number
cvp=cvpartition(labeltrain,'Kfold',K);
theta=[0 0 -1 0]; %initial value
cmd=['-c ' num2str(2^theta(1)) ' -g ' num2str(2^theta(2))];
step=0.01;

for loop=1:10
    accus=zeros(K,1);
    grad=zeros(K,size(theta,2));
    Like=zeros(K,1);
    for i=1:K
        fprintf('processing fold:%d\n',i);
        model=svmtrain(labeltrain(cvp.training(i)),datatrain(cvp.training(i),:),cmd);
        [~,accu,dvalues]=svmpredict(labeltrain(cvp.test(i)),datatrain(cvp.test(i),:),model);
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
    fprintf('full objective fun is %g\n',sum(Like));
    disp('++++++++++++++++++++');
    theta=theta+step*fullgrad;
end