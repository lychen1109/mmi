function h=marginhist(img,T)
%image histogram

bdctimg=blkproc(img,[8 8],@dct2);
bdctimg=abs(round(bdctimg));
diff=bdctimg(:,1:end-1)-bdctimg(:,2:end);
[N,M]=size(img);
diff(diff>T)=T;
diff(diff<-T)=-T;
x=-T:T;
h=hist(diff(:),x);
h=h/(N*(M-1));
h=h(:)';
