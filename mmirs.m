function w=mmirs(label,x,w,sigma,MAX_iter,step,display)
%calculate w with gradiient descend method
%display 0:nothing 1:iteration

if nargin<5, MAX_iter=500; end
if nargin<6, step=0.1; end
if nargin<7, display=1; end

iter=0;
while iter< MAX_iter
    pairs=randomsample2(label,4000);
    [Ipre,Gpre]=mymi3s(label,w,x,pairs,sigma);
    w=w+step*Gpre;
    w=w/norm(w);
    Inew=mymi3s(label,w,x,pairs,sigma);
    deltaI=(Inew-Ipre)/Ipre;
    iter=iter+1;    
    if display>0
        fprintf('iter %d, delta %e\n',iter,deltaI);
    end
end




