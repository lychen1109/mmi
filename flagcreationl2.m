function output=flagcreationl2(img,tmtarget,N)
%create location and flags that can improve image and target distance

coefidx=randperm(128^2-256);
coefidx=coefidx(1:N);
flags=zeros(N,3);
moddist=zeros(N,1);
T=3;

bdctimg=blkproc(img,[8 8],@dct2);
bdctimg=abs(round(bdctimg));
tm=tpm1(bdctimg,T);
dist_ori=norm(tm(:)-tmtarget(:));

%construct flagstr
flagstr=zeros(26,3);
idx=0;
for i=-1:1
    for j=-1:1
        for k=-1:1
            if any([i j k])
                idx=idx+1;
                flagstr(idx,:)=[i j k];
            end
        end
    end
end

for i=1:N
    [sj,sk]=ind2sub(size(bdctimg),coefidx(i));
    %     y1=threshold(bdctimg(sj,sk)-bdctimg(sj,sk+1),T)+T+1;
    %     y2=threshold(bdctimg(sj,sk+1)-bdctimg(sj,sk+2),T)+T+1;
    dist=zeros(1,26);
    dist(1:26)=-inf;
    for j=1:26
        if ~any(bdctimg(sj,sk+(0:2))+flagstr(j,:)<0)
            tmnew=tmmod(bdctimg,tm,sj,sk,flagstr(j,:),T);
            dist(j)=norm(tmnew(:)-tmtarget(:));
        end
    end
    [maxdist,maxdistidx]=max(dist);
    flags(i,:)=flagstr(maxdistidx,:);
    moddist(i)=maxdist-dist_ori;    
end

output.coefidx=coefidx;
output.flags=flags;
output.moddist=moddist;

    