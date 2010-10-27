function sumcmat=coocmatstat(imgs)
%sum of coocmatstat

N=size(imgs,1);
sumcmat=zeros(511,511);
for i=1:N
    img=imgs(i,:);
    img=reshape(img,128,128);
    sumcmat=sumcmat+coocmat(img);
end