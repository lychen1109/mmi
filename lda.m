function w=lda(train_label,x)
% calculate lda transform

x_au=x(train_label==0,:);
x_sp=x(train_label==1,:);

w=(cov(x_au)+cov(x_sp))\(mean(x_au)-mean(x_sp))';

w=w/norm(w);