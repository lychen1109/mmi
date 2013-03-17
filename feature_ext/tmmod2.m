function out=tmmod2(bdctimg,tm,sj,sk,flag,T)
%tmmod used for diffimg, compared with tmmod, this only consider one pixel
%at a time

%S=1/127/126;
S=1;
tmold=tm;
M=size(bdctimg,2);
if sk-2>0
    y1=threshold(bdctimg(sj,sk-2)-bdctimg(sj,sk-1),T);
    y2=threshold(bdctimg(sj,sk-1)-bdctimg(sj,sk),T);
    y3=y1;
    y4=threshold(bdctimg(sj,sk-1)-bdctimg(sj,sk)-flag,T);
    tm(y1+T+1,y2+T+1)=tm(y1+T+1,y2+T+1)-S;
    tm(y3+T+1,y4+T+1)=tm(y3+T+1,y4+T+1)+S;
end

if sk<M-1
    y1=threshold(bdctimg(sj,sk)-bdctimg(sj,sk+1),T);
    y2=threshold(bdctimg(sj,sk+1)-bdctimg(sj,sk+2),T);
    y3=threshold(bdctimg(sj,sk)-bdctimg(sj,sk+1)+flag,T);
    y4=y2;
    tm(y1+T+1,y2+T+1)=tm(y1+T+1,y2+T+1)-S;
    tm(y3+T+1,y4+T+1)=tm(y3+T+1,y4+T+1)+S;
end

if sk-1>0 && sk<M
    y1=threshold(bdctimg(sj,sk-1)-bdctimg(sj,sk),T);
    y2=threshold(bdctimg(sj,sk)-bdctimg(sj,sk+1),T);
    y3=threshold(bdctimg(sj,sk-1)-bdctimg(sj,sk)-flag,T);
    y4=threshold(bdctimg(sj,sk)-bdctimg(sj,sk+1)+flag,T);
    tm(y1+T+1,y2+T+1)=tm(y1+T+1,y2+T+1)-S;
    tm(y3+T+1,y4+T+1)=tm(y3+T+1,y4+T+1)+S;
end
out.tm=tm;
if ~isequal(tm,tmold)
    out.changed=true;
else
    out.changed=false;
end
