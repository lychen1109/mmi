function markovmltest(bdctimg,spimage,targetimg)
%Test markovml function

%print three TPM
T=4;
tm=tpm1(abs(bdctimg),T);
tm=tpmrownorm(tm);
fprintf('tpm of output image\n');
disp(tm);

spimage=reshape(spimage,128,128);
bdctsp=blkproc(spimage,[8 8],@dct2);
bdctsp=abs(round(bdctsp));
tmsp=tpm1(bdctsp,T);
tmsp=tpmrownorm(tmsp);
fprintf('tpm of spliced image\n');
disp(tmsp);

targetimg=reshape(targetimg,128,128);
bdcttg=blkproc(targetimg,[8 8],@dct2);
bdcttg=abs(round(bdcttg));
tmtg=tpm1(bdcttg,T);
tmtg=tpmrownorm(tmtg);
fprintf('tpm of target image\n');
disp(tmtg);

%Calculate psnr
imgrestore=bdctdec(bdctimg);
psnrvalue=psnr(imgrestore,spimage);
fprintf('PSNR is %g\n',psnrvalue);

%check if likelihood is really maximized
diffsp=bdctsp(:,1:end-1)-bdctsp(:,2:end);
diffsp=threshold(diffsp,T);
[Msp,Nsp]=size(diffsp);
logLold=0;
for i=1:Msp
    for j=1:Nsp-1
        logLold=logLold+log(tmtg(diffsp(i,j)+T+1,diffsp(i,j+1)+T+1));
    end
end
fprintf('log likelihood of spliced image is %g\n',logLold);

bdctimgab=abs(bdctimg);
diffnow=bdctimgab(:,1:end-1)-bdctimgab(:,2:end);
diffnow=threshold(diffnow,T);
[M,N]=size(diffnow);
logL=0;
for i=1:M
    for j=1:N-1
        logL=logL+log(tmtg(diffnow(i,j)+T+1,diffnow(i,j+1)+T+1));
    end
end
fprintf('log likelihood of modified image is %g\n',logL);

difftg=bdcttg(:,1:end-1)-bdcttg(:,2:end);
difftg=threshold(difftg,T);
[Mtg,Ntg]=size(difftg);
logLtg=0;
for i=1:Mtg
    for j=1:Ntg-1
        logLtg=logLtg+log(tmtg(difftg(i,j)+T+1,difftg(i,j+1)+T+1));
    end
end
fprintf('log likelihood of authentic image is %g\n',logLtg);
