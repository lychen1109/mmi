function [w0,flag]=gradient_descend(train_label,x,w0,sigma,MAX_iter,step)
%calculate w with gradiient descend method
%flag=0: deltaI<Tol
%flag=1: max(|g|)<Tol
%flag=2: itermax reached

%fid=fopen('MMI3.txt','w');
%standard output=1
fid=1;

DEBUG=false;

if isempty(w0)    
    tmp=randn(1,4);
    w0=tmp/norm(tmp);
    if DEBUG
       fprintf(fid,'w0 is initialized as (%f,%f,%f,%f)\n',w0(1),w0(2),w0(3),w0(4)); 
    end    
end

Tol=1e-6;%a small number for precision

iter=1;
Ipre=mymi2(train_label,x*w0',sigma);
g=mymi_grad2(train_label,w0,x,sigma);
w0=w0+step*g;w0=w0/norm(w0);
I=mymi2(train_label,x*w0',sigma);
deltaI=I-Ipre;
if DEBUG
    fprintf(fid,'iter=%d, deltaI=%e,norm_g=(%e,%e,%e,%e), w=(%f,%f,%f,%f)\n',iter,deltaI,g(1),g(2),g(3),g(4),w0(1),w0(2),w0(3),w0(4));
end

while iter< MAX_iter && deltaI>Tol && maxabs(g)>Tol
    iter=iter+1;
    Ipre=I;
    g=mymi_grad2(train_label,w0,x,sigma);
    w0=w0+step*g;w0=w0/norm(w0);
    I=mymi2(train_label,x*w0',sigma);
    deltaI=I-Ipre;
    if DEBUG
        fprintf(fid,'iter=%d, deltaI=%e,norm_g=(%e,%e,%e,%e), w=(%f,%f,%f,%f)\n',iter,deltaI,g(1),g(2),g(3),g(4),w0(1),w0(2),w0(3),w0(4));
    end
end

if ~iter<MAX_iter
    flag=2;
elseif deltaI<Tol
    flag=0;
else
    flag=1;
end

%close the file
%fclose(fid);

function ma=maxabs(g)
%max absolute value of gradient
tmp=abs(g);
ma=max(tmp(:));

