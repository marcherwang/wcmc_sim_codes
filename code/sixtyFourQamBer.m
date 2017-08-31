%function sixtyFourQamBer: calculate the bit error rate of 64QAM at the given SINR.
%parameters: sinr, the SINR of the packet; unit (of sinr), which is 'ratio' or 'db';
%returned value: y, the bit error rate of the packet.
function y=sixtyFourQamBer(sinr, unit)
%convert to ratio
if strcmpi(unit, 'db')
    sinr=10^(sinr/10);%ratio
elseif strcmpi(unit, 'ratio')
else
    errorExit('Error using dsssDbpskSuccessRate: the unit of sinr must be ''db'' or ''ratio''.');    
end

z = sqrt (sinr / (21.0 * 2.0));
ber = 7.0 / 12.0 * 0.5 * erfc (z);
y=ber;
