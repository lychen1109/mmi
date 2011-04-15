function grad=paramgrad(labelv,datav,outputv,modelstruct,theta,A,B)
%Paramlearn: calculate gradient of parameter

log2C=theta(1);
C=2^log2C;
log2g=theta(2);
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
fprintf('number of SV:%d, bounded:%d\n',K,Nc);
if Nu==0
    return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%
%gradient of output
%%%%%%%%%%%%%%%%%%%%%%%%%

delta=svmoutputgrad(labelv,outputv,A,B);

%%%%%%%%%%%%%%%%%%%%%%%%
% when Nu==0
%%%%%%%%%%%%%%%%%%%%%%%

% if Nu==0
% %     Dlk=crossdist(datav,SVs);    
% %     Psi=repmat(Y',N,1).*exp(-Dlk);
% %     grad(1)=delta'*(Psi*ones(K,1))*log(2)*C;
% %     
% %     Psipg=-Psi.*Dlk*log(2)*2^log2g;
% %     grad(2)=delta'*(Psipg*C*ones(K,1));
% %     grad=-grad;
%     grad=0;
%     return;
% end

%%%%%%%%%%%%%%%%
% calc d
%%%%%%%%%%%%%%%%

tic;
Dnk=crossdist(datav,SVs);
Psi=zeros(N,K+1);
Psipg=zeros(N,K+1);
Psi(:,1:K)=repmat(Y',N,1).*exp(-2^log2g*Dnk);
Psi(:,K+1)=-ones(N,1);
Psipg(:,1:K)=-Psi(:,1:K).*Dnk*log(2)*2^log2g;
M1=(delta'*Psi)'; %temp variable used in d calc
M2=(delta'*Psipg)'; %temp variable used in full gradient calc       
t=toc;
fprintf('M1 and M2 for d and full grad calculated in %g seconds.\n',t);

P=zeros(K+1,K+1);
P(1:Nc,1:Nc)=eye(Nc);

tic;
Duu=crossdist(SVsu,SVsu);
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
grad=-grad;









