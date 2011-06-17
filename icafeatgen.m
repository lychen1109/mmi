function f=icafeatgen(imgs,W)
%generate marginal histogram with ica transform

T=8;
N=size(imgs,1);
f=zeros(N,52);
for i=1:N
    img=imgs(i,:);
    img=reshape(img,128,128);
    h1=feat(img,T,W(:,1));
    h2=feat(img,T,W(:,2));
    f(i,:)=[h1(:)' h2(:)'];
end


function h=feat(img,T,w)
y=img(:,1:end-1)-img(:,2:end);
y(y>T)=T;
y(y<-T)=-T;
y1=y(:,1:end-1);
y2=y(:,2:end);
z=w'*[y1(:) y2(:)]';
B=floor((abs(w(1))+abs(w(2)))*T);
h=hist(z(:),-B:B);
h=h/length(z(:));
