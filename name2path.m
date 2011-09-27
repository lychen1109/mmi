function [p,prefix]=name2path(filename,varargin)
%filename to path transform

root='C:\data\ImSpliceDataset\';
nvar=length(varargin);
for i=1:nvar/2
    pname=varargin{2*i-1};
    switch pname
        case 'root'
            root=varargin{2*i};
    end
end

lastunderscore=find(filename=='_',1,'last');
prefix=filename(1:lastunderscore-1);
prefix(prefix=='_')='-';
prefix=lower(prefix);
if isequal(prefix,'au-s-h')
    prefix='au-ss-h';
end

p=[root prefix filesep filename];
        