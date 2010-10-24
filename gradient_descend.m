function [w,flag,iter]=gradient_descend(label,x,MAX_iter,step,display,Tol)
%calculate w with gradiient descend method
%flag=0: deltaI<Tol
%flag=2: itermax reached
%display 0:nothing 1:iteration

%a small number for precision
if isempty(Tol)
    Tol=1e-6;
end
%M=3000;%number of random sample drawed
flag=-1;
iter=1;
MIN_iter=30;%at least 30 iteration is required

if size(x,2)<2
    w=1;    
    return;
end

%initialize with LDA
w=lda(label,x)';
y=x*w';
sigma=(max(y)-min(y))/2;

deltaI=inf;
Ipre=0;
J0=length(label(label==0));
J1=length(label(label==1));
M=J0*J1;
x0=x(label==0,:);
x1=x(label==1,:);
gk0=gauss_kernel(0,sigma);

while iter< MAX_iter && (iter<MIN_iter || deltaI>Tol)            
    %draw M sample pairs
    %samples=randomsample(J0,J1,M);
    samples=fullsample(J0,J1);
    Inew=0;
    g=zeros(size(w));
    parfor i=1:M        
        samplepair=samples(i,:);
        l0=samplepair(1);
        l1=samplepair(2);
        d=w*(x1(l1,:)'-x0(l0,:)');
        gk=gauss_kernel(d,sigma);
        Inew=Inew+0.25*(gk0-gk);
        g=g-(1/8*sigma^2)*gk*d*(x0(l0,:)-x1(l1,:));        
    end     
    Inew=Inew/M;
    g=g/M;
    %update w
    w=w+step*g;w=w/norm(w);    
    
    deltaI=Inew-Ipre;    
    if display==1
        fprintf('iteration %d delta %e (%e)\n',iter,deltaI,Inew);
    end
    iter=iter+1;
    Ipre=Inew;
end

if iter >= MAX_iter
    flag=2;
else
    flag=0;
end



