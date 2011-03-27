function grad=paramgrad(labelv,datav,outputv,modelstruct,theta,A,B)
%Paramlearn: calculate gradient of parameter

log2C=theta(1);
C=2^log2C;
log2g=theta(2);
grad=zeros(1,length(theta));

%sv_coef=model.sv_coef;
%SVs=model.SVs;
% SVs1=SVs(sv_coef>C-eps,:); %positive bounded SVs
% SVs2=SVs(sv_coef<-C+eps,:); %negative bounded SVs
% SVs3=SVs(sv_coef>0 & sv_coef<C-eps,:); %positive free SVs
% SVs4=SVs(sv_coef<0 & sv_coef>-C+eps,:); %negative free SVs
% alpha1=sv_coef(sv_coef>C-eps);
% alpha2=abs(sv_coef(sv_coef<-C+eps));
% alpha3=sv_coef(sv_coef>0 & sv_coef<C-eps);
% alpha4=abs(sv_coef(sv_coef<0 & sv_coef>-C+eps));
% alphac=[alpha1;alpha2];
% alphau=[alpha3;alpha4];
% SVs=[SVs1;SVs2;SVs3;SVs4];%reorganized for easy calculation
% SVsu=[SVs3;SVs4]; %free support vectors
% SVsc=[SVs1;SVs2]; %bounded SVs
% Y=[ones(size(SVs1,1),1);-ones(size(SVs2,1),1);ones(size(SVs3,1),1);-ones(size(SVs4,1),1)]; %label of SVs
% Yu=[ones(size(SVs3,1),1);-ones(size(SVs4,1),1)];%label of free SVs
% Yc=[ones(size(SVs1,1),1);-ones(size(SVs2,1),1)];%label of bounded SVs
%[SVs,SVsu,SVsc,Y,Yu,Yc,alphac,alphau]=modelparse(model,C);
SVs=modelstruct.SVs;
SVsu=modelstruct.SVsu;
SVsc=modelstruct.SVsc;
Y=modelstruct.Y;
Yu=modelstruct.Yu;
Yc=modelstruct.Yc;
alphac=modelstruct.alphac;
alphau=modelstruct.alphau;
rho=modelstruct.rho;
beta=[alphac;alphau;rho];

N=size(datav,1);%number of validation set
K=size(SVs,1); %number of support vectors
Nc=length(Yc); %number bounded SVs
Nu=length(Yu);%number unbounded SVs
fprintf('number of SV:%d, bounded:%d, free:%d\n',K,Nc,Nu);
fprintf('largest unbounded coef:%g, model trained with C=%g\n',max(alphau),C);

%%%%%%%%%%%%%%%%%%%%%%%%%
%gradient of output
%%%%%%%%%%%%%%%%%%%%%%%%%

delta=svmoutputgrad(labelv,outputv,A,B);

%%%%%%%%%%%%%%%%
% calc d
%%%%%%%%%%%%%%%%

tic;
Dnk=zeros(N,K);
Psi=zeros(N,K+1);
Psipg=zeros(N,K+1);
for l=1:N
    for k=1:K
        Dnk(l,k)=norm(datav(l,:)-SVs(k,:))^2;
    end
end
Psi(:,1:K)=repmat(Y',N,1).*exp(-2^log2g*Dnk);
Psi(:,K+1)=-ones(N,1);
Psipg(:,1:K)=-Psi(:,1:K).*Dnk*log(2)*2^log2g;
M1=sum(repmat(delta,1,K+1).*Psi)'; %temp variable used in d calc
M2=sum(repmat(delta,1,K+1).*Psipg)'; %temp variable used in full gradient calc       
t=toc;
fprintf('M1 and M2 for d and full grad calculated in %g seconds.\n',t);

P=zeros(K+1,K+1);
P(1:Nc,1:Nc)=eye(Nc);
Duu=zeros(Nu,Nu);

tic;
for i=1:Nu    
    for j=1:Nu
        Duu(i,j)=norm(SVsu(i,:)-SVsu(j,:))^2;        
    end    
end
Omegauu=Yu*Yu'.*exp(-2^log2g*Duu);
t=toc;
fprintf('Omegauu calculated in %g seconds.\n',t);

P(Nc+1:K,Nc+1:K)=Omegauu;
P(Nc+1:K,K+1)=-Yu;
P(K+1,Nc+1:K)=-Yu';
%tic;
d=P'\M1;
%t=toc;
%fprintf('mldivide for d calculated in %g seconds.\n',t);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%gradient of C
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
qpC=zeros(K+1,1); %q gradient with C
qpC(1:Nc)=ones(Nc,1)*log(2)*C;
Duc=zeros(Nu,Nc);

tic;
for i=1:Nu
    for j=1:Nc
        Duc(i,j)=norm(SVsu(i,:)-SVsc(j,:))^2;        
    end
end
Omegauc=Yu*Yc'.*exp(-2^log2g*Duc);
t=toc;
fprintf('Omegauc calculated in %g seconds.\n',t);

qpC(Nc+1:K)=-Omegauc*ones(Nc,1)*log(2)*C;
qpC(K+1)=Yc'*ones(Nc,1)*log(2)*C;
grad(1)=d'*qpC;

%%%%%%%%%%%%%%%%%%%%%%%%
%calc gradient of g
%%%%%%%%%%%%%%%%%%%%%%%%

qpg=zeros(K+1,1);
Omegaucpg=-Omegauc.*Duc*log(2)*2^log2g;
qpg(Nc+1:K)=-Omegaucpg*alphac;

Ppg=zeros(K+1,K+1);
Omegauupg=-Omegauu.*Duu*log(2)*2^log2g;
Ppg(Nc+1:K,Nc+1:K)=Omegauupg;
grad(2)=d'*(qpg-Ppg*beta)+M2'*beta;

%%%%%%%%%%%%%%%%%%%%%%%%%%
%calc gradient of A and B
%%%%%%%%%%%%%%%%%%%%%%%%%%
%[grad(3),grad(4)]=svmlogistgrad(labelv,outputv,A,B);









