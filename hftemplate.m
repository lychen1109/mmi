function t=hftemplate
%high frequency template

t=ones(8,8);
for i=1:8
    for j=1:8-(i-1)
        t(i,j)=nan;
    end
end
