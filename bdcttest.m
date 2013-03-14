function [tt1,tt2,tt3,tt4,sj,sk,cr1,cr2,cr3]=bdcttest(img)
%test run time and correctness of new way of calculation of bdct coeff

img=reshape(img,128,128);
flag=1; %allways test flag==1
T=10;

%randomly select position of modified coefficients
%sj=ceil(rand*128);
%sk=ceil(rand*128);
sj=127;
sk=70;

%calculate original tm and tms
bdctimg=blkproc(img,[8 8],@dct2);
bdctimg=abs(round(bdctimg));
tm=tpm1(bdctimg,T);

%basic way of calculate new tm
tic;
newimg=img;
newimg(sj,sk)=newimg(sj,sk)+flag;
newbdctimg=blkproc(newimg,[8 8],@dct2);
newbdctimg=abs(round(newbdctimg));
tt1=toc;
%fprintf('time used in calculate new bdct %g sec\n',tt);

tic;
newtm=tpm1(newbdctimg,T);
tt2=toc;
%fprintf('time used in calculate new tpm %g sec\n',tt);

%new way of calculate new tm
tic;
j0=floor((sj-1)/8);
k0=floor((sk-1)/8);
bdctblock=dct2(newimg(j0*8+1:j0*8+8,k0*8+1:k0*8+8));
bdctblock=abs(round(bdctblock));
newbdctimg2=bdctimg;
newbdctimg2(j0*8+1:j0*8+8,k0*8+1:k0*8+8)=bdctblock;
tt3=toc;
%fprintf('time used in calculate new bdct %g sec\n',tt);

%calculate new tm
tic;
diffblock=newbdctimg2-bdctimg;
[rows,cols]=find(diffblock);
newtm2=tm;
newbdctimg3=bdctimg;
for i=1:length(rows)
    out=tmmod2(newbdctimg3,newtm2,rows(i),cols(i),diffblock(rows(i),cols(i)),T);
    newtm2=out.tm;
    newbdctimg3(rows(i),cols(i))=newbdctimg3(rows(i),cols(i))+diffblock(rows(i),cols(i));
end
tt4=toc;
%fprintf('time used in calculate new tpm %g sec\n',tt);

if isequal(newbdctimg,newbdctimg2)
    %fprintf('newbdctimg and newbdctimg2 are same\n');
    cr1=1;
else
    %fprintf('newbdctimg and newbdctimg2 are differenct\n');
    cr1=0;
end

if isequal(newbdctimg,newbdctimg3)
    %fprintf('newbdctimg and newbdctimg3 are same\n');
    cr2=1;
else
    %fprintf('newbdctimg and newbdctimg3 are different\n');
    cr2=0;
end

if isequal(newtm,newtm2)
    %fprintf('tm is same\n');
    cr3=1;
else
    %fprintf('tm is different\n');
    cr3=0;
end

