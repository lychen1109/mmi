function resultparser(thetaa,historya)
%print learned result from looped paramlearn

N=size(thetaa,1);
for i=1:N
    theta=thetaa(i,:);
    history=historya(i);
    ofuns=history.ofuns;
    iters=size(ofuns,1);
    deltaofun=(ofuns(end)-ofuns(end-1))/abs(ofuns(end));
    if deltaofun>0
        bestofun=ofuns(end);
    else
        bestofun=ofuns(end-1);
    end
    fprintf('split %d: ',i);
    fprintf('%g  ',theta);
    fprintf('\n');
    fprintf('learned in %d iters, with ofun %g, exit delta %g\n',iters,bestofun,deltaofun);
end
