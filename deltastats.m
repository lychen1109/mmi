function stat=deltastats(transmat,label,group_idx)
%check the effective of combine 1 new bin

level=2;%check combine level, at most 2 exist feature plug 1 new
sigma=0.5;

%select 100 or 1/5 of total bins
totalbins=find(group_idx==0);
NUMBIN=length(totalbins);
poll=myrandint(NUMBIN,1,1:5);
selectedbin=totalbins(poll==1);
stat=zeros(length(selectedbin),2,level);

for i=1:2% length(selectedbin)
   currentgroup=selectedbin(i);
   for l=1:level
       fprintf('random bin %d, level %d\n',i,l);
       currentfeature=group_feature_extract(currentgroup,transmat);
       if size(currentfeature,2)==1
           y=currentfeature;
       else
           y=currentfeature*lda(label,currentfeature);
       end
       Icur=mymi3(label,1,y,sigma,0);
       candidates=adjpoints(currentgroup,group_idx);
       
       if isempty(candidates)           
           stat(i,1:2,l)=NaN;
           break;
       end
       randidx=myrandint(1,1,1:length(candidates));
       newfeature=group_feature_extract(candidates(randidx),transmat);
       newfeature=[currentfeature newfeature];
       y=newfeature*lda(label,newfeature);
       Inew=mymi3(label,1,y,sigma,0);
       stat(i,1,l)=Inew-Icur;
       stat(i,2,l)=(Inew-Icur)/Icur;
       currentgroup=[currentgroup candidates(randidx)];
   end   
end