function [grad,L]=rowparamgrad(labelv,datav,outputv,modelstruct,theta)
%output grad for row gammas

C=2^theta(1);
kparams=2.^theta(2:10);
A=theta(end-1);
B=theta(end);
grad=zeros(1,length(theta));
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

%%%%%%%%%%%%%
%calc d
%%%%%%%%%%%%%
Md=zeros(K+1,1); %sum(delta*Psi)
Mk=zeros(K+1,9); %sum(delta*(Psi grad with kernel param))

tic;
for l=1:N
    Psi=ones(K+1,1);
    Psipk=zeros(K+1,9);
    Dlk=zeros(1,K); %cache of distance of l validation sample to k SV
    for k=1:K
        Dlk(k)=rowrbfdist(datav(l,:),SVs(k,:),theta);
        Psi(k)=Y(k)*exp(-Dlk(k));
    end
    Md=Md+delta(l)*Psi;
    for r=1:9
        for k=1:K
            datavl=datav(l,:);
            SVsk=SVs(k,:);
            ri=rowidx(r);
            Psipk(k,r)=-Psi(k)*norm(datavl(ri)-SVsk(ri))^2*log(2)*kparams(r);
        end        
    end
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
        Omegauu(i,j)=Yu(i)*Yu(j)*exp(-rowrbfdist(SVsu(i,:),SVsu(j,:),theta));
    end
end
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
        Omegauc(i,j)=Yu(i)*Yc(j)*exp(-rowrbfdist(SVsu(i,:),SVsc(j,:),theta));
    end
end
t=toc;
fprintf('Omegauc calculated in %d sec\n',t);

qpC(Nc+1:K)=-Omegauc*ones(Nc,1)*log(2)*C;
qpC(K+1)=Yc'*ones(Nc,1)*log(2)*C;
grad(1)=d'*qpC;

%%%%%%%%%%%%%%%%%%%%%%%
%grad of kparams
%%%%%%%%%%%%%%%%%%%%%%%
tic;
for r=1:9
    ri=rowidx(r);
    
    %%%%%%%%%%%
    % grad of q with g
    %%%%%%%%%%%%%
    qpg=zeros(K+1,1);
    Omegaucpg=zeros(Nu,Nc);
    for i=1:Nu
        for j=1:Nc
            SVsui=SVsu(i,:);
            SVscj=SVsc(j,:);            
            Omegaucpg(i,j)=-Omegauc(i,j)*norm(SVsui(ri)-SVscj(ri))^2*log(2)*kparams(r);
        end
    end
    qpg(Nc+1:K)=-Omegaucpg*alphac;
    
    %%%%%%%%%%
    %grad of P with g
    %%%%%%%%%%%
    Ppg=zeros(K+1,K+1);
    Omegauupg=zeros(Nu,Nu);
    for i=1:Nu
        for j=1:Nu
            SVsui=SVsu(i,:);
            SVsuj=SVsu(j,:);
            Omegauupg(i,j)=-Omegauu(i,j)*norm(SVsui(ri)-SVsuj(ri))^2*log(2)*kparams(r);
        end
    end
    Ppg(Nc+1:K,Nc+1:K)=Omegauupg;
    grad(r+1)=d'*(qpg-Ppg*beta)+Mk(:,r)'*beta;
end
t=toc;
fprintf('grad of kernel params calculated in %d sec\n',t);

%%%%%%%%%%%%%%%%%%%%%%%%%%
%calc gradient of A and B
%%%%%%%%%%%%%%%%%%%%%%%%%%
[grad(end-1),grad(end)]=svmlogistgrad(labelv,outputv,A,B);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%calc objective function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
L=svmllhood(labelv,outputv,A,B);
    

function idx=rowidx(row)
%rowidx of 9x9 features

idx=false(9,9);
idx(row,:)=true(1,9);
