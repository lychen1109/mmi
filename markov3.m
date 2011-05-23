function h=markov3(img)
%equivalent filter for 3rd degree markov transition

x1=img(:,1:end-3);
x2=img(:,2:end-2);
x3=img(:,3:end-1);
x4=img(:,4:end);
y=x1-x2-x3+x4;
h=hist(y(:),-16:16);
h=h/(128*125);