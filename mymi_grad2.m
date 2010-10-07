function g=mymi_grad2(train_label,w,x,sigma)
% gradiant of mutual information
% This is the modified version for performance

%size of w and x should fit
if size(w,2) ~= size(x,2)
   fprintf('Size of w and x do not fit.\n'); return; 
end

N=size(x,1);
y=x*w';

% size of train_label and x should fit
if N~=size(train_label,1)
   fprintf('Size of label and sample do not fit.\n');return; 
end

x_au=x(train_label==0,:);
x_sp=x(train_label==1,:);
y_au=x_au*w';
y_sp=x_sp*w';
J_au=size(y_au,1);
J_sp=size(y_sp,1);

g=zeros(size(w));
tmpa=(J_au/N)^2+(J_sp/N)^2;%sum component used in loop

for i=1:J_au   
   tmp=0;
   for j=1:J_au
      tmp=tmp+gauss_kernel((y_au(j,:)-y_au(i,:))',sigma)*(y_au(j,:)-y_au(i,:))'; 
   end
   gVIN=tmp/(N*sigma)^2;   
   
   tmp=0;
   for j=1:N
      tmp=tmp+gauss_kernel((y(j,:)-y_au(i,:))',sigma)*(y(j,:)-y_au(i,:))'; 
   end
   gVALL=tmpa*tmp/(N*sigma)^2;   
        
   tmp=0;
   for j=1:J_au
       tmp=tmp+(J_au/N)*gauss_kernel((y_au(j,:)-y_au(i,:))',sigma)*(y_au(j,:)-y_au(i,:))';
   end
   for j=1:J_sp
       tmp=tmp+0.5*gauss_kernel((y_sp(j,:)-y_au(i,:))',sigma)*(y_sp(j,:)-y_au(i,:))';
   end   
   gVBTW=tmp/(N*sigma)^2;
   
   g=g+(gVIN+gVALL-2*gVBTW)*x_au(i,:);
end

for i=1:J_sp
    tmp=0;
    for j=1:J_sp
        tmp=tmp+gauss_kernel((y_sp(j,:)-y_sp(i,:))',sigma)*(y_sp(j,:)-y_sp(i,:))';
    end
    gVIN=tmp/(N*sigma)^2;
    
    tmp=0;
    for j=1:N
        tmp=tmp+gauss_kernel((y(j,:)-y_sp(i,:))',sigma)*(y(j,:)-y_sp(i,:))';
    end
    gVALL=tmpa*tmp/(N*sigma)^2;
    
    tmp=0;
    for j=1:J_au
        tmp=tmp+0.5*gauss_kernel((y_au(j,:)-y_sp(i,:))',sigma)*(y_au(j,:)-y_sp(i,:))';
    end
    for j=1:J_sp
        tmp=tmp+(J_sp/N)*gauss_kernel((y_sp(j,:)-y_sp(i,:))',sigma)*(y_sp(j,:)-y_sp(i,:))';
    end
    gVBTW=tmp/(N*sigma)^2;
    
    g=g+(gVIN+gVALL-2*gVBTW)*x_sp(i,:);
end
