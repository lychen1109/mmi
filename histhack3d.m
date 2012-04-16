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

if nargout>2
    distarray=[];
    distarray1=[];
    distarray2=[];
    distarray=cat(1,distarray,dist_ori);
    distarray1=cat(1,distarray1,dist_ori1);
    distarray2=cat(1,distarray2,dist_ori2);
end

%modify components sorted by potentials
modified=false(size(img));

while true
    candidates=find(~modified);
    bestmod.location=[];
    bestmod.flag=[];
    bestmod.dist=inf;
    for i=1:length(candidates)
        [sj,sk]=ind2sub(size(bdctimg),candidates(i));
        output=flaggen(img,bdctimg,tm,tmtarget,tms,tmstarget,sj,sk,K,T);
        if output.modified && output.dist<bestmod.dist
            bestmod.dist=output.dist;
            bestmod.dist1=output.dist1;
            bestmod.dist2=output.dist2;
            bestmod.location=[sj,sk];
            bestmod.flag=output.flag;
            bestmod.tms=output.tms;
            bestmod.tm=output.tm;
            bestmod.bdctimg=output.bdctimg;
        end
    end
    if (dist_ori-bestmod.dist)/dist_ori>0.01
        sj=bestmod.location(1);
        sk=bestmod.location(2);
        modified(sj,sk)=true;
        img(sj,sk)=img(sj,sk)+bestmod.flag;
        tms=bestmod.tms;
        bdctimg=bestmod.bdctimg;
        tm=bestmod.tm;
        dist_ori=bestmod.dist;
        if nargout>2
            distarray=cat(1,distarray,bestmod.dist);
            distarray1=cat(1,distarray1,bestmod.dist1);
            distarray2=cat(1,distarray2,bestmod.dist2);
        end
    else
        break;
    end
    fprintf('modified pixel %d\n',sum(sum(modified)));
    fprintf('current dist %g\n',bestmod.dist);
end


function output=flaggen(img,bdctimg,tm,tmtarget,tms,tmstarget,sj,sk,K,T)
%calculate the best flag for current pixel
[dist_ori,dist_ori1,dist_ori2]=sampledist(tm,tms,tmtarget,tmstarget);
output.dist=dist_ori;
output.dist1=dist_ori1;
output.dist2=dist_ori2;
output.modified=false;
for i=max(-K,-img(sj,sk)):min(K,255-img(sj,sk))
    if i==0
        continue;
    end
    [newtms,newtm,newbdctimg]=tmmod3(img,bdctimg,tms,tm,sj,sk,i,T);
    [dist,dist1,dist2]=sampledist(newtm,newtms,tmtarget,tmstarget);
    if dist<dist_ori
        output.modified=true;
        dist_ori=dist;
        output.tms=newtms;
        output.flag=i;
        output.bdctimg=newbdctimg;
        output.tm=newtm;
        output.dist=dist;
        output.dist1=dist1;
        output.dist2=dist2;
    end
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






