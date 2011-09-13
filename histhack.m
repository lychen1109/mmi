function histhack(label,images,idx1,idx2)
%reshape histogram by modifying LSB

aimages=images(label==1,:);
simages=images(label==0,:);
simg=simages(idx2,:);
simg=reshape(simg,128,128);
aimg=aimages(idx1,:);
aimg=reshape(aimg,128,128);
NMOD=10; %maximum allowed number of modified coeff
tm1=tpm1d(aimg,4,0,0);
tm2=tpm1d(simg,4,0,0);
bdctimg=blkproc(simg,[8 8],@dct2);
bdctimg_ori=bdctimg;
bdctimg=round(abs(bdctimg));
modified=false(size(bdctimg));%record if a coef has been modified

% [p,I]=max(tmx(:));
% [j,k]=ind2sub([9 9],I);
% fprintf('The maximum positive difference of histogram is %g, at (%d,%d)\n',p,j-5,k-5);
n_mod=0; %number of modified coef


while n_mod<NMOD
    tm3=tpm1(bdctimg,4);
    tmx=tm3-tm1;
    [~,I]=sort(tmx(:),1,'descend');
    t_bin=1; %index of target bin
    modflag=false;
    while tmx(I(t_bin))>0
        %find candidate dct coeff
        bdctimgx=dcnan(bdctimg);
        diffimg=bdctimgx(:,1:end-1)-bdctimg(:,2:end);
        [j,k]=ind2sub(size(tmx),I(t_bin));
        diffimg1=(diffimg(:,1:end-1)==(j-5));
        diffimg2=(diffimg(:,2:end)==(k-5));
        location=diffimg1&diffimg2;
        num=sum(sum(location));
        fprintf('There are %d number of coef to be modified\n',num);
        
        locations=find(location);
        randidx=randperm(num);
        loc_idx=1; %start from the first location
        while loc_idx<=num
            loc=locations(randidx(loc_idx));
            [loc_j,loc_k]=ind2sub(size(bdctimg),loc);
            for i=0:2
                sj=loc_j;
                sk=loc_k+i;
                if bdctimg(sj,sk)<2 || modified(sj,sk)
                    continue;
                end
                if mod(bdctimg(sj,sk),2)==0
                    if sk-2>0
                       diff1=bdctimg(sj,sk-2)-bdctimg(sj,sk-1);
                       diff2=bdctimg(sj,sk-1)-bdctimg(sj,sk);
                       diff3=diff1;
                       diff4=diff2-1;
                       
                       diff1=threshold(diff1,4);
                       diff2=threshold(diff2,4);
                       diff3=threshold(diff3,4);
                       diff4=threshold(diff4,4);
                       if diff4==diff2
                           if i==2, continue; end                       
                       elseif tmx(diff1,diff2)<0 ||tmx(diff3,diff4)>0
                           continue;
                       end                       
                    end
                    
                    if sk-1>0 && sk<128
                        diff1=bdctimg(sj,sk-1)-bdctimg(sj,sk);
                        diff2=bdctimg(sj,sk)-bdctimg(sj,sk+1);
                        diff3=diff1-1;
                        diff4=diff2+1;
                        diff1=threshold(diff1,4);
                        diff2=threshold(diff2,4);
                        diff3=threshold(diff3,4);
                        diff4=threshold(diff4,4);
                        if diff1==diff3 && diff2==diff4
                            if i==1,continue; end
                        elseif tmx(diff1,diff2)<0 ||tmx(diff3,diff4)>0
                            continue;
                        end                        
                    end
                    
                    if sk<127
                        diff1=bdctimg(sj,sk)-bdctimg(sj,sk+1);
                        diff2=bdctimg(sj,sk+1)-bdctimg(sj,sk+2);
                        diff3=diff1+1;
                        diff4=diff2;
                        diff1=threshold(diff1,4);
                        diff2=threshold(diff2,4);
                        diff3=threshold(diff3,4);
                        diff4=threshold(diff4,4);
                        if diff1==diff3
                            if i==0,continue; end
                        elseif tmx(diff1,diff2)<0 || tmx(diff3,diff4)>0
                            continue;
                        end
                    end
                    bdctimg(sj,sk)=bdctimg(sj,sk)+1;
                    modified(sj,sk)=true;
                    n_mod=n_mod+1;
                    modflag=true;
                    break;
                else
                    if sk-2>0
                       diff1=bdctimg(sj,sk-2)-bdctimg(sj,sk-1);
                       diff2=bdctimg(sj,sk-1)-bdctimg(sj,sk);
                       diff3=diff1;
                       diff4=diff2+1;
                       
                       diff1=threshold(diff1,4);
                       diff2=threshold(diff2,4);
                       diff3=threshold(diff3,4);
                       diff4=threshold(diff4,4);
                       if diff4==diff2
                           if i==2, continue; end                       
                       elseif tmx(diff1,diff2)<0 ||tmx(diff3,diff4)>0
                           continue;
                       end                       
                    end
                    
                    if sk-1>0 && sk<128
                        diff1=bdctimg(sj,sk-1)-bdctimg(sj,sk);
                        diff2=bdctimg(sj,sk)-bdctimg(sj,sk+1);
                        diff3=diff1+1;
                        diff4=diff2-1;
                        diff1=threshold(diff1,4);
                        diff2=threshold(diff2,4);
                        diff3=threshold(diff3,4);
                        diff4=threshold(diff4,4);
                        if diff1==diff3 && diff2==diff4
                            if i==1,continue; end
                        elseif tmx(diff1,diff2)<0 ||tmx(diff3,diff4)>0
                            continue;
                        end                        
                    end
                    
                    if sk<127
                        diff1=bdctimg(sj,sk)-bdctimg(sj,sk+1);
                        diff2=bdctimg(sj,sk+1)-bdctimg(sj,sk+2);
                        diff3=diff1-1;
                        diff4=diff2;
                        diff1=threshold(diff1,4);
                        diff2=threshold(diff2,4);
                        diff3=threshold(diff3,4);
                        diff4=threshold(diff4,4);
                        if diff1==diff3
                            if i==0,continue; end
                        elseif tmx(diff1,diff2)<0 || tmx(diff3,diff4)>0
                            continue;
                        end
                    end
                    bdctimg(sj,sk)=bdctimg(sj,sk)-1;
                    modified(sj,sk)=true;
                    n_mod=n_mod+1;
                    modflag=true;
                    break;
                end                
            end
            if modflag, break; end            
        end
        if modflag,break;end
    end
    if modflag==false, break;end
end

fprintf('%d coeff modified\n',n_mod);
tm3=tpm1(bdctimg,4);
bdctimg=bdctimg.*sign(bdctimg_ori);
ximg=blkproc(bdctimg,[8 8],@idct2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot the result
%%%%%%%%%%%%%%%%%%%%%%%%%%%

m=max(max([tm1 tm2 tm3]));
m=ceil(m*10)/10;

subplot(2,3,1);
imagesc(aimg),colormap gray
subplot(2,3,2);
imagesc(simg),colormap gray
subplot(2,3,3);
imagesc(ximg),colormap gray
subplot(2,3,4);
mesh(tm1);
axis([0 10 0 10 0 m]);
subplot(2,3,5);
mesh(tm2);
axis([0 10 0 10 0 m]);
subplot(2,3,6);
mesh(tm3);
axis([0 10 0 10 0 m]);

function s=threshold(s,T)
%threshold a value according to T
if s>T, s=T;end
if s<-T,s=-T;end


