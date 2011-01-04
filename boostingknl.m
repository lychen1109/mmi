function kernel=boostingknl(label,datatrain,T)
% Boosting kernel learner
% T: number of iteration

[~,d_data]=size(datatrain);
kernel=zeros(d_data,d_data);

for t=1:T
    %calculate distribution over labeled pairs
    D=(datatrain*kernel*datatrain').*(label*label');
    D=exp(-D);
    D=D/sum(D(:));
    
    %call base kernel learner
    kernelb=baseknl(label,datatrain,D);
    
    %calculate base kernel weight
    K_b=datatrain*kernelb*datatrain';
    S=(label*label').*K_b;
    W=D.*abs(K_b);
    Wp=sum(W(S>0));
    Wm=sum(W(S<0));
    alpha=0.5*log(Wp/Wm);
    kernel=kernel+alpha*kernelb;
end

    
    