function [p,prefix]=name2path(filename)
%filename to path transform

root='C:\data\ImSpliceDataset\';
lastunderscore=find(filename=='_',1,'last');
prefix=filename(1:lastunderscore-1);
prefix(prefix=='_')='-';
prefix=lower(prefix);
if isequal(prefix,'au-s-h')
    prefix='au-ss-h';
end

p=[root prefix filesep filename];
        