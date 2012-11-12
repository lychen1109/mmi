function bdctimg=tpmcreate(img,imgtarget)
%recreate img's transition probability matrix according to targetimg
%Ouput image is in BDCT form.

T=4;

%rescale images
img=reshape(img,128,128);
imgtarget=reshape(imgtarget,128,128);

%calculate target tpm
%use overall tpm first
bdcttarget=blkproc(imgtarget,[8 8],@dct2);
bdcttarget=abs(round(bdcttarget));
tmtarget=tpm1(bdcttarget,T);
tmtarget=tpmrownorm(tmtarget);

%calculate current tpm
bdctimg=blkproc(img,[8 8],@dct2);
bdctsign=sign(bdctimg);
bdctsign(bdctsign==0)=1;
bdctimg=abs(round(bdctimg));
% tm=tpm1(bdctimg,T);
% tm=tpmrownorm(tm);

%estimate coeff one block by one block
for i=1:128
    for j=1:42
        if mod(j*3,8)==1
            continue;
        end
        y0=threshold(bdctimg(i,j*3-2)-bdctimg(i,j*3-1),T);
        p=tmtarget(y0+T+1,:);
        y1=randgen(p);
        x3=bdctimg(i,j*3-1)-y1;
        bdctimg(i,j*3)=x3;
    end
end

bdctimg=bdctimg.*bdctsign;
        

