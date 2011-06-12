function Z=dependtest(img)
%test the dependency of constructed variables

img=double(img);
img=img-mean(img(:));
bdctimg=blkproc(img,[8 8],@dct2);
bdctimg=abs(bdctimg);
y=bdctimg(:,1:end-1)-bdctimg(:,2:end);
T=8;
y(y>T)=T;
y(y<-T)=-T;
y1=y(:,1:end-1);
y2=y(:,2:end);
z1=0.71*(y1-y2);
z2=0.71*(y1+y2);
B=round(0.71*2*T);
z1=round(z1)+B+1;
z2=round(z2)+B+1;

Z=zeros(2*B+1,2*B+1);
for i=1:length(z1(:))
    Z(z1(i),z2(i))=Z(z1(i),z2(i))+1;
end

for i=1:2*B+1
    if sum(Z(i,:))~=0
        Z(i,:)=Z(i,:)/sum(Z(i,:));
    end
end
