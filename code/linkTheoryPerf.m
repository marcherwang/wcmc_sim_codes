%Function: calculating the value of theoretical performance formulae based only on the SNRT model for both static (no fading) and fading channels
%(note: we ignore rxThresh and thermalNoise in the formule)
%
%Parameters: including channel parameters and topology paramenters.
%pathLoss is the path loss type id; alpha is the path loss exponent for the general path loss model 
%fading is the multipath fading type id; nakagami_m is the m value in Nakagami fading model
%bitRate; antennaH is the antenna height used by the two ray gound path
%loss model; txPower is the transmission power; unitTx is the unit of txPower in 'dbm' or 'mw'; csThresh is the carrise threshold; unitCsTh is the unit of csThresh in 'dbm' or 'mw'; snrThresh is the SNR threshold for correct decoding, unitSnrTh is the unit of snrThresh in "dB" or "ratio"; pktNum is the number of packets transmitted, pktLen is the packet length in bits; d_tr, d_ri and
%d_ti are the transmission distance, interference distance and carrier sensing distance, respectively.
%
%Returned value: performance measures
function y = linkTheoryPerf(pathLoss, alpha, fading, nakagami_m, bitRate, antennaH, txPower, unitTx, csThresh, unitCsTh, snrThresh, unitSnrTh, d_tr, d_ri, d_ti)
constants; %wireless contants
%convert unit
if strcmpi(unitTx, 'dbm')
    txPower=10^(txPower/10); %to mW
elseif strcmpi(unitTx, 'mw')
else
    errorExit('Error using linkTheoryPerf: the unit of txPower must be ''dbm'' or ''mw''.');
end
%convert unit
if strcmpi(unitCsTh, 'dbm')
    csThresh=10^(csThresh/10); %to mW
elseif strcmpi(unitCsTh, 'mw')
else
    errorExit('Error using linkTheoryPerf: the unit of unitCsTh must be ''dbm'' or ''mw''.');
end
%convert unit
if strcmpi(unitSnrTh, 'db')
    snrThresh=10^(snrThresh/10); %to ratio
elseif strcmpi(unitSnrTh, 'ratio')
else
    errorExit('Error using linkTheoryPerf: the unit of snrThresh must be ''db'' or ''ratio''.');
end

%initialize
ratioIdleSuc=0;
ratioIdleFail=0;
ratioBusySuc=0;
ratioBusyFail=0;
p_idle=0;
p_suc=0;

%calculate the "average" rx power based on the large-scale path loss model
if pathLoss==FRIIS
    avg_rxPower=friis(txPower, 'mW', d_tr, 'mW');
    avg_inPower=friis(txPower, 'mW',d_ri, 'mW');
    avg_csPower=friis(txPower, 'mW',d_ti, 'mW');
elseif pathLoss==TWO_RAY_GROUND
    avg_rxPower=twoRayGround(txPower, 'mW', d_tr, antennaH, antennaH, 'mW');
    avg_inPower=twoRayGround(txPower, 'mW', d_ri, antennaH, antennaH, 'mW');
    avg_csPower=twoRayGround(txPower, 'mW', d_ti, antennaH, antennaH, 'mW');
elseif pathLoss==GENERAL_PATH_LOSS
        avg_rxPower=generalPathLoss(P0, 'dBm', D0, d_tr, alpha, 'mW');%receive power at d0=1 is 1 in unitOne.
        avg_inPower=generalPathLoss(P0, 'dBm', D0, d_ri, alpha, 'mW');
        avg_csPower=generalPathLoss(P0, 'dBm', D0, d_ti, alpha, 'mW');
else
    errorExit('Error using linkBerPerf(): no such path loss model!');
end

%calcuate p_suc and p_idle 
if fading==NONFADING
    %calcuate p_suc
    if(avg_rxPower/avg_inPower>=snrThresh)
        p_suc=1;
    else
        p_suc=0;       
    end    
    %calcuate p_idle
    if(avg_csPower<csThresh)
        p_idle=1;
    else
        p_idle=0;
    end
elseif fading==RAYLEIGH %(Note: must be in the unit of ratio)
    %calcuate p_suc
    p_suc=1-1/(1+(avg_rxPower/avg_inPower)/snrThresh); %Rayleigh fading PSR theoretical formula
    %calcuate p_idle
    p_idle=1-exp(-csThresh/avg_csPower);
elseif fading==NAKAGAMI 
    %calcuate p_suc
    p_suc=nakagamiFadingPSR(avg_rxPower, avg_inPower, 'mW', snrThresh, 'ratio', nakagami_m);
    %calcuate p_idle
    p_idle=1-exp(-csThresh/avg_csPower);
elseif fading==WEIBULL
        
else
        errorExit('Error using linkTheoryPerf(): no such fading model!');
end


ratioIdleSuc=p_idle*p_suc;
ratioIdleFail=p_idle*(1-p_suc);
ratioBusySuc=(1-p_idle)*p_suc;
ratioBusyFail=(1-p_idle)*(1-p_suc);
y(1)=ratioIdleSuc;
y(2)=ratioIdleFail;
y(3)=ratioBusySuc;
y(4)=ratioBusyFail;
