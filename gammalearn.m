function log2g=gammalearn(labeltrain,datatrain,log2c,log2g,Tol)
%learn the best gamma from training data

Eta=0.01;
%hold out validation set
n_vali=400;
validationcvp=cvpartition(labeltrain,'holdout',n_vali);
int_datatrain=datatrain(validationcvp.training,:);
int_labeltrain=labeltrain(validationcvp.training);
int_datatest=datatrain(validationcvp.test,:);
int_labeltest=labeltrain(validationcvp.test);

%train once get E_old
svmcmd=['-c ' num2str(2^log2c) ' -g ' num2str(2^log2g) ' -b 1'];
model=svmtrain(int_labeltrain,int_datatrain,svmcmd);
[~,~,P]=svmpredict(int_labeltest,int_datatest,model,'-b 1');
E=zeros(n_vali,1);
E(int_labeltest==1)=1-P(int_labeltest==1,1);
E(int_labeltest==0)=P(int_labeltest==0,1);
E_old=sum(E)/n_vali;
fprintf('E init=%g\n',E_old);
E_delt=10^4;

while E_delt>Tol
    SVs=model.SVs;
    n_Sv=size(SVs,1);
    sv_coef=model.sv_coef;
    ProbA=model.ProbA;
    Ei_pp=ones(n_vali,1);
    Ei_pp(int_labeltest==1)=-1;
    Pi_pf=-ProbA.*P(:,1).*(1-P(:,1));
    
    fi_ptheta=zeros(n_vali,1);
    d_xi_svj=zeros(n_vali,n_Sv);
    for i=1:n_vali        
        xi=int_datatest(i,:);
        fi_pthetai=0;
        drow=zeros(1,n_Sv);
        parfor j=1:n_Sv
            dij=sum((xi-SVs(j,:)).^2);
            drow(j)=dij;
            fi_pthetai=fi_pthetai+sv_coef(j)*(-dij)*exp(-(2^log2g)*dij)*log(2)*(2^log2g);
        end
        d_xi_svj(i,:)=drow;
        fi_ptheta(i)=fi_pthetai;
    end
    E_ptheta=sum(Ei_pp.*Pi_pf.*fi_ptheta);
    
    E_palpha=zeros(1,n_Sv+1);
    for j=1:n_Sv+1
        if j<n_Sv+1
            fi_palphaj=zeros(n_vali,1);
            yj=sign(sv_coef(j));
            dcol=d_xi_svj(:,j);
            parfor i=1:n_vali
                fi_palphaj(i)=yj*exp(-(2^log2g)*dcol(i));
            end
        else
            fi_palphaj=ones(n_vali,1);
        end
        E_palpha(j)=sum(Ei_pp.*Pi_pf.*fi_palphaj);
    end
    
    Y=sign(sv_coef);
    K_y=zeros(n_Sv,n_Sv);
    H=zeros(n_Sv+1,n_Sv+1);
    H_ptheta=zeros(n_Sv+1,n_Sv+1);
    for i=1:n_Sv
        svi=SVs(i,:);
        coefi=sv_coef(i);
        K_yrow=zeros(1,n_Sv);
        H_pthetarow=zeros(1,n_Sv+1);
        parfor j=1:n_Sv
            d_svi_svj=sum((svi-SVs(j,:)).^2);
            K_yrow(j)=sign(coefi*sv_coef(j))*exp(-(2^log2g)*d_svi_svj);
            H_pthetarow(j)=sign(coefi*sv_coef(j))*(-d_svi_svj)*exp(-(2^log2g)*d_svi_svj)*log(2)*(2^log2g);
        end
        K_y(i,:)=K_yrow;
        H_ptheta(i,:)=H_pthetarow;
    end    
    H(1:n_Sv,1:n_Sv)=K_y;
    H(1:n_Sv,n_Sv+1)=Y;
    H(n_Sv+1,1:n_Sv)=Y';    
    Alpha_ptheta=-inv(H)*H_ptheta*[abs(sv_coef);-model.rho];
    
    E_ptheta_final=E_ptheta+E_palpha*Alpha_ptheta;
    log2g=log2g-Eta*E_ptheta_final;
    fprintf('log2g=%g\n',log2g);
    
    %train svm
    svmcmd=['-c ' num2str(2^log2c) ' -g ' num2str(2^log2g) ' -b 1'];
    model=svmtrain(int_labeltrain,int_datatrain,svmcmd);
    [~,~,P]=svmpredict(int_labeltest,int_datatest,model,'-b 1');
    E=zeros(n_vali,1);
    E(int_labeltest==1)=1-P(int_labeltest==1,1);
    E(int_labeltest==0)=P(int_labeltest==0,1);
    E_new=sum(E)/n_vali;
    E_delta=E_new-E_old;
    fprintf('E new=%g, E_delta=%g\n',E_new,E_delta);
    E_old=E_new;
end

    
    
    
    