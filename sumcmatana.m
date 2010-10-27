function sumcmatana(sumcmat)
%printf percentage of points in according center area

ALL=128*126*1441;
for T=3:50
    center=sumcmat(256+(-T:T),256+(-T:T));
    num=sum(center(:));
    fprintf('T=%d, percent=%f\n',T,num/ALL);
end
