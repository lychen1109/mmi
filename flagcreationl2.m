function [flag]=flagcreationl2(bdctimg,tmtarget,sj,sk)
%create location and flags that can improve image and target distance

T=3;
tm=tpm1(bdctimg,T);

%construct flagstr
flagstr=zeros(27,3);
idx=0;
for i=-1:1
    for j=-1:1
        for k=-1:1            
            idx=idx+1;
            flagstr(idx,:)=[i j k];            
        end
    end
end

dist=zeros(1,27);
dist(1:27)=inf;
for j=1:27
    if ~any(bdctimg(sj,sk+(0:2))+flagstr(j,:)<0)
        tmnew=tmmod(bdctimg,tm,sj,sk,flagstr(j,:),T);
        dist(j)=norm(tmnew(:)-tmtarget(:));
    end
end
[~,mindistidx]=min(dist);
flag=flagstr(mindistidx,:);





    