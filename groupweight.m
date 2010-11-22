function groupweight(grp,feat_idx,weight_idx,dataTrain,label,Max_iter,step,Tol,display)
%calculate group weight
% [weight_idx,iter]=groupweight(grp,feat_idx,weight_idx,dataTrain,label,Max
% _iter,step,Tol,display)

if nargin<6, Max_iter=1000; end
if nargin<7, step=0.1;end
if nargin<8, Tol=1e-6;end
if nargin<9, display=0;end

w=weight_idx(:,grp);
feat=zeros(1,size(dataTrain,2));
feat(w>0)=1;
feat(feat_idx)=1;
% w_lda=lda(label,dataTrain(:,feat==1));
% w(feat==1)=w_lda;
% weight_idx(:,grp)=w;

%initialize sigma
y=dataTrain*weight_idx;
sigma=mmi_sigma(y);
sigma2=0;%So that we can enter the loop

mask=zeros(size(weight_idx));
mask(:,grp)=feat;

while sigma>sigma2
    [Ipre,Gpre]=mymi3(label,weight_idx',dataTrain,sigma);
    Gpre=Gpre';
    deltaI=inf;
    iter=0;
    while deltaI>Tol && iter<Max_iter
        weight_idx=weight_idx+step*Gpre.*mask;
        w=weight_idx(:,grp);
        weight_idx(:,grp)=w/norm(w);
        [Inew,Gnew]=mymi3(label,weight_idx',dataTrain,sigma);
        Gnew=Gnew';
        deltaI=(Inew-Ipre)/Ipre;
        Ipre=Inew;
        Gpre=Gnew;
        iter=iter+1;
        if display>0
            fprintf('iter=%d, deltaI=%g\n',iter,deltaI);
        end
    end
    sigma=sigma*0.9;
    y=dataTrain*weight_idx;
    sigma2=mmi_sigma2(label,y);
end






