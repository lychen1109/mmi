function accu=gmmclassify(labeltrain,datatrain,labeltest,datatest,k)
% classify with GMM model

%remove the last column
% datatrain=datatrain(:,1:end-1);
% datatest=datatest(:,1:end-1);

class1=datatrain(labeltrain==1,:);
class2=datatrain(labeltrain==0,:);
idx1=kmeans(class1,k,'replicates',20);
idx2=kmeans(class2,k,'replicates',20);
gm1=gmdistribution.fit(class1,k,'start',idx1,'covtype','diagonal','SharedCov',false);
gm2=gmdistribution.fit(class2,k,'start',idx2,'covtype','diagonal','SharedCov',false);

predict=zeros(size(labeltest));
N=size(datatest,1);
for i=1:N
    testsample=datatest(i,:);
    p1=pdf(gm1,testsample);
    p2=pdf(gm2,testsample);
    if p1>p2
        predict(i)=1;
    end
end

accu=sum(predict==labeltest)/N;
%fprintf('accuracy=%g\n',accu);
