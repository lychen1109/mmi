function [flag,moddist,mindist]=flagcreationl2(bdctimg,tmtarget,coefloc)
%create location and flags that can improve image and target distance

T=3;
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

[sj,sk]=ind2sub(size(bdctimg),coefloc);
dist=zeros(1,26);
dist(1:26)=inf;
for j=1:26
    if ~any(bdctimg(sj,sk+(0:2))+flagstr(j,:)<0)
        tmnew=tmmod(bdctimg,tm,sj,sk,flagstr(j,:),T);
        dist(j)=norm(tmnew(:)-tmtarget(:));
    end
end
[mindist,mindistidx]=min(dist);
flag=flagstr(mindistidx,:);
moddist=mindist-dist_ori;




    