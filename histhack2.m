function [ximg,n_mod]=histhack2(au,sp,sigma,varargin)
%reshape histogram by modifying LSB
%this version introduced PSNR and Mahalanobis distance

DEBUG=false;
nvar=length(varargin);
for i=1:nvar/2
    switch varargin{i*2-1}
        case 'debug'
            DEBUG=varargin{i*2};
    end
end

aimg=imread(name2path(au));
simg=imread(name2path(sp));
aimg=double(aimg);
simg=double(simg);

tm1=tpm1d(aimg,4,0,0);
tm2=tpm1d(simg,4,0,0);
bdctimg=blkproc(simg,[8 8],@dct2);
bdctimg_ori=bdctimg;
bdctimg=round(abs(bdctimg));
modified=false(size(bdctimg));%record if a coef has been modified

NMOD=500; %maximum allowed number of modified coeff
if DEBUG
    mdrec=zeros(1,NMOD); %record mahsdist
    psnrrec=zeros(1,NMOD); %record of PSNR
    recidx=0;
end
n_mod=0; %number of modified coef

while n_mod<NMOD
    tm3=tpm1(bdctimg,4);       
    mahsdistpre=mahsdistcalc(tm1,tm3,sigma);
    if DEBUG
        recidx=recidx+1;
        ximg=bdctdec(bdctimg.*sign(bdctimg_ori));
        mdrec(recidx)=mahsdistpre;
        psnrrec(recidx)=PSNR(simg,ximg);
    end
    tmx=tm3-tm1;
    [~,I]=sort(tmx(:),1,'descend');
    t_bin=1; %index of target bin
    modflag=false;
    while t_bin<=81 && tmx(I(t_bin))>0
        %find candidate dct coeff
        bdctimgx=dcnan(bdctimg);
        diffimg=bdctimgx(:,1:end-1)-bdctimgx(:,2:end);
        [j,k]=ind2sub(size(tmx),I(t_bin));
        diffimg1=(diffimg(:,1:end-1)==(j-5));
        diffimg2=(diffimg(:,2:end)==(k-5));
        location=diffimg1&diffimg2;
        num=sum(sum(location));
        if DEBUG
            fprintf('There are %d number of coef to be modified\n',num);
        end
        
        locations=find(location);
        randidx=randperm(num);
        loc_idx=1; %start from the first location
        while loc_idx<=num
            loc=locations(randidx(loc_idx));
            [sj,sk]=ind2sub(size(bdctimg),loc);
            bdctimgc=zeros(128,128,7);
            mahsdist=10*ones(1,7);
            if bdctimg(sj,sk)>=2 && ~modified(sj,sk)
                bdctimgc(:,:,1)=bdctmod(bdctimg,sj,sk,[1 0 0]);
                tmc=tpm1(bdctimgc(:,:,1),4);
                mahsdist(1)=mahsdistcalc(tm1,tmc,sigma);
            end
            
            if bdctimg(sj,sk+1)>=2 && ~modified(sj,sk+1)
                bdctimgc(:,:,2)=bdctmod(bdctimg,sj,sk,[0 1 0]);
                tmc=tpm1(bdctimgc(:,:,2),4);
                mahsdist(2)=mahsdistcalc(tm1,tmc,sigma);
            end
            
            if bdctimg(sj,sk+2)>=2 && ~modified(sj,sk+2)
                bdctimgc(:,:,3)=bdctmod(bdctimg,sj,sk,[0 0 1]);
                tmc=tpm1(bdctimgc(:,:,3),4);
                mahsdist(3)=mahsdistcalc(tm1,tmc,sigma);
            end
            
            if bdctimg(sj,sk)>=2 && bdctimg(sj,sk+1)>=2 && ~modified(sj,sk) && ~modified(sj,sk+1)
                bdctimgc(:,:,4)=bdctmod(bdctimg,sj,sk,[1 1 0]);
                tmc=tpm1(bdctimgc(:,:,4),4);
                mahsdist(4)=mahsdistcalc(tm1,tmc,sigma);
            end
            
            if bdctimg(sj,sk+1)>=2 && bdctimg(sj,sk+2)>=2 && ~modified(sj,sk+1) && ~modified(sj,sk+2)
                bdctimgc(:,:,5)=bdctmod(bdctimg,sj,sk,[0 1 1]);
                tmc=tpm1(bdctimgc(:,:,5),4);
                mahsdist(5)=mahsdistcalc(tm1,tmc,sigma);
            end
            
            if bdctimg(sj,sk)>=2 && bdctimg(sj,sk+2)>=2 && ~modified(sj,sk) && ~modified(sj,sk+2)
                bdctimgc(:,:,6)=bdctmod(bdctimg,sj,sk,[1 0 1]);
                tmc=tpm1(bdctimgc(:,:,6),4);
                mahsdist(6)=mahsdistcalc(tm1,tmc,sigma);
            end
            
            if bdctimg(sj,sk)>=2 && bdctimg(sj,sk+1)>=2 && bdctimg(sj,sk+2)>=2 && ...
                    ~modified(sj,sk) && ~modified(sj,sk+1) && ~modified(sj,sk+2)
                bdctimgc(:,:,7)=bdctmod(bdctimg,sj,sk,[1 1 1]);
                tmc=tpm1(bdctimgc(:,:,7),4);
                mahsdist(7)=mahsdistcalc(tm1,tmc,sigma);
            end
            
            [mahsdist_sorted,I]=sort(mahsdist);
            if mahsdist_sorted(1)<mahsdistpre
                %adopt the modification
                if DEBUG
                    fprintf('delta mahs dist is %g\n',mahsdistpre-mahsdist_sorted(1));
                end
                switch I(1)
                    case 1
                        bdctimg=bdctimgc(:,:,1);
                        modified(sj,sk)=true;
                        n_mod=n_mod+1;
                        modflag=true;
                    case 2
                        bdctimg=bdctimgc(:,:,2);
                        modified(sj,sk+1)=true;
                        n_mod=n_mod+1;
                        modflag=true;
                    case 3
                        bdctimg=bdctimgc(:,:,3);
                        modified(sj,sk+2)=true;
                        n_mod=n_mod+1;
                        modflag=true;
                    case 4
                        bdctimg=bdctimgc(:,:,4);
                        modified(sj,sk)=true;
                        modified(sj,sk+1)=true;
                        n_mod=n_mod+2;
                        modflag=true;
                    case 5
                        bdctimg=bdctimgc(:,:,5);
                        modified(sj,sk+1)=true;
                        modified(sj,sk+2)=true;
                        n_mod=n_mod+2;
                        modflag=true;
                    case 6
                        bdctimg=bdctimgc(:,:,6);
                        modified(sj,sk)=true;
                        modified(sj,sk+2)=true;
                        n_mod=n_mod+2;
                        modflag=true;
                    otherwise
                        bdctimg=bdctimgc(:,:,7);
                        modified(sj,sk)=true;
                        modified(sj,sk+1)=true;
                        modified(sj,sk+2)=true;
                        n_mod=n_mod+3;
                        modflag=true;
                end
            end
            if modflag, break; end
            loc_idx=loc_idx+1;
        end %end of trying all candidate coeff
        if modflag,break;end
        t_bin=t_bin+1;
    end %end of trying all positive delta bins
    if modflag==false, break;end
