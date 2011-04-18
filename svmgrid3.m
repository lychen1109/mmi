function [bestc,bestg1,bestg2,bestcv,cvmat]=svmgrid3(label,feat,group,rangec,rangeg1,rangeg2)
%svmgrid3 does grid search with three hyper-parameters

%turn ranges into column vectors
rangec=rangec(:);
rangeg1=rangeg1(:);
rangeg2=rangeg2(:);

NC=length(rangec);
NG1=length(rangeg1);
NG2=length(rangeg2);
n_train=length(label);

cvmat=zeros(NG1,NG2,NC);
log2c(1,1,1:NC)=rangec;
log2c=repmat(log2c,NG1,NG2);
log2g1=repmat(rangeg1,[1,NG2,NC]);
log2g2=repmat(rangeg2',[NG1,1,NC]);

parfor i=1:NC*NG1*NG2
    theta=[log2c(i) log2g1(i) log2g2(i)];
    gt=grouptemplate(group,theta);
    ktrain=crossdist(feat,feat,gt);
    ktrain=exp(-ktrain);
    cmd=['-c ' num2str(2^log2c(i)) ' -t 4 -v 5'];
    cvmat(i)=svmtrain(label,[(1:n_train)' ktrain],cmd);
end

[matg,Ic]=max(cvmat,[],3);
[bestcv,Ig]=max(matg(:));
[Ig1,Ig2]=ind2sub([NG1 NG2],Ig);
bestc=Ic(Ig1,Ig2);
bestg1=rangeg1(Ig1);
bestg2=rangeg2(Ig2);