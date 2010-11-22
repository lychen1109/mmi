function [w,iter]=mmi(label,x,MAX_iter,step,display,Tol)
%calculate w with gradiient descend method
%display 0:nothing 1:iteration

%a small number for precision
if isempty(Tol)
    Tol=1e-6;
end
iter=1;

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
while iter< MAX_iter && deltaI>Tol            
    [Inew,g]=mymi3(label,w,x,sigma,0);
    
    %update w
    w=w+step*g;w=w/norm(w);    
    
    deltaI=Inew-Ipre;    
    if display==1
        fprintf('iteration %d delta %e (%e)\n',iter,deltaI,Inew);
    end
    iter=iter+1;
    Ipre=Inew;
end





