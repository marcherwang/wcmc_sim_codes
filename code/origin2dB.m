%Function: converting SNR ratio value (or milli-watts) to dB (or dBm) 
%Parameters: x, the ratio value
%Returned value: y, the dB value
function y = origin2dB(x)
y = 10.*log10(x);
