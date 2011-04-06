function grad=rowparamgrad(labelv,datav,outputv,modelstruct,theta,A,B,svmoutputgrad)
%output grad for row gammas

C=2^theta(1);
kparams=2.^theta(2:10);
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
Dlk=zeros(N,K);
Psi=zeros(N,K+1);

tic;
for l=1:N    
    for k=1:K
        Dlk(l,k)=rowrbfdist(datav(l,:),SVs(k,:),theta);
    end      
end
Psi(:,1:K)=repmat(Y',N,1).*exp(-Dlk);
Psi(:,K+1)=-ones(N,1);
Md=(delta'*Psi)';

Mk=zeros(K+1,9); %sum(delta*(Psi grad with kernel param))
for r=1:9
    Psipk=zeros(N,K+1);
    Dlksub=zeros(N,K);
    for l=1:N
        for k=1:K
            datavl=datav(l,:);
            SVsk=SVs(k,:);
            ri=rowidx(r);
            Dlksub(l,k)=norm(datavl(ri)-SVsk(ri))^2;            
        end
    end
    Psipk(:,1:K)=-Psi.*Dlksub*log(2)*kparams(r);
    Mk(:,r)=(delta'*Psipk)';
end    
t=toc;
fprintf('Md and Mk calculated in %d seconds.\n',t);

P=zeros(K+1,K+1);
P(1:Nc,1:Nc)=eye(Nc);
Omegauu=zeros(Nu,Nu);

tic;
if Nu>1
    for i=1:Nu-1
        for j=i+1:Nu
            Omegauu(i,j)=rowrbfdist(SVsu(i,:),SVsu(j,:),theta);
        end
    end
    Omegauu=Omegauu+Omegauu';
    Omegauu=Yu*Yu'.*exp(-Omegauu);
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
        Omegauc(i,j)=rowrbfdist(SVsu(i,:),SVsc(j,:),theta);
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
for r=1:9
    ri=rowidx(r);
    
    %%%%%%%%%%%
    % grad of q with g
    %%%%%%%%%%%%%
    qpg=zeros(K+1,1);
    Duc=zeros(Nu,Nc);
    for i=1:Nu
        for j=1:Nc
            SVsui=SVsu(i,:);
            SVscj=SVsc(j,:);            
            Duc(i,j)=norm(SVsui(ri)-SVscj(ri))^2;
        end
    end
    Omegaucpg=-Omegauc.*Duc*log(2)*kparams(r);
    qpg(Nc+1:K)=-Omegaucpg*alphac;
    
    %%%%%%%%%%
    %grad of P with g
    %%%%%%%%%%%
    Ppg=zeros(K+1,K+1);
    Duu=zeros(Nu,Nu);
    for i=1:Nu
        for j=1:Nu
            SVsui=SVsu(i,:);
            SVsuj=SVsu(j,:);
            Duu(i,j)=norm(SVsui(ri)-SVsuj(ri))^2;
        end
    end
    Omegauupg=-Omegauu.*Duu*log(2)*kparams(r);
    Ppg(Nc+1:K,Nc+1:K)=Omegauupg;
    grad(r+1)=d'*(qpg-Ppg*beta)+Mk(:,r)'*beta;
end
t=toc;
fprintf('grad of kernel params calculated in %d sec\n',t);

    

function idx=rowidx(row)
%rowidx of 9x9 features

idx=false(9,9);
idx(row,:)=true(1,9);
