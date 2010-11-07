function [bestc,bestg]=svmgrid(dataTrain,grpTrain,rangec,rangeg)
%parameter selection

if nargin<4
    rangec=-5:15;
    rangeg=5:-1:-15;
end

bestcv=0;
for log2c=rangec
    for log2g=rangeg
        cmd=['-v 5 -c ' num2str(2^log2c) ' -g ' num2str(2^log2g)];
        cv=svmtrain(grpTrain,dataTrain,cmd);
        if cv>bestcv
            bestcv=cv; bestc=2^log2c; bestg=2^log2g;
        end
        fprintf('%g %g %g (best c=%g, g=%g, rate=%g)\n',log2c,log2g,cv,bestc,bestg,bestcv);
    end
end
