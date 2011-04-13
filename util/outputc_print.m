function outputc_print( outputc )
%print info in output cell
%   Detailed explanation goes here

N=length(outputc);
for i=1:N
    output=outputc{i};
    iter=output.iterations;
    fc=output.funcCount;
    %step=output.stepsize;
    %grad=output.firstorderopt;
    fprintf('%d\t%d\n',iter,fc);
end

