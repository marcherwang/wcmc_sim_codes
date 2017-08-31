%function calcCsThresh: calculate the aggressive and conservative CSTs for a given bit rate 
%parameters: bitRate
%returned value: void
function calcCsThresh(bitRate)
constants;
txDist=10;
snrThreshRatio=db2Origin(SNR_THRESHES(bitRate));
avg_rxPower=generalPathLoss(P0, 'dBm', D0, txDist, PATH_LOSS_EXPONENT, 'mW'); %6.2579e-006mW
fprintf('csThreshAggressive: %f dBm\n', origin2dB(avg_rxPower)); %csRange=txDist
fprintf('csThreshConservative: %f dBm\n', origin2dB(avg_rxPower/(1+snrThreshRatio^(1/PATH_LOSS_EXPONENT))^PATH_LOSS_EXPONENT)); %csRange=txDist+interference range
