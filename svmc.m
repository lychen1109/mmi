function bestc=svmc(dataTrain,grpTrain)
%search c only

rangec=-5:2:15;
bestcv=0;
for log2c=rangec
    cmd=['-v 5 -t 0 -c ' num2str(2^log2c)];
    cv=svmtrain(grpTrain,dataTrain,cmd);
    if cv>bestcv
        bestcv=cv; bestc=2^log2c;
    end
    fprintf('%g %g (best c=%g, rate=%g)\n',log2c,cv,bestc,bestcv);
end

for log2c=log2(bestc)+(-2:0.25:2)
    cmd=['-v 5 -t 0 -c ' num2str(2^log2c)];
    cv=svmtrain(grpTrain,dataTrain,cmd);
    if cv>bestcv
        bestcv=cv; bestc=2^log2c;
    end
    fprintf('2: %g %g (best c=%g, rate=%g)\n',log2c,cv,bestc,bestcv);
end