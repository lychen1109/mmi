function points=adjpoints2(datatrain,currentpoints)
%return the adjcent points of current group

nfeat=size(datatrain,2);
sqrsize=sqrt(nfeat);
groupidx=zeros(sqrsize,sqrsize);
groupidx(currentpoints)=1;
n_currentpoints=length(currentpoints);
for i=1:n_currentpoints
    [sx,sy]=ind2sub(size(groupidx),currentpoints(i));
    if sx-1>0 && groupidx(sx-1,sy)==0
        groupidx(sx-1,sy)=2;
    end
    if sx+1<sqrsize+1 && groupidx(sx+1,sy)==0
        groupidx(sx+1,sy)=2;
    end
    if sy-1>0 && groupidx(sx,sy-1)==0
        groupidx(sx,sy-1)=2;
    end
    if sy+1<sqrsize+1 && groupidx(sx,sy+1)==0
        groupidx(sx,sy+1)=2;
    end
end
points=find(groupidx==2);
