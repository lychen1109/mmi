function edges=binselect(bdctimgs)
%select bin width according to sample distribution

K=size(bdctimgs,1);
T=4;
bdctimgs=reshape(bdctimgs',128,128,K);
y=bdctimgs(:,1:end-1,:)-bdctimgs(:,2:end,:);
y(y>T)=T;
y(y<-T)=-T;
m=0.16; %mean point
w=0.17; %width of bin

%create edges
edges=zeros(1,24);
for i=1:24
    edges(i)=m+(i-1)*w;
end

edges2=zeros(1,25);
for i=1:25
    edges2(i)=m+(i-26)*w;
end
edges=[edges2 edges];

h=histc(y(:),edges)/(127*128*K);
%bar(edges,h,'histc');
mb=minbin(h);
iter=0;
while mb<0.05    
    edges=binmerge(h,edges);
    h=histc(y(:),edges)/(127*128*K);
    mb=minbin(h);
    iter=iter+1;
end

fprintf('program ended after %d iterations\n',iter);


function [mb,I]=minbin(h)
%return the min frequency of bins, not count the last bin, which is zero
h=h(1:end-1);
[mb,I]=min(h);

function edges=binmerge(h,edges)
%merge the smallest bin
[~,I]=minbin(h);
if I==1
    %can only merge with the 2nd bin
    edges=[edges(1) edges(3:end)];
elseif I==length(edges)-1
    %remove the last bin
    edges=[edges(1:end-2) edges(end)];
else
    if h(I-1)>h(I+1)
        edges=[edges(1:I) edges(I+2:end)];
    else
        edges=[edges(1:I-1) edges(I+1:end)];
    end
end

        
    
    