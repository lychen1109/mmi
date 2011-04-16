function [bestc,bestg,bestcv,cv]=svmgrid(grpTrain,dataTrain,rangec,rangeg)
%parameter selection

nc=length(rangec);
ng=length(rangeg);
cv=zeros(nc,ng);
rangec=rangec(:);
rangeg=rangeg(:);
matlog2c=repmat(rangec,1,ng);
matlog2g=repmat(rangeg',nc,1);
matc=2.^matlog2c;
matg=2.^matlog2g;

parfor i=1:nc*ng      
    cmd=['-v 5 -c ' num2str(matc(i)) ' -g ' num2str(matg(i))];
    cv(i)=svmtrain(grpTrain,dataTrain,cmd);
end

[bestcv,I]=max(cv(:));
bestc=matlog2c(I);
bestg=matlog2g(I);







