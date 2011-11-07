function [ximg,modified,output]=histhackm2steptest(data,gm1,gm2)
%test histhackm2steptest

simg=data.datavalidate(1,:);
simg=reshape(simg,128,128);
modified=false(size(simg));
[ximg,modified,output]=histhackm2step(simg,modified,gm1,gm2);
