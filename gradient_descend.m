function [w1,I1]=gradient_descend(train_label,x,w0)
%calculate w with gradiient descend method

fid=fopen('MMI3.txt','w');
if isempty(w0)    
    tmp=randn(1,4);
    w0=tmp/norm(tmp);
    fprintf(fid,'w0 is initialized as (%f,%f,%f,%f)\n',w0(1),w0(2),w0(3),w0(4));
end

w1=w0;
y0=x*w0';
sigma=mmi_sigma(y0);
step=0.01;
I0=mymi(train_label,y0,sigma);
fprintf(fid,'iter=0, I=%f\n',I0);
iter=0;
MAX_iter=1000;
Tol=1e-6;
g=mymi_grad(train_label,w0,x,sigma);
while iter< MAX_iter && norm(g)>Tol
    iter=iter+1;
    w1=w1+step*g;w1=w1/norm(w1);
    y1=x*w1';
    I1=mymi(train_label,y1,sigma);
    fprintf(fid,'iter=%d, I=%f, norm_g=%f, w=(%f,%f,%f,%f)\n',iter,I1,norm(g),w1(1),w1(2),w1(3),w1(4));
    g=mymi_grad(train_label,w1,x,sigma);
end

%close the file
fclose(fid);

