function [ximg,output]=histhackm2p(sp,gm1,gm2,nworker,varargin)
%reshape histogram by modifying LSB
%This is based on histhack2 and using GMM model
%this is based on histhackm and use 2 GMM models
%sorttype: 'diff' or 'ratio', default is 'ratio'
%This version use parallel inside the function

flagstr=[1 0 0; 0 1 0;0 0 1;1 1 0;0 1 1;1 0 1;1 1 1];

DEBUG=false;
T=3;
maxmodratio=0.05;
root='C:\data\ImSpliceDataset\';
sorttype='ratio';
nvar=length(varargin);
for i=1:nvar/2
    switch varargin{i*2-1}
        case 'debug'
            DEBUG=varargin{i*2};
        case 'root'
            root=varargin{i*2};
        case 'sorttype'
            sorttype=varargin{i*2};
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

avaicoeff=sum(sum(bdctimg>1))-16^2;
NMOD=ceil(avaicoeff*maxmodratio); %maximum allowed number of modified coeff

if DEBUG
    logpdfrec1=zeros(1,NMOD); %record logpdf
    logpdfrec2=zeros(1,NMOD);
    psnrrec=zeros(1,NMOD); %record of PSNR
    recidx=0;
    binmiss=0;
end
n_mod=0; %number of modified coef

logpdfori1=log(pdf(gm1,tm3(1:end-1)));
logpdfpre1=logpdfori1;
logpdfori2=log(pdf(gm2,tm3(1:end-1)));
logpdfpre2=logpdfori2;

while n_mod<NMOD    
    if DEBUG
        recidx=recidx+1;
        ximg=bdctdec(bdctimg.*sign(bdctimg_ori));
        logpdfrec1(recidx)=logpdfpre1;
        logpdfrec2(recidx)=logpdfpre2;
        psnrrec(recidx)=PSNR(simg,ximg);
    end
    de1=gmmderi(gm1,tm3(1:end-1));    
    de2=gmmderi(gm2,tm3(1:end-1));
    
%     candibins=false(size(de1));
%     for i=1:length(de1)
%         if de1(i)<0 && de2(i)>0
%             candibins(i)=true;
%         end
%         if de1(i)<0 && de2(i)<0 && abs(de1(i))>abs(de2(i))
%             candibins(i)=true;
%         end
%         if de1(i)>0 && de2(i)>0 && abs(de1(i))<abs(de2(i))
%             candibins(i)=true;
%         end
%     end
    candibins=(de1<0);    
    candibins=find(candibins);
    if isequal(sorttype,'diff')
        candibinweights=de1(candibins)-de2(candibins);
        sortstr='ascend';
    else
        candibinweights=abs(de1(candibins)./de2(candibins));
        sortstr='descend';
    end
    [~,I]=sort(candibinweights(:),1,sortstr);
    t_bin=1; %index of target bin
    modflag=false;
    while t_bin<=length(candibins)
        %find candidate dct coeff
        bdctimgx=dcnan(bdctimg);
        diffimg=bdctimgx(:,1:end-1)-bdctimgx(:,2:end);
        [j,k]=ind2sub(size(tm3),candibins(I(t_bin)));
        diffimg1=(diffimg(:,1:end-1)==(j-T-1));
        diffimg2=(diffimg(:,2:end)==(k-T-1));
        location=diffimg1&diffimg2;
        num=sum(sum(location));
        if DEBUG
            fprintf('[%d,%d] %g (%g,%g): %d coef to be modified\n',j-T-1,k-T-1,tm3(j,k),de1(candibins(I(t_bin))),de2(candibins(I(t_bin))),num);
        end
        
        locations=find(location);
        randidx=randperm(num);
        loc_idx=1; %start from the first location
        while loc_idx<=num
            spmd (nworker)           
                if loc_idx+labindex-1<=num
                    loc=locations(randidx(loc_idx+labindex-1));
                    [sj,sk]=ind2sub(size(bdctimg),loc);                    
                    logpdf1=zeros(1,7);
                    logpdf2=zeros(1,7);
                    flagavailable=false(1,7);
                    tmc=zeros(2*T+1,2*T+1,7);
                    for f=1:7
                        flag=flagstr(f,:);
                        flagavailable(f)=canmodify(bdctimg,sj,sk,modified,flag);
                        if ~flagavailable(f)
                            continue;
                        end
                        tmnew=tmmod(bdctimg,tm3,sj,sk,flag,T);
                        tmc(:,:,f)=tmnew;
                        logpdf1(f)=log(pdf(gm1,tmnew(1:end-1)));
                        logpdf2(f)=log(pdf(gm2,tmnew(1:end-1)));
                    end
                end
            end
            if loc_idx+nworker-1<=num
                nparallel=nworker;
            else
                nparallel=num-loc_idx+1;
            end
            goodmodidx=false(nparallel,7);
            for i=1:nparallel                
                goodmodidx(i,:)=flagavailable{i} & ( logpdf1{i} > logpdfpre1 ) & ((logpdf1{i}-logpdf2{i})>=(logpdfpre1-logpdfpre2));
            end
            %[maxlogpdf,I2]=max(logpdf);
            if any(goodmodidx)                
                %adopt the modification
                logpdf1array=zeros(nparallel,7);
                for i=1:nparallel
                    logpdf1array(i,:)=logpdf1{i};
                end
                logpdf1array(~goodmodidx)=0;                
                [~,maxlogpdf1]=max(logpdf1array(:));
                [selectedlab,I2]=ind2sub([nparallel,7],maxlogpdf1);
                logpdf1local=logpdf1{selectedlab};
                logpdf2local=logpdf2{selectedlab};
                if DEBUG
                    fprintf('delta logpdf1 is %g\n',logpdf1local(I2)-logpdfpre1);
                    fprintf('delta logpdf2 is %g\n',logpdf2local(I2)-logpdfpre2);
                end
                logpdfpre1=logpdf1local(I2);
                logpdfpre2=logpdf2local(I2);
                tmclocal=tmc{selectedlab};
                sjl=sj{selectedlab};
                skl=sk{selectedlab};
                switch I2
                    case 1
                        bdctimg=bdctmod(bdctimg,sjl,skl,[1 0 0]);
                        tm3=tmclocal(:,:,1);
                        modified(sjl,skl)=true;
                        n_mod=n_mod+1;
                        modflag=true;
                    case 2
                        bdctimg=bdctmod(bdctimg,sjl,skl,[0 1 0]);
                        tm3=tmclocal(:,:,2);
                        modified(sjl,skl+1)=true;
                        n_mod=n_mod+1;
                        modflag=true;
                    case 3
                        bdctimg=bdctmod(bdctimg,sjl,skl,[0 0 1]);
                        tm3=tmclocal(:,:,3);
                        modified(sjl,skl+2)=true;
                        n_mod=n_mod+1;
                        modflag=true;
                    case 4
                        bdctimg=bdctmod(bdctimg,sjl,skl,[1 1 0]);
                        tm3=tmclocal(:,:,4);
                        modified(sjl,skl)=true;
                        modified(sjl,skl+1)=true;
                        n_mod=n_mod+2;
                        modflag=true;
                    case 5
                        bdctimg=bdctmod(bdctimg,sjl,skl,[0 1 1]);
                        tm3=tmclocal(:,:,5);
                        modified(sjl,skl+1)=true;
                        modified(sjl,skl+2)=true;
                        n_mod=n_mod+2;
                        modflag=true;
                    case 6
                        bdctimg=bdctmod(bdctimg,sjl,skl,[1 0 1]);
                        tm3=tmclocal(:,:,6);
                        modified(sjl,skl)=true;
                        modified(sjl,skl+2)=true;
                        n_mod=n_mod+2;
                        modflag=true;
                    otherwise
                        bdctimg=bdctmod(bdctimg,sjl,skl,[1 1 1]);
                        tm3=tmclocal(:,:,7);
                        modified(sjl,skl)=true;
                        modified(sjl,skl+1)=true;
                        modified(sjl,skl+2)=true;
                        n_mod=n_mod+3;
                        modflag=true;
                end
                if DEBUG
                    fprintf('%d in %d (%g) coeffs modified\n',n_mod,avaicoeff,n_mod/avaicoeff);
                end                
            end
            if modflag, break; end
            loc_idx=loc_idx+nparallel;
        end %end of trying all candidate coeff
        if modflag,break;end
        t_bin=t_bin+1;
        if DEBUG
            binmiss=binmiss+1;
        end
