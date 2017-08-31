%function fec16QamSuccessRate: calculate the success rate of a packet transmitted in the FEC 16QAM modulation scheme at the given SINR.
%parameters: sinr, the SINR of a packet; unit (of sinr), which is 'ratio' or 'db'; nbits, the number of bits of a packet; bValue, some parameter related to code rate.
%returned value: y, packet success rate of the packet.
function y = fec16QamSuccessRate (sinr, unit, nbits, bValue)
    ber = sixteenQamBer(sinr, unit);
    if ber == 0.0
        y=1.0;  
        return;
    end
    pe = calculatePe(ber, bValue);
    pe = min (pe, 1.0);
    y = (1-pe)^nbits;