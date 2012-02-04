function [bdctimg,delta,dist_ori,dist]=histhack3(img,tmtarget)
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

dist_ori=norm(tm(:)-tmtarget(:));

%generate mindistortion potential for every qualified component
potential=zeros(size(bdctimg));
for i=1:128
    for j=1:128
        if dcmark(i,j) || zeromark(i,j)
            potential=-1;
            continue;
        end
        output=flaggen(bdctimg,tmtarget,i,j,tm);
        potential(i,j)=output.dist;
    end
end

%modify components sorted by potentials
pointavailable=find(potential~=-1);
[~,sorted]=sort(potential(pointavailable),1,'ascend');
pointsize=length(poitavailable);
for i=1:pointsize
    [sj,sk]=ind2sub(size(bdctimg),pointavailable(sorted(i)));
    output=flaggen(bdctimg,tmtarget,sj,sk,tm);
    if ~output.modified
        continue;
    end
    bdctimg(sj,sk)=bdctimg(sj,sk)+output.flag;
    tm=output.tm;
    dist=output.dist;
end

bdctimg=bdctimg.*bdctsign;
delta=bdctimgori-bdctimg;

function output=flaggen(bdctimg,tmtarget,sj,sk,tm)
%calculate the best flag for current pixel
dist_ori=norm(tm(:)-tmtarget(:));
output.modified=false;
for i=[-1,1]
    out=tmmod2(bdctimg,tm,sj,sk,i,3);
    if ~out.changed
        continue;
    end
    tmnew=out.tm;
    dist=norm(tmnew(:)-tmtarget(:));
    if dist<dist_ori
        output.modified=true;
        dist_ori=dist;
        output.tm=out.tm;
        output.flag=i;
        output.dist=dist;
    end
end





