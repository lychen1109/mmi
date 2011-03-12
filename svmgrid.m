function [bestc,bestg,bestcv,cv]=svmgrid(dataTrain,grpTrain,type,rangec,rangeg)
%parameter selection

nc=length(rangec);
ng=length(rangeg);
cv=zeros(nc,ng);
        
for i=1:nc
    cvrow=zeros(1,ng);
    log2c=rangec(i);
    parfor j=1:ng        
        cmd=['-v 5 -c ' num2str(2^log2c) ' -g ' num2str(2^rangeg(j)) ' -t ' num2str(type)];        
        cvrow(j)=svmtrain(grpTrain,dataTrain,cmd);               
    end
    cv(i,:)=cvrow;
end

[bestcv,I]=max(cv(:));
[indc,indg]=ind2sub(size(cv),I);

bestc=2^rangec(indc);
bestg=2^rangeg(indg);


