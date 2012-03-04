function outputs=histhackrun2a(images,targets,K,T)
%test randperm for potential

outputs=cell(5,1);
for i=1:1
    outputs{i}=histhackrun2(images,targets,K,T);
end
