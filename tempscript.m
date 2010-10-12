function autrain=tempscript(audata)
%checkout training data

autrain=[];
for i=4:9
    imgs=audata{i};
    autrain=[autrain;imgs];
end