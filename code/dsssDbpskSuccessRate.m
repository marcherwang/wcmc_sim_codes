%Function dsssDbpskSuccessRate: calculating the success decoding rate of a packet for 1Mbps in 802.11b
%Parameters: sinr is the signal to interference and (thermal) noise ratio, unit is 'ratio' or 'db', nbits is the number of bits in the packet 
%Returned value: y is the success decoding rate of a packet
function y=dsssDbpskSuccessRate (sinr, unit, nbits)%for 1Mbps 802.11b
%convert to ratio
if strcmpi(unit, 'db')
    sinr=10^(sinr/10);%ratio
elseif strcmpi(unit, 'ratio')
else
    errorExit('Error using dsssDbpskSuccessRate: the unit of sinr must be ''db'' or ''ratio''.');    
end
EbN0 = sinr * 22000000.0 / 1000000.0; % Eb/N0 (the energy per bit to noise power spectral density ratio)=(sinr/1000000)/(N0/22000000) 
ber = 0.5 * exp(-EbN0);
y=(1.0-ber)^nbits;