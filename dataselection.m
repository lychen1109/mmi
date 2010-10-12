function autrain=dataselection(audata,selection)
%checkout training data

autrain=[];
for i=selection
    imgs=audata{i};
    autrain=[autrain;imgs];
end
