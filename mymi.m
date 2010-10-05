function mi=mymi(c,y,sigma)
%calculate MI between class (c) and observation (y)
% reference: Kari Torkkola, Feature Extraction by Non-Parametric Mutual
% Information, 2003

N=size(y,1);

%VIN,VALL,VBTW
tmp=0;
for p=0:1
    yp=y(c==p,:);
    Jp=size(yp,1);
    for k=1:Jp
        for l=1:Jp
            tmp=tmp+gauss_kernel((yp(k,:)-yp(l,:))',sigma);
        end
    end
end
VIN=tmp/(N^2);

tmp=0;
for k=1:N
    for l=1:N
        tmp=tmp+gauss_kernel((y(k,:)-y(l,:))',sigma);
    end
end
tmp1=0;
for p=0:1
   Jp= length(find(c==p));
   tmp1=tmp1 + (Jp/N)^2;
end
VALL=tmp1*tmp/(N^2);

tmp1=0;
for p=0:1
    yp=y(c==p,:);
    Jp=size(yp,1);
    tmp=0;
    for j=1:Jp
       for k=1:N
           tmp=tmp+gauss_kernel((yp(j,:)-y(k,:))',sigma);
       end
    end
    tmp1=tmp1+(Jp/N)*tmp;
end
VBTW=tmp1/(N^2);

mi=VIN+VALL-2*VBTW;
%fprintf('VIN=%f,  VALL=%f,  VBTW=%f\n',VIN,VALL,VBTW);

