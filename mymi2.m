function mi=mymi2(train_label,y,sigma)
%parallel version of mymi

N=size(y,1);

yau=y(train_label==0,:);
ysp=y(train_label==1,:);
Jau=size(yau,1);
Jsp=size(ysp,1);
tmpa=(Jau/N)^2+(Jsp/N)^2;
mi=0;

for i=1:Jau
   tmp=0;
   for j=1:Jau
      tmp=tmp+gauss_kernel((yau(j,:)-yau(i,:))',sigma); 
   end
   VIN=tmp/N^2;
   
   tmp=0;
   for j=1:N
      tmp=tmp+gauss_kernel((y(j,:)-yau(i,:))',sigma); 
   end
   VALL=tmp*tmpa/N^2;
   
   tmp=0;
   for j=1:Jau
       tmp=tmp+(Jau/N)*gauss_kernel((yau(j,:)-yau(i,:))',sigma);
   end
   for j=1:Jsp
       tmp=tmp+(Jsp/N)*gauss_kernel((ysp(j,:)-yau(i,:))',sigma);
   end
   VBTW=tmp/N^2;
   
   mi=mi+VIN+VALL-2*VBTW;
end

for i=1:Jsp
   tmp=0;
   for j=1:Jsp
      tmp=tmp+gauss_kernel((ysp(j,:)-ysp(i,:))',sigma); 
   end
   VIN=tmp/N^2;
   
   tmp=0;
   for j=1:N
      tmp=tmp+gauss_kernel((y(j,:)-ysp(i,:))',sigma); 
   end
   VALL=tmp*tmpa/N^2;
   
   tmp=0;
   for j=1:Jau
       tmp=tmp+(Jau/N)*gauss_kernel((yau(j,:)-ysp(i,:))',sigma);
   end
   for j=1:Jsp
       tmp=tmp+(Jsp/N)*gauss_kernel((ysp(j,:)-ysp(i,:))',sigma);
   end
   VBTW=tmp/N^2;
   
   mi=mi+VIN+VALL-2*VBTW;
end



