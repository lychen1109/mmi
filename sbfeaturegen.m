function [feats,featb,featc]=sbfeaturegen(auimages,bdctimgs,T)
%spatial and bdct domain feature generation
%auimages is original image in dataset. bdctimgs is bdct coefficients 

Nau=size(auimages,1);
Nsp=size(bdctimgs,1);

%spatial features
tms_au=transmatgenbdct(auimages,T);
ximages=bdctdecall(bdctimgs);
tms_sp=transmatgenbdct(ximages,T);
tms_au=reshape(tms_au,(2*T+1)^2,Nau)';
tms_sp=reshape(tms_sp,(2*T+1)^2,Nsp)';
feats=[tms_au;tms_sp];
feats=svmrescale(feats);

%bdct domain features
tm_au=transmatgen(auimages,T);
tm_sp=transmatgenbdct(bdctimgs,T);
tm_au=reshape(tm_au,(2*T+1)^2,Nau)';
tm_sp=reshape(tm_sp,(2*T+1)^2,Nsp)';
featb=[tm_au;tm_sp];
featb=svmrescale(featb);

featc=[feats featb];