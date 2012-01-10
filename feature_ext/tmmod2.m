function tm=tmmod2(diffimg,tm,sj,sk,flag,T)
%tmmod used for diffimg

S=1/127/126;
if flag(1)~=0 && sk-1>0
    y1=threshold(diffimg(sj,sk-1),T);
    y2=threshold(diffimg(sj,sk),T);
    y3=y1;
    y4=threshold(diffimg(sj,sk)+flag(1),T);
    tm(y1+T+1,y2+T+1)=tm(y1+T+1,y2+T+1)-S;
    tm(y3+T+1,y4+T+1)=tm(y3+T+1,y4+T+1)+S;
end

if flag(2)~=0 && sk+2<128
    y1=threshold(diffimg(sj,sk+1),T);
    y2=threshold(diffimg(sj,sk+2),T);
    y3=threshold(diffimg(sj,sk+1)+flag(2),T);
    y4=y2;
    tm(y1+T+1,y2+T+1)=tm(y1+T+1,y2+T+1)-S;
    tm(y3+T+1,y4+T+1)=tm(y3+T+1,y4+T+1)+S;
end

y1=threshold(diffimg(sj,sk),T);
y2=threshold(diffimg(sj,sk+1),T);
y3=threshold(diffimg(sj,sk)+flag(1),T);
y4=threshold(diffimg(sj,sk+1)+flag(2),T);
tm(y1+T+1,y2+T+1)=tm(y1+T+1,y2+T+1)-S;
tm(y3+T+1,y4+T+1)=tm(y3+T+1,y4+T+1)+S;