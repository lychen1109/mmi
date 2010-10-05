function g=mymi_grad(train_label,w,x,sigma)
% gradiant of mutual information

y=x*w';
N=size(y,1);
g=zeros(size(w));

for i=1:N
   yp=y(train_label==train_label(i),:);
   Jp=size(yp,1);
   tmp=0;
   for j=1:Jp
      tmp=tmp+gauss_kernel((yp(j,:)-y(i,:))',sigma)*(yp(j,:)-y(i,:))'; 
   end
   gVIN=tmp/(N*sigma)^2;
   
   tmp1=0;
   for p=0:1
       Jp=length(find(train_label==p));
       tmp1=tmp1+(Jp/N)^2;
   end
   tmp=0;
   for j=1:N
      tmp=tmp+gauss_kernel((y(j,:)-y(i,:))',sigma)*(y(j,:)-y(i,:))'; 
   end
   gVALL=tmp1*tmp/(N*sigma)^2;
   
   Jc=length(find(train_label==train_label(i)));
   tmp1=0;
   for p=0:1
      yp=y(train_label==p,:);
      Jp=size(yp,1);
      tmp=0;
      for j=1:Jp
         tmp=tmp+gauss_kernel((yp(j,:)-y(i,:))',sigma)*(yp(j,:)-y(i,:))'; 
      end
      tmp1=tmp1+(Jc+Jp)*tmp/(2*N);
   end
   gVBTW=tmp1/(N*sigma)^2;
   
   g=g+(gVIN+gVALL-2*gVBTW)*x(i,:);
end
