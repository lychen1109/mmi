function [bdctimg,delta,dist_ori,dist]=histhack3b(img,imgtarget,K,T)
%change only on bdct domain, but constraint on both space
%K: dymamic range of coefficients
%T: threshold of co-occurrence matrix

%reshape images
img=reshape(img,128,128);
imgtarget=reshape(imgtarget,128,128);

%create target matrix
bdcttarget=blkproc(imgtarget,[8 8],@dct2);
bdcttarget=abs(round(bdcttarget));
tmtarget=tpm1(bdcttarget,T);
tmtargets=tpm1(imgtarget,T);

bdctimg=blkproc(img,[8 8],@dct2);
bdctimg=round(bdctimg);
bdctimgori=bdctimg;
bdctsign=sign(bdctimg);
bdctimg=abs(bdctimg);
tm=tpm1(bdctimg,T);
tms=tpm1(img,T);

%create mark for dc component and zero component
dcmark=false(8,8);
dcmark(1,1)=true;
dcmark=repmat(dcmark,16,16);
zeromark=(bdctimg==0);

dist_ori=sampledist(tm,tms,tmtarget,tmtargets);
dist=dist_ori;

%modify components sorted by potentials
potential=~(dcmark|zeromark);
pointavailable=find(potential);
pointsize=length(pointavailable);
randidx=randperm(pointsize);
for i=1:pointsize
    [sj,sk]=ind2sub(size(bdctimg),pointavailable(randidx(i)));
    output=flaggen(bdctimg,tm,tmtarget,img,tms,tmtargets,sj,sk,T,K);
    if ~output.modified
        continue;
    end
    bdctimg(sj,sk)=bdctimg(sj,sk)+output.flag;
    tm=output.tm;
    img=output.newimg;
    tms=output.newtms;
    dist=output.dist;
end

bdctimg=bdctimg.*bdctsign;
delta=bdctimgori-bdctimg;

function output=flaggen(bdctimg,tm,tmtarget,img,tms,tmtargets,sj,sk,T,K)
%calculate the best flag for current pixel
dist_ori=sampledist(tm,tms,tmtarget,tmtargets);
output.dist=dist_ori;
output.modified=false;
for i=max(-K,-bdctimg(sj,sk)):K
    if i==0
        continue;
    end
    out=tmmod2(bdctimg,tm,sj,sk,i,T);
    if ~out.changed
        continue;
    else
        %%%%%%%%%%%%%%%%%%%%
        %check spatial changes and effects on distance
        %%%%%%%%%%%%%%%%%%%%
        %locate 8x8 location
        j0=floor(sj/8)*8;
        k0=floor(sk/8)*8;
        
        %calculate new 8x8 on spatial
        newsblock=idct2(bdctimg(j0+1:j0+8,k0+1:k0+8));
        newsblock=round(newsblock);
        newsblock(newsblock>255)=255;
        newsblock(newsblock<0)=0;
        
        %check difference in 8x8
        diffblock=newsblock-img(j0+1:j0+8,k0+1:k0+8);
        changed=find(diffblock);
        
        %calculate newtms
        newtms=tms;
        newimg=img;
        for s=1:length(changed)
            [jdelta,kdelta]=ind2sub([8 8],changed(s));
            outspatial=tmmod2(newimg,newtms,j0+jdelta,k0+kdelta,diffblock(jdelta,kdelta),T);
            newimg(j0+jdelta,k0+kdelta)=newsblock(j0+jdelta,k0+kdelta);            
            newtms=outspatial.tm;
        end
    end
    tmnew=out.tm;    
    dist=sampledist(tmnew,newtms,tmtarget,tmtargets);
    if dist<dist_ori
        output.modified=true;
        dist_ori=dist;
        output.tm=out.tm;
        output.flag=i;
        output.newimg=newimg;
        output.newtms=newtms;
        output.dist=dist;
    end
end

function dist=sampledist(tm,tms,tmtarget,tmtargets)
%return normalized distance
%dist=sum(abs(tm1-tm2).*w(:));
dist=norm(tm(:)-tmtarget(:))+norm(tms(:)-tmtargets(:));









