function feature=featmoment(s)

feature = [];
feature=[feature,getfeature42S(s),getfeature42D(s,2),getfeature42D(s,4),getfeature42D(s,8)];

function feature=getfeature42S(s)

feature = [];K=1;

img=s;
[sx sy]=size(img);
img1=imgestimateS(img);

[cA,cH,cV,cD] = haarwav2d(img);
com=calcom1(img,0,255);comA=calcom1(cA,0,255);comH=calcom1(cH,-255,255);comV=calcom1(cV,-255,255);comD=calcom1(cD,-510,510);
feature=[feature,com,comA,comH,comV,comD];

[cA,cH,cV,cD] = haarwav2d(img1);
com=calcom1(img1,-255,255);comA=calcom1(cA,-255,255);comH=calcom1(cH,-510,510);comV=calcom1(cV,-510,510);comD=calcom1(cD,-1020,1020);
feature=[feature,com,comA,comH,comV,comD];

img=img+1;

A1=img(1:sx-1,1:sy-1);B1=img(2:sx,1:sy-1);B2=img(1:sx-1,2:sy);

histogram1=zeros(255*K+1,255*K+1);histogram2=zeros(255*K+1,255*K+1);

for x=1:sx-1
    for y=1:sy-1
        histogram1(A1(x,y),B1(x,y))=histogram1(A1(x,y),B1(x,y))+1;
        histogram2(A1(x,y),B2(x,y))=histogram2(A1(x,y),B2(x,y))+1;
    end
end

feature=[feature,calcom2(histogram1)];feature=[feature,calcom2(histogram2)];

function feature=getfeature42D(s,K)

feature = [];

img3=s;[sx sy]=size(img3);
img=blkproc(img3,[K K],@dct2);
img1=imgestimateJ(img);

[cA,cH,cV,cD] = haarwav2d(img);
com=calcom1(img,-255*K,255*K);comA=calcom1(cA,-255*K,255*K);comH=calcom1(cH,-255*K*2,255*K*2);comV=calcom1(cV,-255*K*2,255*K*2);comD=calcom1(cD,-255*K*4,255*K*4);
feature=[feature,com,comA,comH,comV,comD];

[cA,cH,cV,cD] = haarwav2d(img1);
com=calcom1(img1,-255*K,255*K);comA=calcom1(cA,-255*K,255*K);comH=calcom1(cH,-255*K*2,255*K*2);comV=calcom1(cV,-255*K*2,255*K*2);comD=calcom1(cD,-255*K*4,255*K*4);
feature=[feature,com,comA,comH,comV,comD];

if K>2
    K=2;
end

img=round(img);

img=img.*(1-(img<-255*K)).*(1-(img>255*K))-255*K*(img<-255*K)+255*K*(img>255*K);img=img+255*K+1;

A1=img(1:sx-1,1:sy-1);B1=img(2:sx,1:sy-1);B2=img(1:sx-1,2:sy);

histogram1=zeros(255*K*2+1,255*K*2+1);histogram2=zeros(255*K*2+1,255*K*2+1);

for x=1:sx-1
    for y=1:sy-1
        histogram1(A1(x,y),B1(x,y))=histogram1(A1(x,y),B1(x,y))+1;
        histogram2(A1(x,y),B2(x,y))=histogram2(A1(x,y),B2(x,y))+1;
    end
end

feature=[feature,calcom2(histogram1)];feature=[feature,calcom2(histogram2)];

function errimg=imgestimateS(ori)

[xs,ys]=size(ori);

ori=double(ori);
estimg=zeros(xs,ys);
errimg=zeros(xs,ys);
for i=1:xs-1
    for j=1:ys-1
        estimg(i,j)=ori(i+1,j)+ori(i,j+1)-ori(i+1,j+1);
    end
end

errimg(1:xs-1,1:ys-1)=estimg(1:xs-1,1:ys-1)-ori(1:xs-1,1:ys-1);

function errimg=imgestimateJ(ori)

[xs,ys]=size(ori);

ori1=sign(double(ori));
ori=abs(double(ori));
estimg=zeros(xs,ys);
errimg=zeros(xs,ys);
for i=1:xs-1
    for j=1:ys-1
        estimg(i,j)=ori(i+1,j)+ori(i,j+1)-ori(i+1,j+1);
    end
end

estimg=estimg.*ori1;ori=ori.*ori1;

errimg(1:xs-1,1:ys-1)=estimg(1:xs-1,1:ys-1)-ori(1:xs-1,1:ys-1);