%         if DEBUG
%             fprintf('t_bin=%d\n',t_bin);
%             fprintf('I(t_bin)=%d\n',I(t_bin));
%             fprintf('tmx(I(t_bin))=%g\n',tmx(I(t_bin)));
%         end
    end %end of trying all positive delta bins
    if modflag==false, break;end    
end

modratio=n_mod/avaicoeff;
ximg=bdctdec(bdctimg.*sign(bdctimg_ori));
modlogpdf1=logpdfpre1-logpdfori1;
modlogpdf2=logpdfpre2-logpdfori2;
psnrfinal=PSNR(simg,ximg);

output.logpdfori1=logpdfori1;
output.logpdfori2=logpdfori2;
output.modlogpdf1=modlogpdf1;
output.modlogpdf2=modlogpdf2;
output.psnrfinal=psnrfinal;
output.modratio=modratio;


if DEBUG
    fprintf('binmiss=%d\n',binmiss);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot the result
%%%%%%%%%%%%%%%%%%%%%%%%%%%

if DEBUG    
    logpdfrec1=logpdfrec1(1:recidx);
    logpdfrec2=logpdfrec2(1:recidx);
    psnrrec=psnrrec(1:recidx);    
    
    subplot(2,4,1);
    imagesc(simg,[0 255]),colormap gray
    axis image off
    title('Original Image');
    subplot(2,4,2);
    imagesc(ximg,[0 255]),colormap gray
    axis image off
    title('Restored Image');
    subplot(2,4,3);
    plot(logpdfrec1);
    title('log pdf authentic model');
    subplot(2,4,4);
    plot(logpdfrec2);
    title('log pdf splicing model');
    subplot(2,4,5);
    mesh(tm2);
    a1=gca;
    zlim1=get(a1,'zlim');
    title('Original co-oc matrix');
    subplot(2,4,6);
    mesh(tm3);
    a2=gca;
    zlim2=get(a2,'zlim');
    title('Restored co-oc matrix');
    
    zmax=max([zlim1(2) zlim2(2)]);
    set(a1,'zlim',[0 zmax]);
    set(a2,'zlim',[0 zmax]);
    subplot(2,4,7);
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

function tm=tmmod(bdctimg,tm,sj,sk,flag,T)
%modify transmition probability directly

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

function stat=canmodify(bdctimg,sj,sk,modified,flag)
%check if the bdct coeff can be modify

stat=true;
for i=1:3
    if flag(i)==1 && ( bdctimg(sj,sk+i-1)<2 || modified(sj,sk+i-1) )
        stat=false;
        break;
    end
end

                
                



