function jpg_imgs=bmp2jpg(imgs)
%turn bit map images into abosolute jpeg 2D array

N=size(imgs,1);
jpg_imgs=zeros(N,128*128);
for i=1:N
    fprintf('processing %dth image\n',i);
    img=imgs(i,:);
    img=reshape(img,128,128);
    img=uint8(img);
    t='temp.jpg';
    imwrite(img,t,'jpg','Quality',100);
    clear img;
    jobj=jpeg_read(t);
    delete(t);
    img=abs(jobj.coef_arrays{1});
    jpg_imgs(i,:)=img(:)';
end
