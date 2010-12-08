function [bestc,bestg,bestcv,Z]=svmgrid_np(dataTrain,grpTrain,display,type,rangec,rangeg,mem)
%parameter selection, nonparallel version

if nargin<4
    type=2;
end

if nargin<5
    rangec=-5:2:15;
    rangeg=3:-2:-15;
end

bestcv=0;
Z=zeros(length(rangeg),length(rangec));
i=0;
j=0;

for log2g=rangeg
    i=i+1;
    for log2c=rangec
        j=j+1;
        if type==0
            cmd=['-v 5 -c ' num2str(2^log2c) ' -t 0 -m ' num2str(mem)];
        else
            cmd=['-v 5 -c ' num2str(2^log2c) ' -g ' num2str(2^log2g) ' -m ' num2str(mem)];
        end
        cv=svmtrain(grpTrain,dataTrain,cmd);
        Z(i,j)=cv;
        if bestcv<cv
            bestcv=cv;
            bestlog2c=log2c;
            bestlog2g=log2g;
        end
        if display>0
            fprintf('%g %g %g\n',log2g,log2c,cv);
        end
    end
    j=0;
end

bestc=2^bestlog2c;
bestg=2^bestlog2g;


