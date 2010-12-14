function label=myvec2label(vec)
%turn probability matrix to label

n_label=size(vec,2);
label=zeros(n_label,1);
for i=1:n_label
    if vec(1,i)<vec(2,i)
        label(i)=1;
    end
end