end

fprintf('%d coeff modified\n',n_mod);
tm3=tpm1(bdctimg,4);
ximg=bdctdec(bdctimg.*sign(bdctimg_ori));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot the result
%%%%%%%%%%%%%%%%%%%%%%%%%%%

if DEBUG
    m=max(max([tm1 tm2 tm3]));
    m=ceil(m*10)/10;
    mdrec=mdrec(1:recidx);
    psnrrec=psnrrec(1:recidx);
    
    subplot(2,4,1);
    imagesc(aimg,[0 255]),colormap gray
    axis image off
    subplot(2,4,2);
    imagesc(simg,[0 255]),colormap gray
    axis image off
    subplot(2,4,3);
    imagesc(ximg,[0 255]),colormap gray
    axis image off
    subplot(2,4,4);
    plot(mdrec);
    title('Mahs Distance');
    subplot(2,4,5);
    mesh(tm1);
    axis([0 10 0 10 0 m]);
    subplot(2,4,6);
    mesh(tm2);
    axis([0 10 0 10 0 m]);
    subplot(2,4,7);
    mesh(tm3);
    axis([0 10 0 10 0 m]);
    subplot(2,4,8);
    plot(psnrrec);
    title('PSNR');
end

function bdctimg=bdctmod(bdctimg,sj,sk,flag)
%modify bdctcoeff

for i=1:3
    if flag(i)==1
        if mod(bdctimg(sj,sk+i-1),2)==0
            bdctimg(sj,sk+i-1)=bdctimg(sj,sk+i-1)+1;
        else
            bdctimg(sj,sk+i-1)=bdctimg(sj,sk+i-1)-1;
        end
    end
end



