function grad=fullparamgrad(labelv,datav,outputv,modelstruct,theta)
%gradient calculation of full rbf kernel

C=2^theta(1);
kparams=2.^theta(2:82);
A=theta(end-1);
B=theta(end);
grad=zeros(1,length(theta));

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

%%%%%%%%%%%%%
%calc d
%%%%%%%%%%%%%
Md=zeros(K+1,1); %sum(delta*Psi)
Mk=zeros(K+1,81); %sum(delta*(Psi grad with kernel param))

tic;
for l=1:N
    Psi=-ones(K+1,1);
    Psipk=zeros(K+1,81);
    Dlk=zeros(1,K);
    for k=1:K
        Dlk(k)=fullrbfdist(datav(l,:),SVs(k,:),theta);
    end
    Psi(1:K)=Y.*Dlk';
    Md=Md+delta(l)*Psi;
    Psipk(1:K,:)=SVs-repmat(datav(l,:),K,1);
    Psipk(1:K,:)=-repmat(Psi(1:K),1,81).*Psipk(1:K,:).^2.*log(2).*repmat(kparams,K,1);
    Mk=Mk+delta(l)*Psipk;
end
t=toc;
fprintf('Md and Mk calculated in %d seconds.\n',t);

P=zeros(K+1,K+1);
P(1:Nc,1:Nc)=eye(Nc);
Omegauu=zeros(Nu,Nu);

tic;
for i=1:Nu
    for j=1:Nu
        Omegauu(i,j)=fullrbfdist(SVsu(i,:),SVsu(j,:),theta);
    end
end
Omegauu=Yu*Yu'.*exp(-Omegauu);
t=toc;
fprintf('Omegauu calculated in %d sec\n',t);

P(Nc+1:K,Nc+1:K)=Omegauu;
P(Nc+1:K,K+1)=-Yu;
P(K+1,Nc+1:K)=-Yu';
d=P'\Md;

%%%%%%%%%%%%%%%%%%%%%%
% grad of C
%%%%%%%%%%%%%%%%%%%%%%

qpC=zeros(K+1,1); %q gradient with C
qpC(1:Nc)=ones(Nc,1)*log(2)*C;
Omegauc=zeros(Nu,Nc);

tic;
for i=1:Nu
    for j=1:Nc
        Omegauc(i,j)=fullrbfdist(SVsu(i,:),SVsc(j,:),theta);
    end
end
Omegauc=Yu*Yc'.*exp(-Omegauc);
t=toc;
fprintf('Omegauc calculated in %d sec\n',t);

qpC(Nc+1:K)=-Omegauc*ones(Nc,1)*log(2)*C;
qpC(K+1)=Yc'*ones(Nc,1)*log(2)*C;
grad(1)=d'*qpC;

%%%%%%%%%%%%%%%%%%%%%%%
%grad of kparams
%%%%%%%%%%%%%%%%%%%%%%%
tic;
for r=1:81
    
    %%%%%%%%%%%
    % grad of q with g
    %%%%%%%%%%%%%
    qpg=zeros(K+1,1);
    Omegaucpg=zeros(Nu,Nc);
    for i=1:Nu
        for j=1:Nc
            Omegaucpg(i,j)=SVsu(i,r)-SVsc(j,r);
        end
    end
    Omegaucpg=-Omegauc.*Omegaucpg.^2.*log(2).*kparams(r);
    qpg(Nc+1:K)=-Omegaucpg*alphac;
    
    %%%%%%%%%%
    %grad of P with g
    %%%%%%%%%%%
    Ppg=zeros(K+1,K+1);
    Omegauupg=zeros(Nu,Nu);
    for i=1:Nu
        for j=1:Nu
            Omegauupg=SVsu(i,r)-SVsu(j,r);
        end
    end
    Omegauupg=-Omegauu.*Omegauupg.^2.*log(2).*kparams(r);
    Ppg(Nc+1:K,Nc+1:K)=Omegauupg;
    grad(r+1)=d'*(qpg-Ppg*beta)+Mk(:,r)'*beta;
end
t=toc;
fprintf('grad of kernel params calculated in %d sec\n',t);

%%%%%%%%%%%%%%%%%%%%%%%%%%
%calc gradient of A and B
%%%%%%%%%%%%%%%%%%%%%%%%%%
[grad(end-1),grad(end)]=svmlogistgrad(labelv,outputv,A,B);



            
        
        
        
        
        
        
        
        