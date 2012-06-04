function tmmodrectest(img)
%test tmmodrec function

K=2;
T=40;
img=reshape(img,128,128);
sj=ceil(rand*128);
sk=ceil(rand*128);
flagidx=ceil(rand*2*K);
rangek=-K:-1;
rangek=cat(2,rangek,1:K);
flag=rangek(flagidx);

%calculate tpm with tpm function
tms=tpm1(img,T);

imgnew=img;
imgnew(sj,sk)=imgnew(sj,sk)+flag;
tmsnew=tpm1(imgnew,T);

%use tmmodrec
change=tmmodrec(img,sj,sk,flag,T);
tmsnew2=tms;
tmsnew2(change(:,1))=tmsnew2(change(:,1))+change(:,2);

if isequal(tmsnew,tmsnew2)
    fprintf('The two are same\n');
else
    fprintf('The two are different\n');
end

