function [bdctimg,delta,logpdfori,logpdfnew]=histhackm(simg,gm,PCAstruct,randidx,K,target)
%reshape histogram by modifying BDCT coeff
%target histogram is modeled with GMM

T=3;
bdctimg=blkproc(simg,[8 8],@dct2);
bdctimg=round(bdctimg);
bdctimgsign=sign(bdctimg);
bdctimgsign(bdctimgsign==0)=1;
bdctimgori=bdctimg;
bdctimg=abs(bdctimg);
tm=tpm1(bdctimg,T);
logpdfori=log10(tmpdfcalc(gm,tm,PCAstruct));
fprintf('logpdfori=%g\n',logpdfori);
logpdfnew=logpdfori;
for i=1:127*128
    if logpdfnew>=target
        break;
    end
    [sj,sk]=ind2sub([127 128],randidx(i));
    outstruct=flaggen(bdctimg,sj,sk,PCAstruct,logpdfnew,gm,tm,K);
    if outstruct.modflag
        bdctimg(sj,sk)=bdctimg(sj,sk)+outstruct.flag;
        tm=outstruct.tm;
        logpdfnew=outstruct.logpdfnew;
    end
    if mod(i,1000)==0
        fprintf('i=%d, logpdfnew=%g\n',i,logpdfnew);
    end
end

bdctimg=bdctimg.*bdctimgsign;
delta=bdctimgori-bdctimg;

function pdfvalue=tmpdfcalc(gm,tm,PCAstruct)
%calculate pdf of gmm in PCA space
tm=rownorm(tm);
coeff=PCAstruct.coeff;
means=PCAstruct.means;
score=(tm(1:42)-means)*coeff;
pdfvalue=pdf(gm,score);
       
function output=flaggen(bdctimg,sj,sk,PCAstruct,logpdfori,gm,tm,K)
%check if logpdf can be improved
output.modflag=false;
logpdfnew=logpdfori;
for i=max(-K,-bdctimg(sj,sk)):K
    if i==0
        continue;
    end
    out=tmmod2(bdctimg,tm,sj,sk,i,3);
    if ~out.changed
        continue;
    end
    logpdf=log10(tmpdfcalc(gm,out.tm,PCAstruct));
    if logpdf>logpdfnew
        output.modflag=true;
        logpdfnew=logpdf;
        output.flag=i;
        output.logpdfnew=logpdfnew;
        output.tm=out.tm;
    end
end



