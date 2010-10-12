function svmfeature=svmformat(autrainfeature,sptrainfeature)
%format features for svm

ausize=size(autrainfeature,1);
spsize=size(sptrainfeature,1);
label=[zeros(ausize,1);ones(spsize,1)];

allfeature=[autrainfeature;sptrainfeature];
svmfeature=[label allfeature];