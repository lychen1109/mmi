function [img,distarray,distarray1,distarray2]=histhack3d(img,imgtarget,K,T)
%change on spatial domain, but constraint on both space
%K: dymamic range of coefficients
%T: threshold of co-occurrence matrix

%reshape images
img=reshape(img,128,128);
imgtarget=reshape(imgtarget,128,128);

%create target matrix
bdcttarget=blkproc(imgtarget,[8 8],@dct2);
bdcttarget=abs(round(bdcttarget));
tmtarget=tpm1(bdcttarget,T);
tmstarget=tpm1(imgtarget,T);

bdctimg=blkproc(img,[8 8],@dct2);
bdctimg=round(bdctimg);
bdctimg=abs(bdctimg);
tm=tpm1(bdctimg,T);
tms=tpm1(img,T);
[dist_ori,dist_ori1,dist_ori2]=sampledist(tm,tms,tmtarget,tmstarget);
currentdist=dist_ori;
if nargout>2
    distarray=[];
    distarray1=[];
    distarray2=[];
    distarray=cat(1,distarray,dist_ori);
    distarray1=cat(1,distarray1,dist_ori1);
    distarray2=cat(1,distarray2,dist_ori2);
    disp([dist_ori dist_ori1 dist_ori2]);
end

[difftm,difftms,diffbdctimg]=diffgen(img,bdctimg,K,T);
modified=false(size(img));
delta=1;

while delta>0.001
    candidates=find(~modified);
    CL=length(candidates);
    minidx=zeros(CL,1);
    mindists=zeros(CL,1);
    for i=1:CL
        [mindists(i),minidx(i)]=flaggen(tm,tmtarget,tms,tmstarget,difftm(candidates(i),:),difftms(candidates(i),:),currentdist);
    end
    [bestnewdist,bestpt]=min(mindists);
    if bestnewdist<currentdist
        [bestj,bestk]=ind2sub(size(bdctimg),candidates(bestpt));
        img(bestj,bestk)=img(bestj,bestk)+ind2flag(minidx(bestpt),K);
        tmcache=difftm{candidates(bestpt),minidx(bestpt)};
        tmscache=difftms{candidates(bestpt),minidx(bestpt)};
        bdctimgcache=diffbdctimg{candidates(bestpt),minidx(bestpt)};
        tm(tmcache(:,1))=tm(tmcache(:,1))+tmcache(:,2);
        tms(tmscache(:,1))=tms(tmscache(:,1))+tmscache(:,2);
        bdctimg(bdctimgcache(:,1))=bdctimg(bdctimgcache(:,1))+bdctimgcache(:,2);
        [newdist,newdist1,newdist2]=sampledist(tm,tms,tmtarget,tmstarget);
        delta=(dist_ori-newdist)/dist_ori;
        dist_ori=newdist;
        modified(bestj,bestk)=true;
        [difftm,difftms,diffbdctimg]=diffupdate(img,bdctimg,K,T,difftm,difftms,diffbdctimg,bestj,bestk,modified);
    else
        break;
    end
    if nargout>2
        distarray=cat(1,distarray,newdist);
        distarray1=cat(1,distarray1,newdist1);
        distarray2=cat(1,distarray2,newdist2);
        disp([newdist newdist1 newdist2]);
    end
end


function [mindist,minidx]=flaggen(tm,tmtarget,tms,tmstarget,difftm,difftms,currentdist)
%calculate the best flag for current pixel

L=length(difftm);
distance=zeros(L,1);
for i=1:L
    if isempty(difftm{i})
        distance(i)=currentdist;
    else
        tmschange=difftms{i};
        tmchange=difftm{i};
        newtms=tms;
        newtms(tmschange(:,1))=newtms(tmschange(:,1))+tmschange(:,2);
        newtm=tm;
        newtm(tmchange(:,1))=newtm(tmchange(:,1))+tmchange(:,2);
        distance(i)=sampledist(newtm,newtms,tmtarget,tmstarget);
    end
end
[mindist,minidx]=min(distance);
if mindist>=currentdist
    minidx=0;
    mindist=currentdist;
end


function [dist,dist1,dist2]=sampledist(tm,tms,tmtarget,tmstarget)
Z=sum(sum(tm));
tm=tm/Z;
tms=tms/Z;
tmtarget=tmtarget/Z;
tmstarget=tmstarget/Z;
dist1=norm(tm(:)-tmtarget(:));
dist2=norm(tms(:)-tmstarget(:));
feat=[tm(:);tms(:)];
feattarget=[tmtarget(:);tmstarget(:)];
dist=norm(feat-feattarget);

function [difftm,difftms,diffbdctimg]=diffgen(img,bdctimg,K,T)
%generate difference matrix for whole image
[m,n]=size(img);
difftm=cell(m*n,2*K);
difftms=cell(m*n,2*K);
diffbdctimg=cell(m*n,2*K);
rangek=-K:-1;
rangek=cat(2,rangek,1:K);
for i=1:m
    for j=1:n
        l=sub2ind(size(img),i,j);
        for k=1:length(rangek)
            if img(i,j)+rangek(k)<0 || img(i,j)+rangek(k)>255
                difftm{l,k}=[];
                difftms{l,k}=[];
                diffbdctimg{l,k}=[];
            else
                difftm{l,k}=tmmodrec(img,i,j,rangek(k),T);
                [difftms{l,k},diffbdctimg{l,k}]=tmmodrec2(img,bdctimg,i,j,rangek(k),T);
            end
        end
    end
end

function [difftm,difftms,diffbdctimg]=diffupdate(img,bdctimg,K,T,difftm,difftms,diffbdctimg,sj,sk,modified)
mark=false(size(img));
rangek=-K:-1;
rangek=cat(2,rangek,1:K);
j0=floor((sj-1)/8)*8;
k0=floor((sk-1)/8)*8;
if k0==0
    mark(j0+1:j0+8,k0+1:k0+16)=true;
elseif k0==120
    mark(j0+1:j0+8,k0-7:k0+8)=true;
else
    mark(j0+1:j0+8,k0-7:k0+16)=true;
end
mark=mark&(~modified);
toupdate=find(mark);
for i=1:length(toupdate)
    [j1,k1]=ind2sub(size(img),toupdate(i));
    for k=1:length(rangek)
        if img(j1,k1)+rangek(k)<0 || img(j1,k1)+rangek(k)>255
            difftm{toupdate(i),k}=[];
            difftms{toupdate(i),k}=[];
            diffbdctimg{toupdate(i),k}=[];
        else
            difftm{toupdate(i),k}=tmmodrec(img,j1,k1,range(k),T);
            [difftms{toupdate(i),k},diffbdctimg{toupdate(i),k}]=tmmodrec2(img,bdctimg,j1,k1,range(k),T);
        end
    end
end
          


function flag=ind2flag(idx,K)
%index to flag
if idx>K/2
    flag=idx-K/2;
else
    flag=idx-K/2-1;
end

            




