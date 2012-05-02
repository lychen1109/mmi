function output=histhackrun2(images,targets,K,T)
%batch run of histhack*, using parfor

N=size(images,1);
ximages=zeros(128,128,N);
distarrays=cell(N,1);
distarray1s=cell(N,1);
distarray2s=cell(N,2);

parfor i=1:N    
    fprintf('processing image %d\n',i);
    [ximages(:,:,i),distarrays{i},distarray1s{i},distarray2s{i}]=histhack3d(images(i,:),targets(i,:),K,T);
end

output.ximages=reshape(ximages,128*128,N)';
output.distarrays=distarrays;
output.distarray1s=distarray1s;
output.distarray2s=distarray2s;



