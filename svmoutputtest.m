function output=svmoutputtest(data,model)
%test calculation of svm output

rho=model.rho;
N=size(data.datavalidate,1);
feat=transmatgen(data.datavalidate,3);
feat=reshape(feat,49,N)';
feat=svmrescale(feat);
gamma=model.Parameters(4);
sv_coef=model.sv_coef;
SVs=model.SVs;
totalSV=model.totalSV;
dout=zeros(N,1);
[~,~,dvalue]=svmpredict(data.labelvalidate,feat,model);
for i=1:N
    for j=1:totalSV
        dout(i)=dout(i)+sv_coef(j)*exp(-gamma*norm(feat(i,:)-SVs(j,:))^2);
    end
end
dout=dout-rho;
output.dvalue=dvalue;
output.dout=dout;