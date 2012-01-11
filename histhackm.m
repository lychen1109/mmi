function [bdctimg,n_mod,logpdfori,logpdfnew]=histhackm(simg,gm,PCAstruct)
%reshape histogram by modifying BDCT coeff
%target histogram is modeled with GMM

T=3;
bdctimg=blkproc(simg,[8 8],@dct2);
bdctimgsign=sign(bdctimg);
bdctimgsign(bdctimgsign==0)=1;
bdctimg=round(abs(bdctimg));
[N,M]=size(bdctimg);
diffimg=bdctimg(1:N-1,1:M-1)-bdctimg(1:N-1,2:M);
diffimgori=diffimg;
tm=tpmf(diffimg,T);
tmnorm=rownorm(tm);
logpdfori=log10(tmpdfcalc(gm,tmnorm,PCAstruct));
logpdfnew=logpdfori;

while true
    loc_candidate=1:127*126;
    randidx=randperm(length(loc_candidate));
    loc_idx=1; %start from the first location
    outstruct=flaggen(diffimg,diffimgori,loc_candidate(randidx(loc_idx)),bdctimg,PCAstruct,logpdfnew,gm,tm);
    while loc_idx<length(loc_candidate) && outstruct.modflag==false
        loc_idx=loc_idx+1;
        outstruct=flaggen(diffimg,diffimgori,loc_candidate(randidx(loc_idx)),bdctimg,PCAstruct,logpdfnew,gm,tm);
    end
    if outstruct.modflag
        [sj,sk]=ind2sub(size(diffimg),loc_candidate(randidx(loc_idx)));
        diffimg(sj,sk:sk+1)=diffimg(sj,sk:sk+1)+outstruct.flag;        
        logpdfnew=outstruct.logpdfnew;
    else
        break
    end
end
n_mod=sum(sum(diffimgori~=diffimg));
bdctimg(1:end-1,1:end-1)=bdctimg(1:end-1,2:end)+diffimg;
bdctimg=bdctimg.*bdctimgsign;

function pdfvalue=tmpdfcalc(gm,tm,PCAstruct)
%calculate pdf of gmm in PCA space
coeff=PCAstruct.coeff;
means=PCAstruct.means;
score=(tm(1:42)-means)*coeff;
pdfvalue=pdf(gm,score);
       
function output=flaggen(diffimg,diffimgori,loc,bdctimg,PCAstruct,logpdfori,gm,tm)
%check if logpdf can be improved
output.modflag=false;
logpdfnew=logpdfori;
[sj,sk]=ind2sub(size(diffimg),loc);
bdctimgp=bdctimg(1:end-1,2:end);
for i=-1:1
    for j=-1:1
        if i==0 && j==0
            continue;
        end
        diffimgnew=diffimg;
        diffimgnew(sj,sk:sk+1)=diffimgnew(sj,sk:sk+1)+[i,j];
        if any(bdctimgp(sj,sk:sk+1)+diffimgnew(sj,sk:sk+1)<0)
            continue;
        end
        if max(max(abs(diffimgnew-diffimgori)))>2
            continue;
        end    
        %tmnew=tpmf(diffimgnew,3);
        tmnew=tmmod2(diffimgnew,tm,sj,sk,[i j],3);
        tmnorm=rownorm(tmnew);
        logpdf=log10(tmpdfcalc(gm,tmnorm,PCAstruct));
        if logpdf>logpdfnew
            output.modflag=true;
            logpdfnew=logpdf;
            output.flag=[i,j];
            output.logpdfnew=logpdfnew;
        end
    end
end



