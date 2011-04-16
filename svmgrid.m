function [bestc,bestg,bestcv,cv]=svmgrid(grpTrain,dataTrain,rangec,rangeg)
%parameter selection

nc=length(rangec);
ng=length(rangeg);
cv=zeros(nc,ng);
rangec=rangec(:);
rangeg=rangeg(:);
matc=repmat(rangec,1,ng);
matg=repmat(rangeg',nc,1);
matc=2.^matc;
matg=2.^matg;

parfor i=1:length(cv(:))      
    cmd=['-v 5 -c ' num2str(matc(i)) ' -g ' num2str(matg(i))];
    cv(i)=svmtrain(grpTrain,dataTrain,cmd);
end

[bestcv,I]=max(cv(:));
bestc=matc(I);
bestg=matg(I);







