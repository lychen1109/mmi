function gradx=svmgrad(model,x)
%gradient of SVM

gradx=zeros(size(x));
gamma=model.Parameters(4);
sv_coef=model.sv_coef;
SVs=model.SVs;
totalSV=model.totalSV;
for i=1:length(x)
    for j=1:totalSV
        gradx(i)=gradx(i)+sv_coef(j)*exp(-gamma*norm(x-SVs(j,:))^2)*(x(i)-SVs(j,i));
    end
end
gradx=-2*gamma*gradx;