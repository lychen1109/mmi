function [bestg,bestc,bestcv]=svmgrid_kernel(grptrain,datatrain,display,rangec,rangeg,kerneltype)
%C selection for pre-computed kernels

bestcv=0;
n_training=length(grptrain);

for log2g=rangeg
    switch kerneltype
        case 'kld_sym'
            kerneltrain=klkernel(datatrain,datatrain,2^log2g,'sym');
        case 'kld_js'
            kerneltrain=klkernel(datatrain,datatrain,2^log2g,'js');
        case 'gauss'
            kerneltrain=rbfkernel(datatrain,datatrain,2^log2g);
        otherwise
            error('Possible kerneltypes are: kld_sym, kld_js, gauss');    
    end    
    
    for log2c=rangec        
        cmd=['-c ' num2str(2^log2c) ' -t 4 -v 5'];
        cv=svmtrain(grptrain,[(1:n_training)' kerneltrain],cmd);
        if bestcv<cv
            bestcv=cv;
            bestg=2^log2g;
            bestc=2^log2c;
        end
        if display>0
            fprintf('%g %g %g\n',log2g,log2c,cv);
        end
    end
end
