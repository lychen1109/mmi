function bdctimg=markovml(img,targetimg)
%This function modify BDCT coefficients so that it maximize likelihood
%under target TPM. 

img=reshape(img,128,128);
targetimg=reshape(targetimg,128,128);
T=4;

%Calculate the target TPM
bdcttarget=blkproc(targetimg,[8 8],@dct2);
bdcttarget=abs(round(bdcttarget));
tmtarget=tpm1(bdcttarget,T);
tmtarget=tpmrownorm(tmtarget);

%Transfer the image to BDCT domain
bdctimg=blkproc(img,[8 8],@dct2);
bdctimg=round(bdctimg);
%Save sign of the BDCT coefficients
bdctsign=sign(bdctimg);
%Take absolute value of BDCT coefficients
bdctimg=abs(bdctimg);
bdctimgori=bdctimg;

tm=tpm1(bdctimg,T);
tm=tpmrownorm(tm);
diff=tm-tmtarget;
[~,idx]=sort(diff(:),1,'descend');
i=1;%index for bin of TPM
modified=false;
modnum=0;%record how many modification take place
%While there's pixels to change, do the loop
while diff(idx(i))>0
    [row,col]=ind2sub([2*T+1 2*T+1],idx(i));
    diffimg=bdctimg(:,1:end-1)-bdctimg(:,2:end);
    diffimg=threshold(diffimg,T);
    idxpair=(diffimg(:,1:end-1)==(row-T-1))&(diffimg(:,2:end)==(col-T-1));
    [I,J]=find(idxpair);
    for j=1:length(I)
        k=I(j);
        l=J(j);
        for shift=0:2
            if l+shift==1 || l+shift==2 || l+shift==127 || l+shift==128
                continue;%BDCT coeff in first, second, second last and last columne is not modified
            end
            if mod(k,8)==1 && mod(l+shift,8)==1
                continue;%DC elements are not modified
            end
            if bdctimg(k,l+shift)==0
                continue;%Zero coeff is not modified
            end
            y0=threshold(bdctimg(k,l+shift-2)-bdctimg(k,l+shift-1),T)+T+1;
            y1=threshold(bdctimg(k,l+shift-1)-bdctimg(k,l+shift),T)+T+1;
            y2=threshold(bdctimg(k,l+shift)-bdctimg(k,l+shift+1),T)+T+1;
            y3=threshold(bdctimg(k,l+shift+1)-bdctimg(k,l+shift+2),T)+T+1;
            if tmtarget(y0,y1)==0 || tmtarget(y1,y2)==0 || tmtarget(y2,y3)==0
                logml=-inf;
            else
                logml=log(tmtarget(y0,y1))+log(tmtarget(y1,y2))+log(tmtarget(y2,y3));
            end
            currentmod=0;
            currentlogml=logml;
            if bdctimg(k,l+shift)>max(0,bdctimgori(k,l+shift)-1)
                y1=threshold(bdctimg(k,l+shift-1)-bdctimg(k,l+shift)+1,T)+T+1;
                y2=threshold(bdctimg(k,l+shift)-bdctimg(k,l+shift+1)-1,T)+T+1;
                if tmtarget(y0,y1)==0 || tmtarget(y1,y2)==0 || tmtarget(y2,y3)==0
                    logml=-inf;
                else
                    logml=log(tmtarget(y0,y1))+log(tmtarget(y1,y2))+log(tmtarget(y2,y3));
                end
                if logml>currentlogml
                    currentmod=-1;
                    currentlogml=logml;
                end
            end
            if bdctimg(k,l+shift)<bdctimgori(k,l+shift)+1
                y1=threshold(bdctimg(k,l+shift-1)-bdctimg(k,l+shift)-1,T)+T+1;
                y2=threshold(bdctimg(k,l+shift)-bdctimg(k,l+shift+1)+1,T)+T+1;
                if tmtarget(y0,y1)==0 || tmtarget(y1,y2)==0 || tmtarget(y2,y3)==0
                    logml=-inf;
                else
                    logml=log(tmtarget(y0,y1))+log(tmtarget(y1,y2))+log(tmtarget(y2,y3));
                end
                if logml>currentlogml
                    currentmod=1;
                end
            end
            if currentmod~=0
                bdctimg(k,l+shift)=bdctimg(k,l+shift)+currentmod;
                modified=true;
                modnum=modnum+1;
                fprintf('%dth modification take place\n',modnum);
                maxmod=max(max(abs(bdctimg-bdctimgori)));
                fprintf('Max modification is %d\n',maxmod);
                fprintf('number of modified coefficients is %d\n',sum(sum(bdctimg~=bdctimgori)));
                break
            end
        end
        if modified
            break
        end
    end
    if modified
        tm=tpm1(bdctimg,T);
        tm=tpmrownorm(tm);
        diff=tm-tmtarget;
        [~,idx]=sort(diff(:),1,'descend');
        i=1;%index for bin of TPM
        modified=false;
    elseif i<length(diff(:))
        i=i+1;
    end
end
    
bdctimg=bdctimg.*bdctsign;




