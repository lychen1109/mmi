function [grad,Like]=paramgrad(labelv,datav,outputv,model,theta)
%Paramlearn: calculate gradient of parameter

log2C=theta(1);
log2g=theta(2);
A=theta(3);
B=theta(4);
grad=zeros(4,1);

C=2^log2C;
sv_coef=model.sv_coef;
SVs=model.SVs;
SVs1=SVs(sv_coef>C-eps,:); %positive bounded SVs
SVs2=SVs(sv_coef<-C+eps,:); %negative bounded SVs
SVs3=SVs(sv_coef>0 & sv_coef<C-eps,:); %positive free SVs
SVs4=SVs(sv_coef<0 & sv_coef>-C+eps,:); %negative free SVs
alpha1=sv_coef(sv_coef>C-eps);
alpha2=abs(sv_coef(sv_coef<-C+eps));
alpha3=sv_coef(sv_coef>0 & sv_coef<C-eps);
alpha4=abs(sv_coef(sv_coef<0 & sv_coef>-C+eps));
alphac=[alpha1;alpha2];
alphau=[alpha3;alpha4];
beta=[alphac;alphau;model.rho];
SVs=[SVs1;SVs2;SVs3;SVs4];%reorganized for easy calculation
SVsu=[SVs3;SVs4]; %free support vectors
SVsc=[SVs1;SVs2]; %bounded SVs
Y=[ones(size(SVs1,1),1);-ones(size(SVs2,1),1);ones(size(SVs3,1),1);-ones(size(SVs4,1),1)]; %label of SVs
Yu=[ones(size(SVs3,1),1);-ones(size(SVs4,1),1)];%label of free SVs
Yc=[ones(size(SVs1,1),1);-ones(size(SVs2,1),1)];%label of bounded SVs

N=size(datav,1);%number of validation set
K=size(SVs,1); %number of support vectors
Nc=size(SVs1,1)+size(SVs2,1); %number bounded SVs
Nu=size(SVs3,1)+size(SVs4,1);%number unbounded SVs
fprintf('number of SV:%d, bounded:%d, free:%d\n',K,Nc,Nu);
M1=zeros(K+1,1);%temp variable used in d calc
M2=zeros(K+1,1);%temp variable used in full gradient calc
outputvp=outputv(labelv==1);
outputvn=outputv(labelv==0);
delta=zeros(N,1);%gradient of objective function with output
delta(labelv==1)=-A*exp(A.*outputvp+B)./(1+exp(A.*outputvp+B));
delta(labelv==0)=A*exp(-A.*outputvn-B)./(1+exp(-A*outputvn-B));

tic;
for l=1:N    
    datavl=datav(l,:);
    Psi=ones(K+1,1);
    Psipg=zeros(K+1,1);
    parfor k=1:K
        Dnk=norm(datavl-SVs(k,:))^2;
        Psi(k)=Y(k)*exp(-Dnk);
        Psipg(k)=-Psi(k)*Dnk*log(2)*2^log2g;
    end
    M1=M1+delta(l)*Psi;
    M2=M2+delta(l)*Psipg;
end
t=toc;
fprintf('M1 and M2 for d and full grad calculated in %g seconds.\n',t);

P=zeros(K+1,K+1);
P(1:Nc,1:Nc)=eye(Nc);
Omegauu=zeros(Nu,Nu);
Duu=zeros(Nu,Nu);

tic;
for i=1:Nu
    for j=1:Nu
        Duu(i,j)=norm(SVsu(i,:)-SVsu(j,:))^2;
        Omegauu(i,j)=Yu(i)*Yu(j)*exp(-Duu(i,j));
    end
end
t=toc;
fprintf('Omegauu calculated in %g seconds.\n',t);

P(Nc+1:K,Nc+1:K)=Omegauu;
P(Nc+1:K,K+1)=-Yu;
P(K+1,Nc+1:K)=-Yu';
%tic;
d=P'\M1;
%t=toc;
%fprintf('mldivide for d calculated in %g seconds.\n',t);

qpC=zeros(K+1,1); %q gradient with C
qpC(1:Nc)=ones(Nc,1)*log(2)*C;
Omegauc=zeros(Nu,Nc);
Duc=zeros(Nu,Nc);

tic;
for i=1:Nu
    for j=1:Nc
        Duc(i,j)=norm(SVsu(i,:)-SVsc(j,:))^2;
        Omegauc(i,j)=Yu(i)*Yc(j)*exp(-Duc(i,j));
    end
end
t=toc;
fprintf('Omegauc calculated in %g seconds.\n',t);

qpC(Nc+1:K)=-Omegauc*ones(Nc,1)*log(2)*C;
qpC(K+1)=Yc'*ones(Nc,1)*log(2)*C;
grad(1)=d'*qpC;

%%%%%%%%%%%%%%%%%%%%%%%%
%calc gradient of g
%%%%%%%%%%%%%%%%%%%%%%%%

qpg=zeros(K+1,1);
Omegaucpg=zeros(Nu,Nc);

tic;
for i=1:Nu
    for j=1:Nc
        Omegaucpg(i,j)=-Omegauc(i,j)*Duc(i,j)*log(2)*2^log2g;
    end
end
t=toc;
fprintf('Omegaucpg calculated in %g seconds.\n',t);

qpg(Nc+1:K)=-Omegaucpg*alphac;
Ppg=zeros(K+1,K+1);
Omegauupg=zeros(Nu,Nu);

tic;
for i=1:Nu
    for j=1:Nu
        Omegauupg(i,j)=-Omegauu(i,j)*Duu(i,j)*log(2)*2^log2g;
    end
end
t=toc;
fprintf('Omegauupg calculated in %g seconds.\n',t);
Ppg(Nc+1:K,Nc+1:K)=Omegauupg;
grad(2)=d'*(qpg-Ppg*beta)+M2'*beta;

%%%%%%%%%%%%%%%%%%%%%%%%%%
%calc gradient of A and B
%%%%%%%%%%%%%%%%%%%%%%%%%%

LpA1=-outputvp.*exp(A*outputvp+B)./(1+exp(A*outputvp+B)); %gradient of L with A of positive samples
LpA2=outputvn.*exp(-A*outputvn-B)./(1+exp(-A*outputvn-B)); %gradient of L with A of negative samples
LpB1=-exp(A*outputvp+B)./(1+exp(A*outputvp+B));
LpB2=exp(-A*outputvn-B)./(1+exp(-A*outputvn-B));
grad(3)=sum(LpA1)+sum(LpA2);
grad(4)=sum(LpB1)+sum(LpB2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%calc objective function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Like1=log(1./(1+exp(A*outputvp+B)));
Like2=log(1-1./(1+exp(A*outputvn+B)));
Like=sum(Like1)+sum(Like2);







