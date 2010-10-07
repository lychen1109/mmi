function w0=gradient_descend(train_label,x,w0,sigma)
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
MAX_iter=200;
Tol=1e-4;
iter=0;

g=mymi_grad2(train_label,w0,x,sigma);
fprintf(fid,'iter=%d, norm_g=%f, w=(%f,%f,%f,%f)\n',iter,norm(g),w0(1),w0(2),w0(3),w0(4));

while iter< MAX_iter && norm(g)>Tol
    iter=iter+1;
    w0=w0+step*g;w0=w0/norm(w0);
    g=mymi_grad(train_label,w0,x,sigma);
    fprintf(fid,'iter=%d, norm_g=%f, w=(%f,%f,%f,%f)\n',iter,norm(g),w0(1),w0(2),w0(3),w0(4));    
end

%close the file
%fclose(fid);

