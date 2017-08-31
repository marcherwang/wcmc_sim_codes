%function fecBpskSuccessRate: calculate the success rate of a packet transmitted in the FEC BPSK modulation scheme at the given SINR.
%parameters: sinr, the SINR of a packet; unit (of sinr), which is 'ratio' or 'db'; nbits, the number of bits of a packet; bValue, some parameter related to code rate.
%returned value: y, packet success rate of the packet.
function y = fecBpskSuccessRate(sinr, unit, nbits, bValue)
    ber=bpskBer(sinr, unit);
    if ber==0.0
      y=1.0;
      return;
    end
    pe=calculatePe(ber, bValue);
    pe=min(pe, 1.0);
    y=(1-pe)^nbits;