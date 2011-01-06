function [C,accu_training,accu_test]=kerneltest2(label,data,cvp,alpha,kernelb)
%test kernel performance in every 5 iters

levels=[5 10 15 20 25 30 35 40];
n_levels=length(levels);
C=zeros(n_levels,1);
accu_training=zeros(n_levels,1);
accu_test=zeros(n_levels,1);

for l=1:n_levels
    kernel=kernelcalc(zeros(81,81),alpha,kernelb,levels(l));
    [~,C(l),~]=svmgrid_np(label(cvp.training),data(cvp.training,:),0,4,-5:2:15,1:1,kernel);
    cmd=['-c ' num2str(C(l)) ' -t 4'];
    [accu_training(l),accu_test(l)]=kerneltest(label,data,cvp,kernel,cmd);
end

    
    
    