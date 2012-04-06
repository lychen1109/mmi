function [bdctimg,delta,distarray,distarray1,distarray2]=histhack3c(img,imgtarget,beta1,beta2,K,T,B)
%change only on bdct domain, but constraint on both space
%K: dymamic range of coefficients
%T: threshold of co-occurrence matrix
%B: backward steps

%fid=fopen('imgproc.log','w');
%reshape images
img=reshape(img,128,128);
imgtarget=reshape(imgtarget,128,128);

%create target matrix
bdcttarget=blkproc(imgtarget,[8 8],@dct2);
bdcttarget=abs(round(bdcttarget));
tmtarget=tpm1(bdcttarget,T);

bdctimg=blkproc(img,[8 8],@dct2);
bdctimg=round(bdctimg);
bdctimgori=bdctimg;
bdctsign=sign(bdctimg);
bdctimg=abs(bdctimg);
tm=tpm1(bdctimg,T);
tms=tpm1(img,T);
tms_ori=tms;

%create mark for dc component and zero component
dcmark=false(8,8);
dcmark(1,1)=true;
dcmark=repmat(dcmark,16,16);
zeromark=(bdctimg==0);

if nargout>2
    [dist_ori,dist_ori1,dist_ori2]=sampledist(tm,tms,tmtarget,tms_ori,0);
    distarray=[];
    distarray1=[];
    distarray2=[];
    distarray=cat(1,distarray,dist_ori);
    distarray1=cat(1,distarray1,dist_ori1);
    distarray2=cat(1,distarray2,dist_ori2);
end

%modify components sorted by potentials
potential=~(dcmark|zeromark);
pointavailable=find(potential);
pointsize=length(pointavailable);
randidx=randperm(pointsize);
for i=1:pointsize
    for j=0:-1:-B
        if i+j<1
            break;
        end
        [sj,sk]=ind2sub(size(bdctimg),pointavailable(randidx(i+j)));
        if i+j>round(pointsize/2)
            beta=beta2;
        else
            beta=beta1;
        end
        output=flaggen(bdctimg,tm,tmtarget,img,tms,tms_ori,sj,sk,T,K,1,beta);
        if ~output.modified
            continue;
        end
        bdctimg(sj,sk)=bdctimg(sj,sk)+output.flag;
        tm=output.tm;
        img=output.newimg;
        tms=output.newtms;
        if nargout>2
            distarray=cat(1,distarray,output.dist);
            distarray1=cat(1,distarray1,output.dist1);
            distarray2=cat(1,distarray2,output.dist2);
        end
    end
end

bdctimg=bdctimg.*bdctsign;
delta=bdctimgori-bdctimg;
%fclose(fid);

function output=flaggen(bdctimg,tm,tmtarget,img,tms,tms_ori,sj,sk,T,K,~,beta)
%calculate the best flag for current pixel
%fprintf(fid,'start evaluation at (%d,%d)\n',sj,sk);
[dist_ori,dist_ori1,dist_ori2]=sampledist(tm,tms,tmtarget,tms_ori,beta);
%fprintf(fid,'dist_ori=%g,dist_ori1=%g,dist_ori2=%g\n',dist_ori,dist_ori1,dist_ori2);
output.dist=dist_ori;
output.dist1=dist_ori1;
output.dist2=dist_ori2;
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
        j0=floor((sj-1)/8)*8;
        k0=floor((sk-1)/8)*8;
        
        %calculate new 8x8 on spatial
        newbdctimg=bdctimg;
        newbdctimg(sj,sk)=newbdctimg(sj,sk)+i;
        newsblock=idct2(newbdctimg(j0+1:j0+8,k0+1:k0+8));
        newsblock=round(newsblock);
        newsblock(newsblock>255)=255;
        newsblock(newsblock<0)=0;
        
        %check difference in 8x8
        diffblock=newsblock-img(j0+1:j0+8,k0+1:k0+8);
        changed=find(diffblock);
        %fprintf(fid,'i=%d,changed pixel=%d\n',i,length(changed));
        
        %calculate newtms
        newtms=tms;
        newimg=img;
        for s=1:length(changed)
            [jdelta,kdelta]=ind2sub([8 8],changed(s));
            outspatial=tmmod2(newimg,newtms,j0+jdelta,k0+kdelta,diffblock(jdelta,kdelta),T);
            newimg(j0+jdelta,k0+kdelta)=newsblock(jdelta,kdelta);            
            newtms=outspatial.tm;
        end
    end
    tmnew=out.tm;    
    [dist,dist1,dist2]=sampledist(tmnew,newtms,tmtarget,tms_ori,beta);
    %fprintf(fid,'dist=%g,dist1=%g,dist2=%g\n',dist,dist1,dist2);
    if dist<dist_ori
        output.modified=true;
        dist_ori=dist;
        output.tm=out.tm;
        output.flag=i;
        output.newimg=newimg;
        output.newtms=newtms;
        output.dist=dist;
        output.dist1=dist1;
        output.dist2=dist2;
    end
end

function [dist,dist1,dist2]=sampledist(tm,tms,tmtarget,tms_ori,beta)
%return normalized distance
%dist=sum(abs(tm1-tm2).*w(:));
dist1=norm(tm(:)-tmtarget(:));
dist2=norm(tms(:)-tms_ori(:));
dist=dist1+beta*dist2;
%dist=norm(tm(:)-tmtarget(:))+norm(tms(:)-tms_ori(:));










