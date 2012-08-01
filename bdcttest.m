function bdcttest(img)
%test run time and correctness of new way of calculation of bdct coeff

img=reshape(img,128,128);
flag=1; %allways test flag==1
T=10;

%randomly select position of modified coefficients
sj=ceil(rand*128);
sk=ceil(rand*128);

%calculate original tm and tms
bdctimg=blkproc(img,[8 8],@dct2);
bdctimg=abs(round(bdctimg));

%basic way of calculate new tm
tic;
newimg=img;
newimg(sj,sk)=newimg(sj,sk)+flag;
newbdctimg=blkproc(newimg,[8 8],@dct2);
newbdctimg=abs(round(newbdctimg));
newtm=tpm1(newbdctimg,T);
toc;
%new way of calculate new tm
tic;
j0=floor((sj-1)/8);
k0=floor((sk-1)/8);
bdctblock=dct2(newimg(j0*8+1:j0*8+8,k0*8+1:k0*8+8));
bdctblock=abs(round(bdctblock));
newbdctimg2=bdctimg;
newbdctimg2(j0*8+1:j0*8+8,k0*8+1:k0*8+8)=bdctblock;
newtm2=tpm1(newbdctimg2,T);
toc;

if isequal(newbdctimg,newbdctimg2)
    fprintf('bdct is same\n');
else
    fprintf('bdct is differenct\n');
end

if isequal(newtm,newtm2)
    fprintf('tm is same\n');
else
    fprintf('tm is different\n');
end

