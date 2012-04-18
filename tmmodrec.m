function change=tmmodrec(img,sj,sk,flag,T)
%calculate mod effect on tm
%difference between tmmodrec and tmmod2 is it returns change

change=[];
if flag==0
    return;
end
if sk-2>0
    y1=threshold(img(sj,sk-2)-img(sj,sk-1),T);
    y2=threshold(img(sj,sk-1)-img(sj,sk),T);
    y3=y1;
    y4=threshold(img(sj,sk-1)-img(sj,sk)-flag,T);
    change=cat(1,change,[y1+T+1 y2+T+1 -1]);
    change=cat(1,change,[y3+T+1 y4+T+1 1]);
end

if sk+2<129
    y1=threshold(img(sj,sk)-img(sj,sk+1),T);
    y2=threshold(img(sj,sk+1)-img(sj,sk+2),T);
    y3=threshold(img(sj,sk)-img(sj,sk+1)+flag,T);
    y4=y2;
    change=cat(1,change,[y1+T+1 y2+T+1 -1]);
    change=cat(1,change,[y3+T+1 y4+T+1 1]);
end

if sk-1>0 && sk+1<129
    y1=threshold(bdctimg(sj,sk-1)-bdctimg(sj,sk),T);
    y2=threshold(bdctimg(sj,sk)-bdctimg(sj,sk+1),T);
    y3=threshold(bdctimg(sj,sk-1)-bdctimg(sj,sk)-flag,T);
    y4=threshold(bdctimg(sj,sk)-bdctimg(sj,sk+1)+flag,T);
    change=cat(1,change,[y1+T+1 y2+T+1 -1]);
    change=cat(1,change,[y3+T+1 y4+T+1 1]);
end
