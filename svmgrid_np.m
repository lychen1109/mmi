function [bestc,bestg,bestcv]=svmgrid_np(dataTrain,grpTrain,display,type,rangec,rangeg,mem)
%parameter selection

if nargin<4
    type=2;
end

if nargin<5
    rangec=-5:2:15;
    rangeg=3:-2:-15;
end

bestcv=0;

for log2g=rangeg
    for log2c=rangec
        if type==0
            cmd=['-v 5 -c ' num2str(2^log2c) ' -t 0 -m ' num2str(mem)];
        else
            cmd=['-v 5 -c ' num2str(2^log2c) ' -g ' num2str(2^log2g) ' -m ' num2str(mem)];
        end
        cv=svmtrain(grpTrain,dataTrain,cmd);
        if bestcv<cv
            bestcv=cv;
            bestlog2c=log2c;
            bestlog2g=log2g;
        end
        if display>0
            fprintf('%g %g %g\n',log2c,log2g,cv);
        end
    end
end

bestc=2^bestlog2c;
bestg=2^bestlog2g;


