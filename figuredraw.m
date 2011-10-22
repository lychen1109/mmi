function figuredraw(img)
%figure draw for paper presentation

T=4;
subplot(2,2,1);
imagesc(img,[0 255]);
colormap gray;
axis off image
subplot(2,2,2);
D=tpm1d(img,T,0,1);
bar3(-T:T,D',0.5,'detached');

[~,sumimg,diffimg]=transtpm(img,T);
sumimg=sumimg-T-1;
diffimg=diffimg-T-1;

h1=hist(sumimg(:),-T:T)/length(sumimg(:));
subplot(2,2,3);
bar(-T:T,h1);
title('sum histogram');
xlim=get(gca,'xlim');
ylim=get(gca,'ylim');

h2=hist(diffimg(:),-T:T)/length(diffimg(:));
subplot(2,2,4);
bar(-T:T,h2);
title('difference histogram');
set(gca,'xlim',xlim);
set(gca,'ylim',ylim);


