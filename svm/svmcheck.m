function ac=svmcheck(label,images,range,rangec,rangeg)
%feature extraction and svm test

N=size(images,1);
tm=transmatgen(images,3);
feat=reshape(tm,49,N)';
feat=svmrescale(feat,range);
ac=svmtestk(label,feat,rangec,rangeg);