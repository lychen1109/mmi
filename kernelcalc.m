function kernel=kernelcalc(kernel_init,alpha,kernelb,level)
%calculate intermediate kernel

kernel=kernel_init;
for l=1:level
    kernel=kernel+alpha(l)*kernelb(:,:,l);
end
