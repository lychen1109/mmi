function [w,fval]=wmmi(train_label,x)
%calculate w by maximize the mutual information

w0=randn(1,size(x,2)); w0=w0/norm(w0);
options=optimset('Display','iter','GradObj','on','LargeScale','off','DerivativeCheck','off');
[w,fval]=fmincon(@myfun,w0,[],[],[],[],[],[],@mycon,options);

    function [I,g]=myfun(w)
        sigma=mmi_sigma(x*w');        
        I=-mymi(train_label,x*w',sigma);        
        g=mymi_grad(train_label,w,x,sigma);
    end

    function [c,ceq]=mycon(w)
        c=[];
        ceq(1)=norm(w)-1;
    end
end