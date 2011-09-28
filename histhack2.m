function [ximg,n_mod,modratio]=histhack2(au,sp,sigma,varargin)
%reshape histogram by modifying LSB
%this version introduced PSNR and Mahalanobis distance

DEBUG=false;
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

aimg=imread(name2path(au,'root',root));
simg=imread(name2path(sp,'root',root));
aimg=double(aimg);
simg=double(simg);

tm1=tpm1d(aimg,4,0,0);
bdctimg=blkproc(simg,[8 8],@dct2);
bdctimg_ori=bdctimg;
bdctimg=round(abs(bdctimg));
tm2=tpm1(bdctimg,4);
tm3=tm2;
modified=false(size(bdctimg));%record if a coef has been modified

NMOD=500; %maximum allowed number of modified coeff
if DEBUG
    mdrec=zeros(1,NMOD); %record mahsdist
    psnrrec=zeros(1,NMOD); %record of PSNR
    recidx=0;
end
n_mod=0; %number of modified coef

mahsdistori=mahsdistcalc(tm1,tm3,sigma);
mahsdistpre=mahsdistori;

while n_mod<NMOD    
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
            %bdctimgc=zeros(128,128,7);
            mahsdist=10*ones(1,7);
            if bdctimg(sj,sk)>=2 && ~modified(sj,sk)
                %bdctimgc(:,:,1)=bdctmod(bdctimg,sj,sk,[1 0 0]);
                tmc(:,:,1)=tmmod(bdctimg,tm3,sj,sk,[1 0 0]);
                mahsdist(1)=mahsdistcalc(tm1,tmc(:,:,1),sigma);
            end
            
            if bdctimg(sj,sk+1)>=2 && ~modified(sj,sk+1)
                %bdctimgc(:,:,2)=bdctmod(bdctimg,sj,sk,[0 1 0]);
                tmc(:,:,2)=tmmod(bdctimg,tm3,sj,sk,[0 1 0]);
                mahsdist(2)=mahsdistcalc(tm1,tmc(:,:,2),sigma);
            end
            
            if bdctimg(sj,sk+2)>=2 && ~modified(sj,sk+2)
                %bdctimgc(:,:,3)=bdctmod(bdctimg,sj,sk,[0 0 1]);
                tmc(:,:,3)=tmmod(bdctimg,tm3,sj,sk,[0 0 1]);
                mahsdist(3)=mahsdistcalc(tm1,tmc(:,:,3),sigma);
            end
            
            if bdctimg(sj,sk)>=2 && bdctimg(sj,sk+1)>=2 && ~modified(sj,sk) && ~modified(sj,sk+1)
                %bdctimgc(:,:,4)=bdctmod(bdctimg,sj,sk,[1 1 0]);
                tmc(:,:,4)=tmmod(bdctimg,tm3,sj,sk,[1 1 0]);
                mahsdist(4)=mahsdistcalc(tm1,tmc(:,:,4),sigma);
            end
            
            if bdctimg(sj,sk+1)>=2 && bdctimg(sj,sk+2)>=2 && ~modified(sj,sk+1) && ~modified(sj,sk+2)
                %bdctimgc(:,:,5)=bdctmod(bdctimg,sj,sk,[0 1 1]);
                tmc(:,:,5)=tmmod(bdctimg,tm3,sj,sk,[0 1 1]);
                mahsdist(5)=mahsdistcalc(tm1,tmc(:,:,5),sigma);
            end
            
            if bdctimg(sj,sk)>=2 && bdctimg(sj,sk+2)>=2 && ~modified(sj,sk) && ~modified(sj,sk+2)
                %bdctimgc(:,:,6)=bdctmod(bdctimg,sj,sk,[1 0 1]);
                tmc(:,:,6)=tmmod(bdctimg,tm3,sj,sk,[1 0 1]);
                mahsdist(6)=mahsdistcalc(tm1,tmc(:,:,6),sigma);
            end
            
            if bdctimg(sj,sk)>=2 && bdctimg(sj,sk+1)>=2 && bdctimg(sj,sk+2)>=2 && ...
                    ~modified(sj,sk) && ~modified(sj,sk+1) && ~modified(sj,sk+2)
                %bdctimgc(:,:,7)=bdctmod(bdctimg,sj,sk,[1 1 1]);
                tmc(:,:,7)=tmmod(bdctimg,tm3,sj,sk,[1 1 1]);
                mahsdist(7)=mahsdistcalc(tm1,tmc(:,:,7),sigma);
            end
            
            [mahsdist_sorted,I2]=sort(mahsdist);
            if mahsdist_sorted(1)<mahsdistpre
                mahsdistpre=mahsdist_sorted(1);
                %adopt the modification
                if DEBUG
                    fprintf('delta mahs dist is %g\n',mahsdistpre-mahsdist_sorted(1));
                end
                switch I2(1)
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
modratio=mahsdistpre/mahsdistori;

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
            
                
                



