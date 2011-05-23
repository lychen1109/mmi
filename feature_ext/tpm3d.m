function D=tpm3d(img,T)
%transition matrix of 3rd markov

diffimg=img(:,1:end-1)-img(:,2:end);
diffimg(diffimg>T)=T;
diffimg(diffimg<-T)=-T;
diffimg=diffimg+T+1;
y1=diffimg(:,1:end-2);
y2=diffimg(:,2:end-1);
y3=diffimg(:,3:end);

D=zeros(2*T+1,2*T+1,2*T+1);
for i=1:length(y1(:))
    D(y1(i),y2(i),y3(i))=D(y1(i),y2(i),y3(i))+1;
end
D=D/length(y1(:));
D=D(:)';