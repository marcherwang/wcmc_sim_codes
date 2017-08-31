%function calculatePe: calculate the *coded* bit error rate for the given BER and bValue.
%parameters: p, the bit error rate; bValue, some parameter related to code rate.
%returned value: y, the coded bit error rate.
function y=calculatePe (p, bValue)
  D=sqrt(4.0*p*(1.0-p));
  pe = 1.0;
  if bValue == 1
      % code rate 1/2, use table 3.1.1w
      pe = 0.5 * (36.0 * D^10.0 + 211.0 * D^12.0 + 1404.0 * D^14.0 + 11633.0 * D^16.0 + 77433.0 * D^18.0 + 502690.0 * D^20.0 + 3322763.0 * D^22.0 + 21292910.0 * D^24.0 + 134365911.0 * D^26.0);
  elseif bValue == 2
      % code rate 2/3, use table 3.1.2
      pe = 1.0 / (2.0 * bValue) * (3.0 * D^6.0 + 70.0 * D^7.0 + 285.0 * D^8.0 + 1276.0 * D^9.0 + 6160.0 * D^10.0 + 27128.0 * D^11.0 + 117019.0 * D^12.0 + 498860.0 * D^13.0 + 2103891.0 * D^14.0 + 8784123.0 * D^15.0);
  elseif bValue == 3
      % code rate 3/4, use table 3.1.2
      pe = 1.0 / (2.0 * bValue) * (42.0 * D^5.0 + 201.0 * D^6.0 + 1492.0 * D^7.0 + 10469.0 * D^8.0 + 62935.0 * D^9.0 + 379644.0 * D^10.0 + 2253373.0 * D^11.0 + 13073811.0 * D^12.0 + 75152755.0 * D^13.0 + 428005675.0 * D^14.0);
  else
      errorExit('Error: no such bValue!');    
  end
  y=pe;
  