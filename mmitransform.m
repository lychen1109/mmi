function W=mmitransform(label,data,N)
%learn N orthogonal MMI transform from data

n_feat=size(data,2);
W=zeros(n_feat,N);
filename='w_tmp';
for i=1:N
    w=randn(n_feat,1);
    w=w/norm(w);
    sigma=mmi_sigma(data*w);
    [w,iter]=mmirs(label,data,w,sigma,1e+5,1,0,1e-5);
    W(:,i)=w;
    save(filename,'W');
    fprintf('%dth feature leared after %d interations\n',i,iter);
end

    