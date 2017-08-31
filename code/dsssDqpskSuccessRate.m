%Function: calculating the success decoding rate of a packet for 2Mbps in 802.11b
%Parameters: sinr is the signal to interference and (thermal) noise ratio, unit is 'ratio' or 'db', nbits is the number of bits in the packet 
%Returned value: y is the success decoding rate of a packet
function y=dsssDqpskSuccessRate (sinr, unit, nbits)%for 2Mbps 802.11b
%convert unit
if strcmpi(unit, 'db')
    sinr=10^(sinr/10);%ratio
elseif strcmpi(unit, 'ratio')
else
    errorExit('Error using dsssDqpskSuccessRate: the unit of sinr must be ''db'' or ''ratio''.');    
end
EbN0 = sinr * 22000000.0 / 1000000.0 /2.0; % Eb/N0 (the energy per bit to noise power spectral density ratio)=(sinr/2000000)/(N0/22000000) 
ber = dqpskFunction(EbN0);
y=(1.0-ber)^nbits;