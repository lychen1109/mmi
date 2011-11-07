function output=datasplit(images,label)
%split data into model-training, validation, test sets

cvp=cvpartition(label,'kfold',3);
datamodel=images(cvp.test(1),:);
labelmodel=label(cvp.test(1));
datavalidate=images(cvp.test(2),:);
labelvalidate=label(cvp.test(2));
datatest=images(cvp.test(3),:);
labeltest=label(cvp.test(3));

output.datamodel=datamodel;
output.labelmodel=labelmodel;
output.datavalidate=datavalidate;
output.labelvalidate=labelvalidate;
output.datatest=datatest;
output.labeltest=labeltest;
