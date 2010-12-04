function feat=featremove(feat,N)
%randomly remove N features at a time

for i=1:N
    n_feat=size(feat,2);
    randidx=myrandint(1,1,1:n_feat);
    feat(:,randidx)=[];
end


