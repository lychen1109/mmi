function rand_w_check(train_label,x,sigma)
%check random w and MI

N=10;%check 10 random value
for i=1:N
    w=randn(1,4);
    w=w/norm(w);
    fprintf('w=(%f,%f,%f,%f), ',w(1),w(2),w(3),w(4));
    I=mymi2(train_label,x*w',sigma);
    fprintf('MI=%f\n',I);
end