function results=diststat(output)
%check image modification effect

distarrays=output.distarrays;
distarray1s=output.distarray1s;
distarray2s=output.distarray2s;
results=zeros(length(distarrays),3);
for i=1:length(distarrays)
    dist=distarrays{i};
    dist1=distarray1s{i};
    dist2=distarray2s{i};
    results(i,1)=dist(end)/dist(1);
    results(i,2)=dist1(end)/dist1(1);
    results(i,3)=dist2(end)/dist2(1);
end

