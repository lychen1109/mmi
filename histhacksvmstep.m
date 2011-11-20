function [ximg,modified,tm3,output]=histhacksvmstep(simg,model,range,varargin)
%reshape histogram by modifying bdct coeff
% SVM model is used as likelihood model

DEBUG=false;
T=3;
nvar=length(varargin);
for i=1:nvar/2
    switch varargin{i*2-1}
        case 'debug'
            DEBUG=varargin{i*2};        
    end
end

bdctimg=blkproc(simg,[8 8],@dct2);
bdctimg_ori=bdctimg;
bdctimg=round(abs(bdctimg));
modified=false(size(bdctimg));
tm2=tpm1(bdctimg,T);
tm3=tm2;

[~,~,dout_ori]=svmpredict(0,svmrescale(tm3(:)',range),model);
if dout_ori>=0.9
    fprintf('The image already looks like authentic. No need to process.\n');
    ximg=simg;
    output.dout_ori=dout_ori;
    output.moddout=0;
    output.n_mod=0;
    return;
end

NMOD=inf; %maximum allowed number of modified coeff

if DEBUG
    logpdfrec1=zeros(1,NMOD); %record logpdf
    logpdfrec2=zeros(1,NMOD);
    psnrrec=zeros(1,NMOD); %record of PSNR
    recidx=0;
    binmiss=0;
end
n_mod=0; %number of modified coef
dout_pre=dout_ori;

%construct flagstr
flagstr=zeros(26,3);
idx=0;
for i=-1:1
    for j=-1:1
        for k=-1:1
            if any([i j k])
                idx=idx+1;
                flagstr(idx,:)=[i j k];
            end
        end
    end
end

while dout_pre<0.9 && n_mod<NMOD    
    if DEBUG
        recidx=recidx+1;
        ximg=bdctdec(bdctimg.*sign(bdctimg_ori));
        logpdfrec1(recidx)=logpdfpre1;
        logpdfrec2(recidx)=logpdfpre2;
        psnrrec(recidx)=PSNR(simg,ximg);
    end
    de1=svmgrad(model,svmrescale(tm3(:)',range));    
    
    
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
    candibinweights=de1(candibins);
    sortstr='ascend';    
    [~,I]=sort(candibinweights(:),1,sortstr);
    t_bin=1; %index of target bin
    modflag=false;
    while t_bin<=length(candibins)
        %find candidate dct coeff        
        diffimg=bdctimg(:,1:end-1)-bdctimg(:,2:end);
        diffimg(diffimg>T)=T;
        diffimg(diffimg<-T)=-T;
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
            loc=locations(randidx(loc_idx));
            [sj,sk]=ind2sub(size(bdctimg),loc);
            %bdctimgc=zeros(128,128,7);
            dout=zeros(1,26);
            dout(1:26)=-inf;
            tmc=zeros(7,7,26);
            for i=1:26
                if ~any(bdctimg(sj,sk+(0:2))+flagstr(i,:)<0) && ~any(flagstr(i,:)~=0 & modified(sj,sk:sk+2))
                    %bdctimgc(:,:,1)=bdctmod(bdctimg,sj,sk,[1 0 0]);
                    tmnew=tmmod(bdctimg,tm3,sj,sk,flagstr(i,:),T);
                    tmc(:,:,i)=tmnew;
                    [~,~,dout(i)]=svmpredict(0,svmrescale(tmnew(:)',range),model);
                    %dout_calc(1)=true;
                end
            end            
            
            %goodmodidx=(logpdf1>logpdfpre1) & (logpdf2<logpdfpre2);
            goodmodidx=( dout > dout_pre );
            %[maxlogpdf,I2]=max(logpdf);
            if any(goodmodidx)                
                %adopt the modification
                goodmodidx=find(goodmodidx);
                modweight=dout(goodmodidx);
                [~,I2]=max(modweight);
                if DEBUG
                    fprintf('delta logpdf1 is %g\n',logpdf1(goodmodidx(I2))-logpdfpre1);
                    fprintf('delta logpdf2 is %g\n',logpdf2(goodmodidx(I2))-logpdfpre2);
                end
                dout_pre=dout(goodmodidx(I2));
                bdctimg=bdctmod(bdctimg,sj,sk,flagstr(goodmodidx(I2),:));
                tm3=tmc(:,:,goodmodidx(I2));
                modified(sj,sk:sk+2)=modified(sj,sk:sk+2)|(flagstr(goodmodidx(I2),:)~=0);
                n_mod=n_mod+sum(flagstr(goodmodidx(I2),:)~=0);
                modflag=true;                
                if DEBUG
                    fprintf('%d in %d (%g) coeffs modified\n',n_mod,avaicoeff,n_mod/avaicoeff);
                end                
            end
            if modflag, break; end
            loc_idx=loc_idx+1;
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
    fprintf('n_mod=%d, dout_pre=%g\n',n_mod,dout_pre);    
end

ximg=bdctdec(bdctimg.*sign(bdctimg_ori));
moddout=dout_pre-dout_ori;
%psnrfinal=PSNR(simg,ximg);

output.dout_ori=dout_ori;
output.moddout=moddout;
output.n_mod=n_mod;

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
    subplot(2,4,2);
    imagesc(ximg,[0 255]),colormap gray
    axis image off
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
    subplot(2,4,6);
    mesh(tm3);
    a2=gca;
    zlim2=get(a2,'zlim');
    
    zmax=max([zlim1(2) zlim2(2)]);
    set(a1,'zlim',[0 zmax]);
    set(a2,'zlim',[0 zmax]);
    subplot(2,4,7);
    plot(psnrrec);
    title('PSNR');
end

function bdctimg=bdctmod(bdctimg,sj,sk,flag)
%modify bdctcoeff

bdctimg(sj,sk:sk+2)=bdctimg(sj,sk:sk+2)+flag;



           
                
                



