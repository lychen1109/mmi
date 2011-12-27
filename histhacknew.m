function histhacknew(img,timg)
%modify image in pixel domain, with L2 distance as standard

%calculate target tpm
T=3;
bdcttarget=blkproc(timg,[8 8],@dct2);
bdcttarget=abs(round(bdcttarget));
tmtarget=tpm1(bdcttarget,T);

bdctimg=blkproc(img,[8 8],@dct2);
bdctimg=round(bdctimg);
bdctsign=sign(bdctimg);
bdctsign(bdctsign==0)=1;
bdctimg=abs(bdctimg);
tm=tpm1(bdctimg,T);

dist_current=norm(tm(:)-tmtarget(:));
N=ceil(128/5);
flag=zeros(size(img));
for i=1:128
    for j=1:N
        %only calculate flag 10% times
        if rand>.95
            flag(i,(j-1)*5+(1:3))=flagcreationl2(bdctimg,tmtarget,i,(j-1)*5+1);
        end
    end
end

tm2=tpm1(bdctimg+flag,T);
dist2=norm(tm2(:)-tmtarget(:));

img2=bdctdec((bdctimg+flag).*bdctsign);
bdctimg2=blkproc(img2,[8 8],@dct2);
bdctimg2=abs(round(bdctimg2));
tm3=tpm1(bdctimg2,T);
dist3=norm(tm3(:)-tmtarget(:));
fprintf('dist1=%g\n',dist_current);
fprintf('dist2=%g\n',dist2);
fprintf('dist3=%g\n',dist3);

        
    


