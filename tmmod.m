function tm=tmmod(bdctimg,tm,sj,sk,flag,T)
%modify transmition probability directly

S=1/(128*126);
for i=1:3
    if flag(i)~=0
        rj=sj;
        rk=sk+i-1;        
        if rk-2>0
            y1=threshold(bdctimg(rj,rk-2)-bdctimg(rj,rk-1),T);
            y2=threshold(bdctimg(rj,rk-1)-bdctimg(rj,rk),T);
            y3=y1;
            y4=threshold(bdctimg(rj,rk-1)-bdctimg(rj,rk)-flag(i),T);
            tm(y1+T+1,y2+T+1)=tm(y1+T+1,y2+T+1)-S;
            tm(y3+T+1,y4+T+1)=tm(y3+T+1,y4+T+1)+S;
        end
        
        if rk-1>0 && rk+1<129
            y1=threshold(bdctimg(rj,rk-1)-bdctimg(rj,rk),T);
            y2=threshold(bdctimg(rj,rk)-bdctimg(rj,rk+1),T);
            y3=threshold(bdctimg(rj,rk-1)-bdctimg(rj,rk)-flag(i),T);
            y4=threshold(bdctimg(rj,rk)-bdctimg(rj,rk+1)+flag(i),T);
            tm(y1+T+1,y2+T+1)=tm(y1+T+1,y2+T+1)-S;
            tm(y3+T+1,y4+T+1)=tm(y3+T+1,y4+T+1)+S;
        end
        
        if rk+2<129
            y1=threshold(bdctimg(rj,rk)-bdctimg(rj,rk+1),T);
            y2=threshold(bdctimg(rj,rk+1)-bdctimg(rj,rk+2),T);
            y3=threshold(bdctimg(rj,rk)-bdctimg(rj,rk+1)+flag(i),T);
            y4=y2;
            tm(y1+T+1,y2+T+1)=tm(y1+T+1,y2+T+1)-S;
            tm(y3+T+1,y4+T+1)=tm(y3+T+1,y4+T+1)+S;
        end
    end
end

function t=threshold(t,T)
t=min(t,T);
t=max(t,-T);