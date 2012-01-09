function D=tpm1(img,T)
%tmp horizontal with threshold

[N,M]=size(img);
% img=blkproc(img,[8 8],@dct2);
% img=abs(round(img));
diffimg=img(1:N-1,1:M-1)-img(1:N-1,2:M);
%diffimg=round(diffimg);

D=tpmf(diffimg,T);




