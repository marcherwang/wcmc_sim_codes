%Function dsssDqpskCck5_5SuccessRate: calculating the success decoding rate of a packet for 5.5Mbps in 802.11b
%Parameters: sinr is the signal to interference and (thermal) noise ratio, unit is 'ratio' or 'db', nbits is the number of bits in the packet 
%Returned value: y is the success decoding rate of a packet
function y = dsssDqpskCck5_5SuccessRate (sinr, unit, nbits)
%convert unit
if strcmpi(unit, 'db')
    sinr=10^(sinr/10);%ratio
elseif strcmpi(unit, 'ratio')
else
    errorExit('Error using dsssDqpskCck5_5SuccessRate: the unit of sinr must be ''db'' or ''ratio''.');    
end

if sinr > 10.0
    ber = 0.0;
elseif sinr < 0.1
    ber = 0.5;
else
    a1 =  5.3681634344056195e-001;
    a2 =  3.3092430025608586e-003;
    a3 =  4.1654372361004000e-001;
    a4 =  1.0288981434358866e+000;
    ber = a1 * exp (-((sinr - a2) / a3)^a4);
end
y = (1.0 - ber)^nbits;
        