function [img,delta,dist_ori,dist]=histhack4(img,imgtarget,K,T)
%change only on spatial domain
%K: dymamic range of coefficients
%T: threshold of co-occurrence matrix

%reshape images
img=reshape(img,128,128);
imgtarget=reshape(imgtarget,128,128);

%create target matrix
tmtarget=tpm1(imgtarget,T);

imgori=img;
tm=tpm1(img,T);

dist_ori=sampledist(tm(:),tmtarget(:));
dist=dist_ori;

%generate mindistortion potential for every qualified component
% potential=zeros(size(bdctimg));
% for i=1:128
%     for j=1:128
%         if dcmark(i,j) || zeromark(i,j)
%             potential(i,j)=-1;
%             continue;
%         end
%         output=flaggen(bdctimg,tmtarget,i,j,tm,T,K);
%         potential(i,j)=output.dist;
%     end
% end

%modify components randomly
idx=randperm(128^2);
for i=1:128^2
    [sj,sk]=ind2sub(size(img),idx(i));
    output=flaggen(img,tmtarget,sj,sk,tm,T,K);
    if ~output.modified
        continue;
    end
    img(sj,sk)=img(sj,sk)+output.flag;
    tm=output.tm;
    dist=output.dist;
end

delta=img-imgori;

function output=flaggen(img,tmtarget,sj,sk,tm,T,K)
%calculate the best flag for current pixel
dist_ori=sampledist(tm(:),tmtarget(:));
output.dist=dist_ori;
output.modified=false;
for i=max(-K,-img(sj,sk)):min(K,255-img(sj,sk))
    if i==0
        continue;
    end
    out=tmmod2(img,tm,sj,sk,i,T);
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









