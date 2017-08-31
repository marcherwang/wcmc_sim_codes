%Function db2Origin: converting dB (or dBm) to the SNR ratio value (or milli-watts)
%Parameters: x, the dB value
%Returned value: y, the ratio value
function y = db2Origin(x)
y = 10.^(x./10);
