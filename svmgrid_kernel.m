function [bestc,bestcv]=svmgrid_kernel(grptrain,kerneltrain,display,rangec)
%C selection for pre-computed kernels

bestcv=0;
n_training=length(grptrain);

for log2c=rangec
    cmd=['-c ' num2str(2^log2c) ' -t 4 -v 5'];
    cv=svmtrain(grptrain,[(1:n_training)' kerneltrain],cmd);
    if bestcv<cv
        bestcv=cv;
        bestc=2^log2c;
    end
    if display>0
        fprintf('%g %g\n',log2c,cv);
    end
end
