function [thetas,thresholds,besttp]=svmgridtp(label,feat,rangec,rangeg)
%grid search for best tp under 0.1 fp

nc=length(rangec);
ng=length(rangeg);
cvmat=zeros(nc,ng);
log2c=repmat(rangec(:),1,ng);
log2g=repmat(rangeg(:)',nc,1);
thetas=[log2c(:) log2g(:)];
thresholds=zeros(nc*ng,1);
parfor i=1:nc*ng
    dvalues=dvaluegen(label,feat,thetas(i,:));
    threshold=0;
    [cvmat(i),fp]=rocgen(label,dvalues,threshold);
    while fp>0.1
        threshold=threshold-0.01;
        [cvmat(i),fp]=rocgen(label,dvalues,threshold);
    end
    thresholds(i)=threshold;
end

besttp=max(cvmat(:));
selection=(cvmat==besttp);
thetas=thetas(selection(:),:);
thresholds=thresholds(selection(:));
