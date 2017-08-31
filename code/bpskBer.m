%function bpskBer: calculate the bit error rate of BPSK at the given SINR.
%parameters: sinr, the SINR of the packet, unit (of sinr), which is 'ratio' or 'db'.
%returned value: y, the bit error rate of the packet.
function y = bpskBer(sinr, unit)
    %convert to ratio
    if strcmpi(unit, 'db')
        sinr=10^(sinr/10);%ratio
    elseif strcmpi(unit, 'ratio')
    else
        errorExit('Error using dsssDbpskSuccessRate: the unit of sinr must be ''db'' or ''ratio''.');    
    end
    
    z=sqrt(sinr);
    ber=0.5*erfc(z);
    y=ber;