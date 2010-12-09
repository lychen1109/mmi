function [y,cb,cr]=myrgb2ycbcr(img)
%difference from matlab included rgb2ycbcr, here all values are 0..255

img=double(img);
y=round(0.299*img(:,:,1)+0.587*img(:,:,2)+0.114*img(:,:,3));
cb=128+round(-0.168736*img(:,:,1)-0.331264*img(:,:,2)+0.5*img(:,:,3));
cr=128+round(0.5*img(:,:,1)-0.418688*img(:,:,2)-0.081312*img(:,:,3));