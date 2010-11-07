%this script is used for sequential feature selection using SVM
[~,historyCV]=sequentialfs(@mysvm,dataTrain,grpTrain,'cv',fivefoldCVP,'NFeatures',48,'Options',opts);