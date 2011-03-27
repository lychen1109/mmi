function [A,B,fval]=logistreg(labelv,dvalues)
%calculate A and B for logistic regression of SVM output

x0=[-2,0];
opt=optimset('GradObj','on','LargeScale','off');
[x,fval]=fminunc(@myfun,x0,opt);
A=x(1);
B=x(2);

    function [L,g]=myfun(x)
        L=-svmllhood(labelv,dvalues,x(1),x(2));
        if nargout>1
            g=zeros(1,2);
            [g(1),g(2)]=svmlogistgrad(labelv,dvalues,x(1),x(2));
            g=-g;
        end        
    end
end