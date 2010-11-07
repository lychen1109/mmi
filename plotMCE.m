%the script is to plot misclassification error regarding feature number
testMCE=zeros(1,42);
nfs=1:42;
for i=1:42
    fs=featureIdxSortedByP(1:nfs(i));
    testMCE(i)=crossval('mcr',obsfr(:,fs),label,'Predfun',@classf,'partition',holdoutCVP);
end
plot(nfs,testMCE,'o');
xlabel('Number of features');
ylabel('Misclassification error');