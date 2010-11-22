function [w,iter]=mmi(label,x,N,MAX_iter,step,display,Tol)
%calculate w with gradiient descend method
%display 0:nothing 1:iteration

if nargin<4, MAX_iter=1e+4; end
if nargin<5, step=0.1; end
if nargin<6, display=1; end
if nargin<7, Tol=1e-6; end

n_feat=size(x,2);
w=rand(n_feat,N);
w=orth(w);

y=x*w;
sigma=mmi_sigma(y);
sigma2=0;

while sigma>sigma2
    fprintf('Trying with sigma=%g\n',sigma);
    [Ipre,Gpre]=mymi3(label,w',x,sigma);
    deltaI=inf;
    iter=0;
    while iter< MAX_iter && deltaI>Tol        
        w=w+step*Gpre;
        w=orth(w);
        [Inew,Gnew]=mymi3(label,w',x,sigma);
        deltaI=(Inew-Ipre)/Ipre;
        iter=iter+1;
        Ipre=Inew;
        Gpre=Gnew;
        if display>0
            fprintf('iter %d, delta %e\n',iter,deltaI);
        end        
    end
    sigma=sigma*0.9;
    y=x*w;
    sigma2=mmi_sigma2(label,y);
end


