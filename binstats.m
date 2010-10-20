function statmat=binstats(autrain,sptrain)
%chek frequency of bin used

imgs=[autrain;sptrain];
statmat=zeros(511,511);
for i=1:size(imgs,1)
    img=imgs(i,:);
    img=reshape(img,128,128);
    D=tpm(img);
    usedmat=zeros(511,511);
    usedmat(D(:,:,1)>0)=1;
    statmat=statmat+usedmat;
end