function w0=gradient_descend(train_label,x,w0,sigma,itermax)
%calculate w with gradiient descend method

%fid=fopen('MMI3.txt','w');
%standard output=1
fid=1;
if isempty(w0)    
    tmp=randn(1,4);
    w0=tmp/norm(tmp);
    fprintf(fid,'w0 is initialized as (%f,%f,%f,%f)\n',w0(1),w0(2),w0(3),w0(4));
end

step=1;
MAX_iter=itermax;
Tol=1e-7;
iter=1;
Ipre=mymi2(train_label,x*w0',sigma);
g=mymi_grad2(train_label,w0,x,sigma);
w0=w0+step*g;w0=w0/norm(w0);
I=mymi2(train_label,x*w0',sigma);
deltaI=I-Ipre;
fprintf(fid,'iter=%d, deltaI=%e,norm_g=%e, w=(%f,%f,%f,%f)\n',iter,deltaI,norm(g),w0(1),w0(2),w0(3),w0(4));

while iter< MAX_iter && deltaI>Tol
    iter=iter+1;
    Ipre=I;
    g=mymi_grad2(train_label,w0,x,sigma);
    w0=w0+step*g;w0=w0/norm(w0);
    I=mymi2(train_label,x*w0',sigma);
    deltaI=I-Ipre;
    fprintf(fid,'iter=%d, deltaI=%e,norm_g=%e, w=(%f,%f,%f,%f)\n',iter,deltaI,norm(g),w0(1),w0(2),w0(3),w0(4));    
end

%close the file
%fclose(fid);

