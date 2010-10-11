function [I,g]=mymi3(train_label,w,x,sigma)
%calculate I and g in one program

%size of w and x should fit
if size(w,2) ~= size(x,2)
   fprintf('Size of w and x do not fit.\n'); return; 
end

N=size(x,1);
% size of train_label and x should fit
if N~=size(train_label,1)
   fprintf('Size of label and sample do not fit.\n');return; 
end

%start matlabpool if it's not started
if matlabpool('size') == 0
    matlabpool;
end

y=x*w';
x_au=x(train_label==0,:);
x_sp=x(train_label==1,:);
y_au=x_au*w';
y_sp=x_sp*w';
J_au=size(y_au,1);
J_sp=size(y_sp,1);
fnum=size(x,2);

tmpa=(J_au/N)^2+(J_sp/N)^2;%sum component used in loop

%%%VIN%%%

VIN=0;
gVIN=zeros(size(w));

%--VIN/au/au--
D1=repmat(y_au',1,J_au);
%D2=zeros(size(y_au')); D2=repmat(D2,1,J_au);
D2=zeros(size(D1,1),J_au^2);
D3=zeros(fnum,J_au^2);
for i=1:J_au
   tmp=repmat(y_au(i,:)',1,J_au);
   D2(:,(i-1)*J_au+(1:J_au))=tmp;
   tmp2=repmat(x_au(i,:)',1,J_au);
   D3(:,(i-1)*J_au+(1:J_au))=tmp2;
end
D=D1-D2;
tmpVIN=0;
tmpgVIN=zeros(size(w));
parfor i=1:J_au^2
    gk=gauss_kernel(D(:,i),sigma);
    tmpVIN=tmpVIN+gk;
    tmpgVIN=tmpgVIN+gk*D(:,i)*D3(:,i)';
end
VIN=VIN+(1/N^2)*tmpVIN;
gVIN=gVIN+tmpgVIN/(N*sigma)^2;

%--VIN/sp/sp----
D1=repmat(y_sp',1,J_sp);
D2=zeros(size(D1,1),J_sp^2);
D3=zeros(fnum,J_sp^2);
for i=1:J_sp
   tmp=repmat(y_sp(i,:)',1,J_sp);
   D2(:,(i-1)*J_sp + (1:J_sp))=tmp;
   tmp2=repmat(x_sp(i,:)',1,J_sp);
   D3(:,(i-1)*J_sp + (1:J_sp))=tmp2;
end
D=D1-D2;
tmpVIN=0;
tmpgVIN=zeros(size(w));
parfor i=1:J_sp^2
    gk=gauss_kernel(D(:,i),sigma);
    tmpVIN=tmpVIN+gk;
    tmpgVIN=tmpgVIN+gk*D(:,i)*D3(:,i)';
end
VIN=VIN+tmpVIN/N^2;
gVIN=gVIN+tmpgVIN/(N*sigma)^2;

%%%VALL%%%

D1=repmat(y',1,N);
D2=zeros(size(D1,1),N^2);
D3=zeros(fnum,N^2);
for i=1:N
   tmp=repmat(y(i,:)',1,N);
   D2(:,(i-1)*N+(1:N))=tmp;
   tmp2=repmat(x(i,:)',1,N);
   D3(:,(i-1)*N+(1:N))=tmp2;
end
D=D1-D2;
tmpVALL=0;
tmpgVALL=zeros(size(w));
parfor i=1:N^2
    gk=gauss_kernel(D(:,i),sigma);
    tmpVALL=tmpVALL+gk;
    tmpgVALL=tmpgVALL+gk*D(:,i)*D3(:,i)';
end
VALL=tmpVALL*tmpa/N^2;
gVALL=tmpgVALL*tmpa/(N*sigma)^2;

%%%VBTW%%%

VBTW=0;
gVBTW=zeros(size(w));

%---au/au---
D1=repmat(y_au',1,J_au);
D2=zeros(size(D1,1),J_au^2);
D3=zeros(fnum,J_au^2);
for i=1:J_au
   tmp=repmat(y_au(i,:)',1,J_au);
   D2(:,(i-1)*J_au+(1:J_au))=tmp;
   tmp2=repmat(x_au(i,:)',1,J_au);
   D3(:,(i-1)*J_au+(1:J_au))=tmp2;
end
D=D1-D2;
tmp=0;
tmpg=zeros(size(w));
parfor i=1:J_au^2
   gk=gauss_kernel(D(:,i),sigma);
   tmp=tmp+gk;
   tmpg=tmpg+gk*D(:,i)*D3(:,i)';
end
VBTW=VBTW+tmp*J_au/N^3;
gVBTW=gVBTW+tmpg*(J_au/N)/(N*sigma)^2;

%--sp/au---
D1=repmat(y_sp',1,J_au);
D2=zeros(size(D1,1),J_au*J_sp);
D3=zeros(fnum,J_au*J_sp);
for i=1:J_au
   tmp=repmat(y_au(i,:)',1,J_sp);
   D2(:,(i-1)*J_sp+(1:J_sp))=tmp;
   tmp2=repmat(x_au(i,:)',1,J_sp);
   D3(:,(i-1)*J_sp+(1:J_sp))=tmp2;
end
D=D1-D2;
tmp=0;
tmpg=zeros(size(w));
parfor i=1:J_au*J_sp
    gk=gauss_kernel(D(:,i),sigma);
    tmp=tmp+gk;
    tmpg=tmpg+gk*D(:,i)*D3(:,i)';
end
VBTW=VBTW+tmp*J_sp/N^3;
gVBTW=gVBTW+tmpg*0.5/(N*sigma)^2;

%--au/sp---
D1=repmat(y_au',1,J_sp);
D2=zeros(size(D1,1),J_au*J_sp);
D3=zeros(fnum,J_au*J_sp);
for i=1:J_sp
   tmp=repmat(y_sp(i,:)',1,J_au);
   D2(:,(i-1)*J_au+(1:J_au))=tmp;
   tmp2=repmat(x_sp(i,:)',1,J_au);
   D3(:,(i-1)*J_au+(1:J_au))=tmp2;
end
D=D1-D2;
tmp=0;
tmpg=zeros(size(w));
parfor i=1:J_au*J_sp
    gk=gauss_kernel(D(:,i),sigma);
    tmp=tmp+gk;
    tmpg=tmpg+gk*D(:,i)*D3(:,i)';
end
VBTW=VBTW+tmp*J_au/N^3;
gVBTW=gVBTW+tmpg*0.5/(N*sigma)^2;

%--sp/sp--
D1=repmat(y_sp',1,J_sp);
D2=zeros(size(D1,1),J_sp^2);
D3=zeros(fnum,J_sp^2);
for i=1:J_sp
   tmp=repmat(y_sp(i,:)',1,J_sp);
   D2(:,(i-1)*J_sp+(1:J_sp))=tmp;
   tmp2=repmat(x_sp(i,:)',1,J_sp);
   D3(:,(i-1)*J_sp+(1:J_sp))=tmp2;
end
D=D1-D2;
tmp=0;
tmpg=zeros(size(w));
parfor i=1:J_sp^2
    gk=gauss_kernel(D(:,i),sigma);
    tmp=tmp+gk;
    tmpg=tmpg+gk*D(:,i)*D3(:,i)';
end
VBTW=VBTW+tmp*J_sp/N^3;
gVBTW=gVBTW+tmpg*(J_sp/N)/(N*sigma)^2;

%--- result ----
I=VIN+VALL-2*VBTW;
g=gVIN+gVALL-2*gVBTW;


