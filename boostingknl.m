function [kernel,alpha,kernelb]=boostingknl(label,datatrain,datatest,T,kernel_init)
% Boosting kernel learner
% T: number of iteration

[~,d_data]=size(datatrain);
if nargin<4
    kernel=zeros(d_data,d_data);
else
    kernel=kernel_init;
end

alpha=zeros(T,1);
kernelb=zeros(d_data,d_data,T);

for t=1:T
    %calculate distribution over labeled pairs
    D=(datatrain*kernel*datatrain').*(label*label');
    D=exp(-D);
    D=D/sum(D(:));
    
    %call base kernel learner
    kernelb(:,:,t)=baseknl(label,datatrain,datatest,D);
    
    %calculate base kernel weight
    K_b=datatrain*kernelb(:,:,t)*datatrain';
    S=(label*label').*K_b;
    W=D.*abs(K_b);
    Wp=sum(W(S>0));
    Wm=sum(W(S<0));
    alpha(t)=0.5*log(Wp/Wm);
    kernel=kernel+alpha(t)*kernelb(:,:,t);
    disp(t);
end

    
    