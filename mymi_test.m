function mymi_test(label,x,sigma)
%check if the new mymi function gives right result

featuresize=size(x,2);
numtry=4;

for i=1:numtry
    w=randn(1,featuresize);
    w=w/norm(w);
    disp('w = ');disp(w);
    tic;I1=mymi2(label,x*w',sigma);t=toc;
    fprintf('Old MI = %f\n',I1);
    fprintf('Used time is %f second.\n',t);
    tic;g1=mymi_grad2(label,w,x,sigma);t=toc;
    fprintf('Old gradient is\n');
    disp(g1);
    fprintf('Used time is %f second.\n',t);
    
    tic;I2=mymi3(label,w,x,sigma);t=toc;
    fprintf('new MI = %f\n',I2);
    fprintf('used time %f seconds.\n',t);
    tic;[I2,g2]=mymi3(label,w,x,sigma);t=toc;
    fprintf('new MI=%f\n',I2);
    fprintf('new gradient=\n');
    disp(g2);
    fprintf('time used=%f\n',t);
end