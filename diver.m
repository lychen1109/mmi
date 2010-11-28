function divs=diver(transmat,label)
%calculate spliced image divergences

aumean=mean(transmat(:,:,label==0),3);
spliced=transmat(:,:,label==1);
n_spliced=size(spliced,3);
divs=zeros(n_spliced,1);
for i=1:n_spliced
    sptm=spliced(:,:,i);
    divs(i)=div(sptm,aumean);
end

    