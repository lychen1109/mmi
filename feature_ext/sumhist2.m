function shist=sumhist2(img,T)
%sum histogram feature extraction

x1=img(:,1:end-2);
x3=img(:,3:end);
z=0.71*(x1-x3);

X=-T:T;
shist=hist(z(:),X);
shist=shist/(length(z(:)));