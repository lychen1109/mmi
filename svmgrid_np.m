function [bestg,bestc,bestcv,Z]=svmgrid_np(grpTrain,dataTrain,display,type,rangec,rangeg,kernel)
%parameter selection, nonparallel version

bestcv=0;
Z=zeros(length(rangeg),length(rangec));
i=0;
j=0;
[n_data,~]=size(dataTrain);

for log2g=rangeg
    i=i+1;
    for log2c=rangec
        j=j+1;        
        cmd=['-v 5 -c ' num2str(2^log2c) ' -g ' num2str(2^log2g) ' -t ' num2str(type)];
        if type==4
            cv=svmtrain(grpTrain,[(1:n_data)' dataTrain*kernel*dataTrain'],cmd);
        else
            cv=svmtrain(grpTrain,dataTrain,cmd);
        end
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


