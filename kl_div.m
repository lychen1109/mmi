function KL=kl_div(p,q,type)
%calculate kl divergense of two probability distribution
%if there's zero element in vector, will add eps to the vector

tol=1e-5;

if ~isequal(size(p),size(q))
    error('input vectors must have same size.');
end

if (abs(sum(q)-1)>tol) || (abs(sum(p)-1)>tol)
    erros('probability does not sum up to 1');
end

if ~isempty(find(p==0,1))
    p=p+eps;
end
if ~isempty(find(q==0,1))
    q=q+eps;
end

switch type
    case 'js'
        logQ=log2((p+q)/2);
        KL=0.5*(sum(p.*(log2(p)-logQ))+sum(q.*(log2(q)-logQ)));
    case 'sym'
        KL1=sum(p.*(log2(p)-log2(q)));
        KL2=sum(q.*(log2(q)-log2(p)));
        KL=0.5*(KL1+KL2);
    otherwise
        error('no such type');
end
