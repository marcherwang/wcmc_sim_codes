%Function dsssDqpskCck11SuccessRate: calculating the success decoding rate of a packet for 11Mbps in 802.11b
%Parameters: snr is the signal to noise ratio, unit is 'ratio' or 'db', nbits is the number of bits in the packet 
%Returned value: z is the success decoding rate of a packet
function z = dsssDqpskCck11SuccessRate (sinr, unit, nbits)
%convert unit
if strcmpi(unit, 'db')
    sinr=10^(sinr/10);%ratio
elseif strcmpi(unit, 'ratio')
else
    errorExit('Error using dsssDqpskCck11SuccessRate: the unit of sinr must be ''db'' or ''ratio''.');    
end

if sinr > 10.0
    ber = 0.0;
elseif sinr < 0.1
    ber = 0.5;
else
    a1 =  7.9056742265333456e-003;
    a2 = -1.8397449399176360e-001;
    a3 =  1.0740689468707241e+000;
    a4 =  1.0523316904502553e+000;
    a5 =  3.0552298746496687e-001;
    a6 =  2.2032715128698435e+000;
    ber = (a1 * sinr * sinr + a2 * sinr + a3) / (sinr * sinr * sinr + a4 * sinr * sinr + a5 * sinr + a6);
end
z = (1.0 - ber)^nbits;