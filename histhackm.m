function [ximg,n_mod,modlogpdf,psnrfinal]=histhackm(sp,gm,varargin)
%reshape histogram by modifying LSB
%This is based on histhack2 and using GMM model

DEBUG=false;
T=3;
root='C:\data\ImSpliceDataset\';
nvar=length(varargin);
for i=1:nvar/2
    switch varargin{i*2-1}
        case 'debug'
            DEBUG=varargin{i*2};
        case 'root'
            root=varargin{i*2};
    end
end

simg=imread(name2path(sp,'root',root));
simg=double(simg);

bdctimg=blkproc(simg,[8 8],@dct2);
bdctimg_ori=bdctimg;
bdctimg=round(abs(bdctimg));
tm2=tpm1(bdctimg,T);
tm3=tm2;
modified=false(size(bdctimg));%record if a coef has been modified

NMOD=500; %maximum allowed number of modified coeff
if DEBUG
    logpdfrec=zeros(1,NMOD); %record logpdf
    psnrrec=zeros(1,NMOD); %record of PSNR
    recidx=0;
end
n_mod=0; %number of modified coef

logpdfori=log(pdf(gm,tm3(1:end-1)));
logpdfpre=logpdfori;

while n_mod<NMOD    
    if DEBUG
        recidx=recidx+1;
        ximg=bdctdec(bdctimg.*sign(bdctimg_ori));
        logpdfrec(recidx)=logpdfpre;
        psnrrec(recidx)=PSNR(simg,ximg);
    end
    de=gmmderi(gm,tm3(1:end-1)');    
    [~,I]=sort(de(:),1,'ascend');
    t_bin=1; %index of target bin
    modflag=false;
    while t_bin<=(length(tm3(:))-1) && de(I(t_bin))<0
        %find candidate dct coeff
        bdctimgx=dcnan(bdctimg);
        diffimg=bdctimgx(:,1:end-1)-bdctimgx(:,2:end);
        [j,k]=ind2sub(size(tm3),I(t_bin));
        diffimg1=(diffimg(:,1:end-1)==(j-T-1));
        diffimg2=(diffimg(:,2:end)==(k-T-1));
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
            %bdctimgc=zeros(128,128,7);
            logpdf=zeros(1,7);
            if bdctimg(sj,sk)>=2 && ~modified(sj,sk)
                %bdctimgc(:,:,1)=bdctmod(bdctimg,sj,sk,[1 0 0]);
                tmnew=tmmod(bdctimg,tm3,sj,sk,[1 0 0]);
                tmc(:,:,1)=tmnew;
                logpdf(1)=log(pdf(gm,tmnew(1:end-1)));
            end
            
            if bdctimg(sj,sk+1)>=2 && ~modified(sj,sk+1)
                %bdctimgc(:,:,2)=bdctmod(bdctimg,sj,sk,[0 1 0]);
                tmnew=tmmod(bdctimg,tm3,sj,sk,[0 1 0]);
                tmc(:,:,2)=tmnew;
                logpdf(2)=log(pdf(gm,tmnew(1:end-1)));
            end
            
            if bdctimg(sj,sk+2)>=2 && ~modified(sj,sk+2)
                %bdctimgc(:,:,3)=bdctmod(bdctimg,sj,sk,[0 0 1]);
                tmnew=tmmod(bdctimg,tm3,sj,sk,[0 0 1]);
                tmc(:,:,3)=tmnew;
                logpdf(3)=log(pdf(gm,tmnew(1:end-1)));
            end
            
            if bdctimg(sj,sk)>=2 && bdctimg(sj,sk+1)>=2 && ~modified(sj,sk) && ~modified(sj,sk+1)
                %bdctimgc(:,:,4)=bdctmod(bdctimg,sj,sk,[1 1 0]);
                tmnew=tmmod(bdctimg,tm3,sj,sk,[1 1 0]);
                tmc(:,:,4)=tmnew;
                logpdf(4)=log(pdf(gm,tmnew(1:end-1)));
            end
            
            if bdctimg(sj,sk+1)>=2 && bdctimg(sj,sk+2)>=2 && ~modified(sj,sk+1) && ~modified(sj,sk+2)
                %bdctimgc(:,:,5)=bdctmod(bdctimg,sj,sk,[0 1 1]);
                tmnew=tmmod(bdctimg,tm3,sj,sk,[0 1 1]);
                tmc(:,:,5)=tmnew;
                logpdf(5)=log(pdf(gm,tmnew(1:end-1)));
            end
            
            if bdctimg(sj,sk)>=2 && bdctimg(sj,sk+2)>=2 && ~modified(sj,sk) && ~modified(sj,sk+2)
                %bdctimgc(:,:,6)=bdctmod(bdctimg,sj,sk,[1 0 1]);
                tmnew=tmmod(bdctimg,tm3,sj,sk,[1 0 1]);
                tmc(:,:,6)=tmnew;
                logpdf(6)=log(pdf(gm,tmnew(1:end-1)));
            end
            
            if bdctimg(sj,sk)>=2 && bdctimg(sj,sk+1)>=2 && bdctimg(sj,sk+2)>=2 && ...
                    ~modified(sj,sk) && ~modified(sj,sk+1) && ~modified(sj,sk+2)
                %bdctimgc(:,:,7)=bdctmod(bdctimg,sj,sk,[1 1 1]);
                tmnew=tmmod(bdctimg,tm3,sj,sk,[1 1 1]);
                tmc(:,:,7)=tmnew;
                logpdf(7)=log(pdf(gm,tmnew(1:end-1)));
            end
            
            [maxlogpdf,I2]=max(logpdf);
            if maxlogpdf>logpdfpre                
                %adopt the modification
                if DEBUG
                    fprintf('delta logpdf is %g\n',maxlogpdf-logpdfpre);
                end
                logpdfpre=maxlogpdf;
                switch I2
                    case 1
                        bdctimg=bdctmod(bdctimg,sj,sk,[1 0 0]);
                        tm3=tmc(:,:,1);
                        modified(sj,sk)=true;
                        n_mod=n_mod+1;
                        modflag=true;
                    case 2
                        bdctimg=bdctmod(bdctimg,sj,sk,[0 1 0]);
                        tm3=tmc(:,:,2);
                        modified(sj,sk+1)=true;
                        n_mod=n_mod+1;
                        modflag=true;
                    case 3
                        bdctimg=bdctmod(bdctimg,sj,sk,[0 0 1]);
                        tm3=tmc(:,:,3);
                        modified(sj,sk+2)=true;
                        n_mod=n_mod+1;
                        modflag=true;
                    case 4
                        bdctimg=bdctmod(bdctimg,sj,sk,[1 1 0]);
                        tm3=tmc(:,:,4);
                        modified(sj,sk)=true;
                        modified(sj,sk+1)=true;
                        n_mod=n_mod+2;
                        modflag=true;
                    case 5
                        bdctimg=bdctmod(bdctimg,sj,sk,[0 1 1]);
                        tm3=tmc(:,:,5);
                        modified(sj,sk+1)=true;
                        modified(sj,sk+2)=true;
                        n_mod=n_mod+2;
                        modflag=true;
                    case 6
                        bdctimg=bdctmod(bdctimg,sj,sk,[1 0 1]);
                        tm3=tmc(:,:,6);
                        modified(sj,sk)=true;
                        modified(sj,sk+2)=true;
                        n_mod=n_mod+2;
                        modflag=true;
                    otherwise
                        bdctimg=bdctmod(bdctimg,sj,sk,[1 1 1]);
                        tm3=tmc(:,:,7);
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
%         if DEBUG
%             fprintf('t_bin=%d\n',t_bin);
%             fprintf('I(t_bin)=%d\n',I(t_bin));
%             fprintf('tmx(I(t_bin))=%g\n',tmx(I(t_bin)));
%         end
    end %end of trying all positive delta bins
    if modflag==false, break;end    
end

fprintf('%d coeff modified\n',n_mod);
ximg=bdctdec(bdctimg.*sign(bdctimg_ori));
modlogpdf=logpdfpre-logpdfori;
psnrfinal=PSNR(simg,ximg);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot the result
%%%%%%%%%%%%%%%%%%%%%%%%%%%

if DEBUG
    m=max(max([tm2 tm3]));
    m=ceil(m*10)/10;
    logpdfrec=logpdfrec(1:recidx);
    psnrrec=psnrrec(1:recidx);    
    
    subplot(2,3,1);
    imagesc(simg,[0 255]),colormap gray
    axis image off
    subplot(2,3,2);
    imagesc(ximg,[0 255]),colormap gray
    axis image off
    subplot(2,3,3);
    plot(logpdfrec);
    title('log pdf');    
    subplot(2,3,4);
    mesh(tm2);
    axis([0 10 0 10 0 m]);
    subplot(2,3,5);
    mesh(tm3);
    axis([0 10 0 10 0 m]);
    subplot(2,3,6);
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

function tm=tmmod(bdctimg,tm,sj,sk,flag)
%modify transmition probability directly

T=4;
S=1/(128*126);
for i=1:3
    if flag(i)==1
        rj=sj;
        rk=sk+i-1;
        if mod(bdctimg(rj,rk),2)==0
            l=1;
        else
            l=-1;
        end
        if rk-2>0
            y1=threshold(bdctimg(rj,rk-2)-bdctimg(rj,rk-1),T);
            y2=threshold(bdctimg(rj,rk-1)-bdctimg(rj,rk),T);
            y3=y1;
            y4=threshold(bdctimg(rj,rk-1)-bdctimg(rj,rk)-l,T);
            tm(y1+T+1,y2+T+1)=tm(y1+T+1,y2+T+1)-S;
            tm(y3+T+1,y4+T+1)=tm(y3+T+1,y4+T+1)+S;
        end
        
        if rk-1>0 && rk+1<129
            y1=threshold(bdctimg(rj,rk-1)-bdctimg(rj,rk),T);
            y2=threshold(bdctimg(rj,rk)-bdctimg(rj,rk+1),T);
            y3=threshold(bdctimg(rj,rk-1)-bdctimg(rj,rk)-l,T);
            y4=threshold(bdctimg(rj,rk)-bdctimg(rj,rk+1)+l,T);
            tm(y1+T+1,y2+T+1)=tm(y1+T+1,y2+T+1)-S;
            tm(y3+T+1,y4+T+1)=tm(y3+T+1,y4+T+1)+S;
        end
        
        if rk+2<129
            y1=threshold(bdctimg(rj,rk)-bdctimg(rj,rk+1),T);
            y2=threshold(bdctimg(rj,rk+1)-bdctimg(rj,rk+2),T);
            y3=threshold(bdctimg(rj,rk)-bdctimg(rj,rk+1)+l,T);
            y4=y2;
            tm(y1+T+1,y2+T+1)=tm(y1+T+1,y2+T+1)-S;
            tm(y3+T+1,y4+T+1)=tm(y3+T+1,y4+T+1)+S;
        end
    end
end

function t=threshold(t,T)
t=min(t,T);
t=max(t,-T);
            
                
                



