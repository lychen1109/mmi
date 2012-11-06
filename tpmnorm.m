function tm=tpmnorm(tm)
%normalize transition probability matrix

pointsum=sum(sum(tm));
tm=tm/pointsum;

