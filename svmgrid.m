function [bestc,bestg,bestcv,cv]=svmgrid(dataTrain,grpTrain,type,rangec,rangeg)
%parameter selection

nc=length(rangec);
ng=length(rangeg);
cv=zeros(nc,ng);
        
for i=1:nc
    cvrow=zeros(1,ng);
    c=rangec(i);
    parfor j=1:ng        
        cmd=['-v 5 -c ' num2str(c) ' -g ' num2str(rangeg(j)) ' -t ' num2str(type)];        
        cvrow(j)=svmtrain(grpTrain,dataTrain,cmd);               
    end
    cv(i,:)=cvrow;
end

[bestcv,I]=max(cv(:));
[indc,indg]=ind2sub(size(cv),I);

bestc=rangec(indc);
bestg=rangeg(indg);


