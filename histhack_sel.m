function [bdctimg]=histhack_sel(img,imgtarget,K,T,selection)
%change only on bdct domain
%K: dymamic range of coefficients
%T: threshold of co-occurrence matrix
%Only change coeff in selection

tpmopt=1;
%reshape images
img=reshape(img,128,128);
imgtarget=reshape(imgtarget,128,128);

%create target matrix
bdcttarget=blkproc(imgtarget,[8 8],@dct2);
bdcttarget=abs(round(bdcttarget));
tmtarget=tpm1(bdcttarget,T,tpmopt);

bdctimg=blkproc(img,[8 8],@dct2);
bdctimg=round(bdctimg);
bdctsign=sign(bdctimg);
bdctimg=abs(bdctimg);
tm=tpm1(bdctimg,T,tpmopt);

if type==1
    %generate mindistortion potential for every qualified component
    potential=zeros(size(bdctimg));
    for i=1:128
        for j=1:128
            if dcmark(i,j) || zeromark(i,j)
                potential(i,j)=-1;
                continue;
            end
            output=flaggen(bdctimg,tmtarget,i,j,tm,T,K);
            potential(i,j)=output.dist;
        end
    end
    
    %modify components sorted by potentials
    pointavailable=find(potential~=-1);
    [~,sorted]=sort(potential(pointavailable),1,'ascend');
    pointsize=length(pointavailable);
else
    potential=zeros(size(bdctimg));
    potential(dcmark)=-1;
    potential(zeromark)=-1;
    pointavailable=find(potential~=-1);
    pointsize=length(pointavailable);
    sorted=randperm(pointsize);
end

for i=1:pointsize
    [sj,sk]=ind2sub(size(bdctimg),pointavailable(sorted(i)));
    output=flaggen(bdctimg,tmtarget,sj,sk,tm,T,K);
    if ~output.modified
        continue;
    end
    bdctimg(sj,sk)=bdctimg(sj,sk)+output.flag;
    tm=output.tm;
end

bdctimg=bdctimg.*bdctsign;

function output=flaggen(bdctimg,tmtarget,sj,sk,tm,T,K)
%calculate the best flag for current pixel
%dist_ori=norm(tm(:)-tmtarget(:));
dist_ori=sampledist(tm(:),tmtarget(:));
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
    dist=sampledist(tmnew(:),tmtarget(:));
    if dist<dist_ori
        output.modified=true;
        dist_ori=dist;
        output.tm=out.tm;
        output.flag=i;
        output.dist=dist;
    end
end

function dist=sampledist(tm1,tm2)
%return normalized distance
%tm1=tm1(:)';
%tm2=tm2(:)';
%tm1=svmrescale(tm1,range);
%tm2=svmrescale(tm2,range);
%dist=sum(abs(tm1-tm2).*w(:));
dist=norm(tm1-tm2);









