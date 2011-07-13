function cmat=cooccount(bdctimg,edges)
%cooccurrence count according to edges

numbin=length(edges)-1;
cmat=zeros(numbin,numbin);
T=4;
y=bdctimg(:,1:end-1)-bdctimg(:,2:end);
y(y>T)=T;
y(y<-T)=-T;
z1=y(:,1:end-1);
z2=y(:,2:end);

for i=1:length(z1(:))
    idx1=binidx(z1(i),edges);
    idx2=binidx(z2(i),edges);
    cmat(idx1,idx2)=cmat(idx1,idx2)+1;
end
cmat=cmat/length(z1(:));


function idx=binidx(z,edges)
%calculate binidx according to sample value

idx=0;
while z>edges(idx+1) && idx<length(edges)-1
    idx=idx+1;
end

    