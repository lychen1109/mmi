function D=tpm1(img,T,opt)
%tmp horizontal with threshold
%opt: 1 - without normalization; 2 - with matrix normalization; 3 - with
%row normalization

[~,M]=size(img);
% img=blkproc(img,[8 8],@dct2);
% img=abs(round(img));
diffimg=img(:,1:M-1)-img(:,2:M);
%diffimg=round(diffimg);

D=tpmf(diffimg,T,opt);




