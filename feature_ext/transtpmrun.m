function feat=transtpmrun(images,T)
%run transtpm on whole dataset

N=size(images,1);
feat=zeros(2*T+1,2*T+1,N);
for i=1:N
    img=images(i,:);
    img=reshape(img,128,128);
    feat(:,:,i)=transtpm(img,T);
end
