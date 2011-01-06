function kernelb=baseknl(label,datatrain,datatest,D)
%base kernel learner

[~,d_data]=size(datatrain);
A=datatrain*datatest';
B=(label*label').*D;
K=datatest*datatest';
[V,E]=eig(A'*B*A,K);
E=diag(E);
[~,max_eigenvalue]=max(E);
v=V(:,max_eigenvalue);
w=sum(datatest.*repmat(v,1,d_data));
w=w/norm(w);
kernelb=w'*w;
