function gmmpdftest(gm,feat)
%test performance of gmm pdf calc

N=100;
t=0;
for i=1:N
   tic;
   pdf(gm,feat(i,:));
   t=t+toc;
end
fprintf('use pdf function, t=%g\n',t);

for i=1:N
    tic;
    gmmpdf(gm,feat(i,:));
    t=t+toc;
end
fprintf('self pdf function, t=%g\n',t);

