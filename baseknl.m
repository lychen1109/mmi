function kernelb=baseknl(label,datatrain,D)
%base kernel learner

[~,d_data]=size(datatrain);
A=datatrain*datatrain';
B=(label*label').*D;
K=datatrain*datatrain';
[V,E]=eig(A'*B*A,K);
E=diag(E);
[~,max_eigenvalue]=max(E);
v=V(:,max_eigenvalue);
w=sum(datatrain.*repmat(v,1,d_data));
w=w/norm(w);
kernelb=w'*w;
