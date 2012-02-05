function [bdctimg,delta,dist_ori,dist]=histhack3(img,tmtarget,K,w)
%change only on bdct domain

T=10;
bdctimg=blkproc(img,[8 8],@dct2);
bdctimg=round(bdctimg);
bdctimgori=bdctimg;
bdctsign=sign(bdctimg);
bdctimg=abs(bdctimg);
tm=tpm1(bdctimg,T);

%create mark for dc component and zero component
dcmark=false(8,8);
dcmark(1,1)=true;
dcmark=repmat(dcmark,16,16);
zeromark=(bdctimg==0);

%dist_ori=norm(tm(:)-tmtarget(:));
dist_ori=sampledist(tm(:),tmtarget(:),w);
dist=dist_ori;

%generate mindistortion potential for every qualified component
potential=zeros(size(bdctimg));
for i=1:128
    for j=1:128
        if dcmark(i,j) || zeromark(i,j)
            potential(i,j)=-1;
            continue;
        end
        output=flaggen(bdctimg,tmtarget,i,j,tm,T,K,w);
        potential(i,j)=output.dist;
    end
end

%modify components sorted by potentials
pointavailable=find(potential~=-1);
[~,sorted]=sort(potential(pointavailable),1,'ascend');
pointsize=length(pointavailable);
for i=1:pointsize
    [sj,sk]=ind2sub(size(bdctimg),pointavailable(sorted(i)));
    output=flaggen(bdctimg,tmtarget,sj,sk,tm,T,K,w);
    if ~output.modified
        continue;
    end
    bdctimg(sj,sk)=bdctimg(sj,sk)+output.flag;
    tm=output.tm;
    dist=output.dist;
end

bdctimg=bdctimg.*bdctsign;
delta=bdctimgori-bdctimg;

function output=flaggen(bdctimg,tmtarget,sj,sk,tm,T,K,w)
%calculate the best flag for current pixel
%dist_ori=norm(tm(:)-tmtarget(:));
dist_ori=sampledist(tm(:),tmtarget(:),w);
output.dist=dist_ori;
output.modified=false;
for i=max(-K,-bdctimg(sj,sk)):K
    if i==0
        continue;
    end
    out=tmmod2(bdctimg,tm,sj,sk,i,T);
    if ~out.changed
        continue;
    end
    tmnew=out.tm;
    %dist=norm(tmnew(:)-tmtarget(:));
    dist=sampledist(tmnew(:),tmtarget(:),w);
    if dist<dist_ori
        output.modified=true;
        dist_ori=dist;
        output.tm=out.tm;
        output.flag=i;
        output.dist=dist;
    end
end

function dist=sampledist(tm1,tm2,w)
%return normalized distance
%tm1=tm1(:)';
%tm2=tm2(:)';
%tm1=svmrescale(tm1,range);
%tm2=svmrescale(tm2,range);
dist=sum(abs(tm1-tm2).*w(:));









