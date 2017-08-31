%Function genCurveData: generating the curve of link performance for various interference distance when the locations of transmitter and receiver are fixed.
%Parameters: pathLoss is the path loss type id; alpha is the path loss exponent for the general path loss model; fading is the multipath fading type id; rxModel is the recetion model; bitRate is the bit rate used; 
%  thermalNoise; unitNoise is the unit of thermal noise in "dBm" or "mW"; antennaH is the antenna height used by the two ray gound path txPower is the transmission power in dBm or mW; 
%  rxThresh is the reception sensitivity or threshold in dBm or mW, unitRxTh is the unit of rxThresh in "dBm" or "mW"
%  csThresh is the carrise threshold; unitCsTh is the unit of csThresh in "dBm" or "mW";
%  snrThresh is the SNR threshold for correct decoding, unitSnrTh is the unit of snrThresh in "dB" or "ratio";
%  pktNum is the number of packets transmitted, pktLen is the packet length in bits;
%  d_r is the transmission distance, d_iVec is the vector of interference distance.
%Returned value: y is the array of [idle success ratio, idle failure ratio, busy sucess ratio, busy failure ratio] for each interference distance in d_iVec. The dimension of y is d_iVec's length*4.
function y=genCurveData(pathLoss, alpha, fading, nakagami_m, rxModel, bitRate, thermalNoise, unitNoise, antennaH, txPower, unitTx, rxThresh, unitRxTh, csThresh, unitCsTh, snrThresh, unitSnrTh, pktNum, pktLen, x_t, x_r, x_iVec)
constants;
y=zeros(length(x_iVec),4);%four states

for i=1:length(x_iVec)
    %get d_tr, d_ri and d_ti from the line topology
    d_tr=abs(x_r-x_t);
    d_ri=abs(x_iVec(i)-x_r);
    d_ti=abs(x_iVec(i)-x_t);
    
    if rxModel==BER_MODEL %most realistic
        states=linkBerPerf(pathLoss, alpha, fading, nakagami_m, thermalNoise, unitNoise, bitRate, antennaH, txPower, unitTx, rxThresh, unitRxTh, csThresh, unitCsTh, pktNum, pktLen, d_tr, d_ri, d_ti);
    elseif rxModel==SNRT_MODEL %simplified realistic
        states=linkSnrtPerf(pathLoss, alpha, fading, nakagami_m, thermalNoise, unitNoise, bitRate, antennaH, txPower, unitTx, rxThresh, unitRxTh, csThresh, unitCsTh, snrThresh, unitSnrTh, pktNum, pktLen, d_tr, d_ri, d_ti);
    elseif rxModel==THEORY_MODEL %theory
        states=linkTheoryPerf(pathLoss, alpha, fading, nakagami_m, bitRate, antennaH, txPower, unitTx, csThresh, unitCsTh, snrThresh, unitSnrTh, d_tr, d_ri, d_ti);
    end
    y(i,1)=states(1);
    y(i,2)=states(2);
    y(i,3)=states(3);
    y(i,4)=states(4);
end %for i=1:length(x_iVec)