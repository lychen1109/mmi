function [group_idx,groupcombine,boundhit,deltas]=wanggrouping(group_idx,bin_mi,transmat,label,MAXDIST)
%grouping with wang's algorithm

grp=0;
groupcombine=0;%record time of group combine
%threshold=2.2e-007;% 60% combine rate according to random sampling
threshold=0.0005;%error decrease
boundhit=0;%record when MAXDIST is reached
%sigma=0.5;
deltas=[];%check the distribution of max delta

while ~isempty(find(group_idx==0,1))
    grp=grp+1;
    fprintf('processing group %d\n',grp);
    unselected=find(group_idx==0);
    [~,maxidx]=max(bin_mi(unselected));
    group_idx(unselected(maxidx))=grp;
    fprintf('start point is %d\n',unselected(maxidx));
    y=group_feature_extract(unselected(maxidx),transmat);
    %Ipre=mymi3(label,1,y,sigma,0);
    [~,Epre]=classify(y,y,label);
    currentgroup=unselected(maxidx);
    candidates=adjpoints(currentgroup,group_idx);    
    while ~isempty(candidates)
        %remove candidates outside of max distance
        removeidx=false(size(candidates));
        for i=1:length(candidates)
            if group_idx(candidates(i))==0
                dist=bin2group(candidates(i),grp,group_idx);
            else
                dist=group2group(group_idx(candidates(i)),grp,group_idx);
            end
            if dist>MAXDIST
                removeidx(i)=true;
            end
        end
        candidates(removeidx==true)=[];
        
        if ~isempty(candidates)
            deltaI=zeros(size(candidates));
            for i=1:length(candidates)
                %fprintf('candidate %d, group mark is %d\n',candidates(i),group_idx(candidates(i)));
                if group_idx(candidates(i))==0
                    x=group_feature_extract([currentgroup(:)' candidates(i)],transmat);
                    %disp('evaluating bins are:');disp([currentgroup(:)' candidates(i)]);
                    y=x*lda(label,x);
                    %disp('w from lda is:');disp(lda(label,x)');
                    %Inew=mymi3(label,1,y,sigma,0);
                    [~,Enew]=classify(y,y,label);
                    deltaI(i)=Epre-Enew;                    
                else
                    oldgroup=find(group_idx==group_idx(candidates(i)));
                    x=group_feature_extract(oldgroup,transmat);
                    if size(x,2)==1
                        [~,Eold]=classify(x,x,label);
                    else
                        y=x*lda(label,x);
                        [~,Eold]=classify(y,y,label);
                    end
                    
                    x=group_feature_extract([currentgroup(:)' oldgroup'],transmat);
                    y=x*lda(label,x);
                    %Inew=mymi3(label,1,y,sigma,0);
                    [~,Enew]=classify(y,y,label);
                    deltaI(i)=min(Epre,Eold)-Enew;
                end
                %fprintf('delta error = %e\n',deltaI(i));
            end
            [maxdelta,maxidx]=max(deltaI(:));
            deltas=[deltas maxdelta];
            if maxdelta>=threshold
                if group_idx(candidates(maxidx))==0
                    group_idx(candidates(maxidx))=grp;
                    fprintf('bin %d is selected.\n',candidates(maxidx));
                else
                    fprintf('group %d combined.\n',group_idx(candidates(maxidx)));
                    group_idx(group_idx==group_idx(candidates(maxidx)))=grp;
                    groupcombine=groupcombine+1;                    
                end                
                currentgroup=find(group_idx==grp);
                x=group_feature_extract(currentgroup,transmat);
                y=x*lda(label,x);
                %Ipre=mymi3(label,1,y,sigma,0);
                [~,Epre]=classify(y,y,label);
                candidates=adjpoints(currentgroup,group_idx);
            else                
                fprintf('no delta is above threshold.\n');
                break;
            end
        else
            fprintf('no candidate is within MAX distance\n');
            boundhit=boundhit+1;
            break;
        end    
    end    
end

%code for testing subfunctions
% singlebin=find(group_idx==3);
% candidategroup=2;
% currentgroup=1;
% dist=bin2group(singlebin,currentgroup,group_idx);
% fprintf('bin2group result is %f\n',dist);
% dist=group2group(candidategroup,currentgroup,group_idx);
% fprintf('group2group result is %f\n',dist);

function dist=bin2group(bin,group,group_idx)
%single bin to group distance
dist=-inf;
points=find(group_idx==group);
[x0,y0]=ind2sub(size(group_idx),bin);
for i=1:length(points)
    [sx,sy]=ind2sub(size(group_idx),points(i));
    dist=max(dist,norm([sx-x0,sy-y0]));
end

function dist=group2group(candidategroup,group,group_idx)
%candidate group to currentgroup distance
dist=-inf;
candidates=find(group_idx==candidategroup);
currentgroup=find(group_idx==group);
for i=1:length(candidates)
    [x0,y0]=ind2sub(size(group_idx),candidates(i));
    for j=1:length(currentgroup)
        [sx,sy]=ind2sub(size(group_idx),currentgroup(j));
        dist=max(dist,norm([sx-x0,sy-y0]));
    end
end
