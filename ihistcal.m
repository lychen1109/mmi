function I_hist=ihistcal(w_hist,train_label,x,sigma)
% calculate I_hist

wnum=size(w_hist,1);
I_hist=zeros(wnum,1);
for i=1:wnum
   w=w_hist(i,:);
   I_hist(i)=mymi(train_label,x*w',sigma);
   fprintf('I_hist(%d)=%f\n',i,I_hist(i));
end