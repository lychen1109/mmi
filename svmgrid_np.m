function [bestg,bestc,bestcv]=svmgrid_np(grpTrain,dataTrain,display,rangec,rangeg)
%parameter selection, nonparallel version

bestcv=0;
more_cmd=' -e 0.1 -h 1';

for log2g=rangeg    
    for log2c=rangec                
        cmd=['-v 5 -c ' num2str(2^log2c) ' -g ' num2str(2^log2g) more_cmd];        
        cv=svmtrain(grpTrain,dataTrain,cmd);                
        if bestcv<cv
            bestcv=cv;
            bestc=2^log2c;
            bestg=2^log2g;
        end
        if display>0
            fprintf('%g %g %g\n',log2g,log2c,cv);
        end
    end    
end




