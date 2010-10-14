function f=svm_feature_gen_single_bin(autrain,bin_mi)
%extract single bin feature according to bin_mi

[~,I]=sort(bin_mi(:),1,'descend');
transmat=extract_feature(autrain,1);
f=zeros(size(transmat,3),49);
for i=1:49
    idx=I(i);
    [sx,sy]=ind2sub(size(bin_mi),idx);
    tmp=f(sx,sy,:);
    f(:,i)=tmp(:);
end