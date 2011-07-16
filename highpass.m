function y=highpass(x)
%high pass filter of 8x8 mat

t=hftemplate;
y=t.*x;