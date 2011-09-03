function img2=imrescale(image)
%rescale the image by averaging four pixels

img2=zeros(64,64);
for i=1:64
    for j=1:64
        tmp=image((i-1)*2+(1:2),(j-1)*2+(1:2));
        img2(i,j)=sum(tmp(:))/4;
    end
end
