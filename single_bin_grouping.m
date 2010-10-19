function group_single=single_bin_grouping(bin_mi,autrain,sptrain,label,groupnum)
%check the top 49 relevant bin in 9x9

sigma=0.5;
group_single=zeros(size(bin_mi));
group_single(256+(-4:4),256+(-4:4))=-2;
centralarea=find(group_single==-2);

[~,idx]=sort(bin_mi(centralarea),1,'descend');
group_single(centralarea(idx(1)))=1;
[sx,sy]=ind2sub(size(bin_mi),centralarea(idx(1)));
fprintf('group 1 selected at (%d,%d)\n',sx-256,sy-256);

for i=2:groupnum
    unselected=find(group_single==-2);    
    jointmi=zeros(length(unselected),i-1);
    for k=1:length(unselected)
        for j=1:i-1
            groupbins=find(group_single==j);
            features=group_feature_extract([groupbins' unselected(k)],autrain,sptrain);
            jointmi(k,j)=mymi3(label,eye(size(features,2)),features,sigma);
            fprintf('.');
        end
    end
    fprintf('\n');
    minjointmi=min(jointmi,[],2);
    [~,cidx]=max(minjointmi);
    group_single(unselected(cidx(1)))=i;
    [sx,sy]=ind2sub(size(bin_mi),unselected(cidx(1)));
    fprintf('group %d selected on (%d,%d)\n',i,sx-256,sy-256);
end