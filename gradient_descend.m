function [w0,flag,iter]=gradient_descend(train_label,x,w0,sigma,MAX_iter,step)
%calculate w with gradiient descend method
%flag=0: deltaI<Tol
%flag=1: max(|g|)<Tol
%flag=2: itermax reached

if isempty(w0)    
    tmp=randn(1,4);
    w0=tmp/norm(tmp);       
end

Tol=1e-6;%a small number for precision

iter=0;
[Ipre,gpre]=mymi3(train_label,w0,x,sigma,0);
deltaI=inf;

while iter< MAX_iter && abs(deltaI)>Tol && maxabs(gpre)>Tol
    iter=iter+1;
    w0=w0+step*gpre;w0=w0/norm(w0);    
    [Inew,gnew]=mymi3(train_label,w0,x,sigma,0);
    deltaI=Inew-Ipre;
    Ipre=Inew;
    gpre=gnew;
end

if iter >= MAX_iter
    flag=2;
elseif abs(deltaI)<=Tol
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

