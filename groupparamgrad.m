function grad=groupparamgrad(labelv,datav,outputv,modelstruct,theta,A,B,group)
%output grad for row gammas

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if size(group,2)~=size(datav,2)
    error('group index does not have same elements as feature\n');
end

n_group=length(unique(group));
if n_group~=size(theta,2)-1
    error('number of group does not match number of params\n');
end
if n_group ~= max(group)
    error('group id should start from 1 and be continues\n');
end

gt=zeros(size(group));
for i=1:n_group
    gt(group==i)=theta(i+1);
end
gt=sqrt(2.^gt);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

C=2^theta(1);
kparams=2.^theta(2:end);
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
fprintf('number of SV:%d, bounded:%d\n',K,Nc);
%fprintf('largest unbounded coef:%g, model trained with C=%g\n',max(alphau),C);
if Nu==0
    return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%
%gradient of output
%%%%%%%%%%%%%%%%%%%%%%%%%

delta=svmoutputgrad(labelv,outputv,A,B);

%%%%%%%%%%%%%%%%%%%%%%%%%
% if Nu==0, calculate grad directly
%%%%%%%%%%%%%%%%%%%%%%%%%%
% if Nu==0
%     Dlk=crossdist(datav,SVs,gt);
%     Psi=repmat(Y',N,1).*exp(-Dlk);
%     grad(1)=delta'*(Psi*ones(K,1))*log(2)*C;
%     
%     for r=1:n_group
%         gtr=zeros(size(group));
%         gtr(group==r)=1;
%         Dlksub=crossdist(datav,SVs,gtr);
%         Psipk=-Psi.*Dlksub*log(2)*kparams(r);
%         grad(r+1)=delta'*(Psipk*C*ones(K,1));
%     end
%     grad=-grad;
%     return;
% end


%%%%%%%%%%%%%
%calc d
%%%%%%%%%%%%%
tic;
Dlk=crossdist(datav,SVs,gt);
Psi=zeros(N,K+1);
Psi(:,1:K)=repmat(Y',N,1).*exp(-Dlk);
Psi(:,K+1)=-ones(N,1);
Md=(delta'*Psi)';

Mk=zeros(K+1,n_group); %sum(delta*(Psi grad with kernel param))
for r=1:n_group
    Psipk=zeros(N,K+1);
    gtr=zeros(size(group));
    gtr(group==r)=1;
    Dlksub=crossdist(datav,SVs,gtr);    
    Psipk(:,1:K)=-Psi(:,1:K).*Dlksub*log(2)*kparams(r);
    Mk(:,r)=(delta'*Psipk)';
end    
t=toc;
fprintf('Md and Mk calculated in %d seconds.\n',t);

P=zeros(K+1,K+1);
P(1:Nc,1:Nc)=eye(Nc);

tic;
Omegauu=crossdist(SVsu,SVsu,gt);
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

tic;
Omegauc=crossdist(SVsu,SVsc,gt);
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
for r=1:n_group
    gtr=zeros(size(group));
    gtr(group==r)=1;
    
    %%%%%%%%%%%
    % grad of q with g
    %%%%%%%%%%%%%
    qpg=zeros(K+1,1);
    Duc=crossdist(SVsu,SVsc,gtr);    
    Omegaucpg=-Omegauc.*Duc*log(2)*kparams(r);
    qpg(Nc+1:K)=-Omegaucpg*alphac;
    
    %%%%%%%%%%
    %grad of P with g
    %%%%%%%%%%%
    Ppg=zeros(K+1,K+1);
    Duu=crossdist(SVsu,SVsu,gtr);    
    Omegauupg=-Omegauu.*Duu*log(2)*kparams(r);
    Ppg(Nc+1:K,Nc+1:K)=Omegauupg;
    grad(r+1)=d'*(qpg-Ppg*beta)+Mk(:,r)'*beta;
end
t=toc;
fprintf('grad of kernel params calculated in %d sec\n',t);

grad=-grad;

