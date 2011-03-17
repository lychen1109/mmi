function modelstruct=rowmodelparse(model,datatrain,C)
%return model params in a struct

svidx=full(model.SVs);
SVs=datatrain(svidx,:);
sv_coef=model.sv_coef;
Y=sign(sv_coef);
idxc=abs(sv_coef)==C;
idxu=abs(sv_coef)<C;
alphac=abs(sv_coef(idxc));
alphau=abs(sv_coef(idxu));
Yc=sign(sv_coef(idxc));
Yu=sign(sv_coef(idxu));
SVsu=SVs(idxu,:);
SVsc=SVs(idxc,:);
rho=model.rho;

modelstruct.SVs=SVs;
modelstruct.SVsu=SVsu;
modelstruct.SVsc=SVsc;
modelstruct.Y=Y;
modelstruct.Yc=Yc;
modelstruct.Yu=Yu;
modelstruct.alphau=alphau;
modelstruct.alphac=alphac;
modelstruct.rho=rho;