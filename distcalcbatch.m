function distvec=distcalcbatch(sptpm,targettpm)
%calculate dist of spimage and itstarget image in feature space

N=size(sptpm,1);
distvec=zeros(N,1);
for i=1:N
    distvec(i)=norm(sptpm(i,:)-targettpm(i,:));
end
