function logpdfnews=histhackmtest(simg,gm,PCAstruct)
%test performance of histhackm under difference params

logpdfnews=zeros(10,1);
parfor i=1:10
    randidx=randperm(127*128);
    [~,~,~,logpdfnews(i)]=histhackm(simg,gm,PCAstruct,randidx,2,inf);
end

    