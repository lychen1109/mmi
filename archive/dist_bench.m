function dist_bench(feat)
%compare calculation time of difference distance

featn=svmrescale(feat);
random_times=10;
n_images=size(feat,1);
t1=0;
t2=0;
t3=0;
t4=0;

for i=1:random_times
    f1=round(rand(1)*n_images)+1;
    f2=round(rand(1)*n_images)+1;
    tic;l2a=norm(featn(f1,:)-featn(f2,:))^2;t1=t1+toc;
    tic;l2b=sum((featn(f1,:)-featn(f2,:)).^2);t2=t2+toc;
    tic;kl1=kl_div(feat(f1,:),feat(f2,:),'sym');t3=t3+toc;
    tic;kl2=kl_div(feat(f1,:),feat(f2,:),'js');t4=t4+toc;
end
fprintf('square distance with norm:%g\n',t1/random_times);
fprintf('square distance with sum:%g\n',t2/random_times);
fprintf('sym kl distance:%g\n',t3/random_times);
fprintf('js kl distance:%g\n',t4/random_times);

    
