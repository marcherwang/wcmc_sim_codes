%Function linkBerPerf: running simulation to get the link performance according to the BER reception model for a given line topology.
%
%Parameters: including channel parameters and topology paramenters.
%pathLoss is the path loss type id; alpha is the path loss exponent for the general path loss model 
%fading is the multipath fading type id; nakagami_m is the m value in Nakagami fading model
%thermalNoise; unitNoise is the unit of thermal noise in 'dbm' or 'mw';
%bitRate; antennaH is the antenna height used by the two ray gound path
%loss model; txPower is the transmission power; unitTx is the unit of
%txPower in 'dbm' or 'mw'; rxThresh is the receive threshold; unitRxTh is
%the unit of rxThresh in 'dbm' or 'mw'; csThresh is the carrise threshold;
%unitCsTh is the unit of csThresh in 'dbm' or 'mw'; pktNum is the number of
%packets transmitted, pktLen is the packet length in bits; d_tr, d_ri and
%d_ti are the transmission distance, interference distance and carrier sensing distance, respectively. 
%
%Returned value: performance measures, y is [idle success ratio, idle failure ratio, busy sucess ratio, busy failure ratio].
%(my note: if we use object oriented programming, we can avoid the long list of parameters and put the related parameters into its object.)
function y = linkBerPerf(pathLoss, alpha, fading, nakagami_m, thermalNoise, unitNoise, bitRate, antennaH, txPower, unitTx, rxThresh, unitRxTh, csThresh, unitCsTh, pktNum, pktLen, d_tr, d_ri, d_ti)
constants; %wireless contants
%convert unit
if strcmpi(unitNoise, 'dbm')
    thermalNoise=10^(thermalNoise/10); %to mW
elseif strcmpi(unitNoise, 'mw')
else
    errorExit('Error using linkBerPerf: the unit of thermalNoise must be ''dbm'' or ''mw''.');
end
%convert unit
if strcmpi(unitTx, 'dbm')
    txPower=10^(txPower/10); %to mW
elseif strcmpi(unitTx, 'mw')
else
    errorExit('Error using linkBerPerf: the unit of txPower must be ''dbm'' or ''mw''.');
end
%convert unit
if strcmpi(unitRxTh, 'dbm')
    rxThresh=10^(rxThresh/10); %mW
elseif strcmpi(unitRxTh, 'mw')
else
    errorExit('Error using linkBerPerf: the unit of rxThresh must be ''dbm'' or ''mw''.');    
end
%convert unit
if strcmpi(unitCsTh, 'dbm')
    csThresh=10^(csThresh/10); %to mW
elseif strcmpi(unitCsTh, 'mw')
else
    errorExit('Error using linkBerPerf: the unit of csThresh must be ''dbm'' or ''mw''.');
end

%initialize
cntIdleSuc=0;
cntIdleFail=0;
cntBusySuc=0;
cntBusyFail=0;

for i=1:pktNum
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
    
    %randomly generate the rx power based on the fading model
    if fading==NONFADING
        rxPower=avg_rxPower;
        inPower=avg_inPower;
        csPower=avg_csPower;    
    elseif fading==RAYLEIGH
        rxPower=rayleighFading(avg_rxPower, 'mW', 'mW');%random number, the power in the parameter of fading function (in the brackets) is the average power, and the power before "=" is the randomly generated power at an instance
        inPower=rayleighFading(avg_inPower, 'mW', 'mW');%random number
        csPower=rayleighFading(avg_csPower, 'mW', 'mW');%random number
    elseif fading==NAKAGAMI 
        rxPower=nakagamiFading(avg_rxPower, 'mW', nakagami_m, 'mW');
        inPower=nakagamiFading(avg_inPower, 'mW', nakagami_m, 'mW');
        csPower=nakagamiFading(avg_csPower, 'mW', nakagami_m, 'mW');
    elseif fading==WEIBULL
        
    else
        errorExit('Error using linkBerPerf(): no such fading model!');
    end

    %calculate Bit Success Rate (1-BER) for the given signal power and interference power
    totalNoise=inPower+thermalNoise;
    sinr=rxPower/totalNoise;
    
    % The folowing is four rates in 802.11 b/g
    if bitRate==STA_802_11b_g_RATE_1M 
        psr=packetSuccessRate (WIFI_MOD_CLASS_DSSS, WIFI_CODE_RATE_UNDEFINED, 2, bitRate, sinr, 'ratio', pktLen);
        %psr=dsssDbpskSuccessRate(rxPower/totalNoise, 'ratio', pktLen);
    elseif bitRate==STA_802_11b_g_RATE_2M
        psr=packetSuccessRate (WIFI_MOD_CLASS_DSSS, WIFI_CODE_RATE_UNDEFINED, 4, bitRate, sinr, 'ratio', pktLen);
        %psr=dsssDqpskSuccessRate(rxPower/totalNoise, 'ratio', pktLen);
    elseif bitRate==STA_802_11b_g_RATE_5_5M
        psr=packetSuccessRate (WIFI_MOD_CLASS_DSSS, WIFI_CODE_RATE_UNDEFINED, 4, bitRate, sinr, 'ratio', pktLen);
        %psr=dsssDqpskCck5_5SuccessRate(rxPower/totalNoise, 'ratio', pktLen);
    elseif bitRate==STA_802_11b_g_RATE_11M
        psr=packetSuccessRate (WIFI_MOD_CLASS_DSSS, WIFI_CODE_RATE_UNDEFINED, 4, bitRate, sinr, 'ratio', pktLen);
        %psr=dsssDqpskCck11SuccessRate(rxPower/totalNoise, 'ratio', pktLen);
    % The folowing is eight rates in 802.11 a/g    
    elseif bitRate==STA_802_11a_g_RATE_6M 
        psr=packetSuccessRate (WIFI_MOD_CLASS_OFDM, WIFI_CODE_RATE_1_2, 2, bitRate, sinr, 'ratio', pktLen);%It should be WIFI_MOD_CLASS_ERP_OFDM for 802.11g, but the processing of packetSuccessRate() is same as 802.11a. 
    elseif bitRate==STA_802_11a_g_RATE_9M 
        psr=packetSuccessRate (WIFI_MOD_CLASS_OFDM, WIFI_CODE_RATE_3_4, 2, bitRate, sinr, 'ratio', pktLen);
    elseif bitRate==STA_802_11a_g_RATE_12M    
        psr=packetSuccessRate (WIFI_MOD_CLASS_OFDM, WIFI_CODE_RATE_1_2, 4, bitRate, sinr, 'ratio', pktLen);
    elseif bitRate==STA_802_11a_g_RATE_18M    
        psr=packetSuccessRate (WIFI_MOD_CLASS_OFDM, WIFI_CODE_RATE_3_4, 4, bitRate, sinr, 'ratio', pktLen);
    elseif bitRate==STA_802_11a_g_RATE_24M
        psr=packetSuccessRate (WIFI_MOD_CLASS_OFDM, WIFI_CODE_RATE_1_2, 16, bitRate, sinr, 'ratio', pktLen);
    elseif bitRate==STA_802_11a_g_RATE_36M
        psr=packetSuccessRate (WIFI_MOD_CLASS_OFDM, WIFI_CODE_RATE_3_4, 16, bitRate, sinr, 'ratio', pktLen);
    elseif bitRate==STA_802_11a_g_RATE_48M
        psr=packetSuccessRate (WIFI_MOD_CLASS_OFDM, WIFI_CODE_RATE_2_3, 64, bitRate, sinr, 'ratio', pktLen);
    elseif bitRate==STA_802_11a_g_RATE_54M
        psr=packetSuccessRate (WIFI_MOD_CLASS_OFDM, WIFI_CODE_RATE_3_4, 64, bitRate, sinr, 'ratio', pktLen);
    % The folowing is eight rates in 802.11n
    elseif bitRate==STA_802_11n_20M_RATE_6_5M 
        psr=packetSuccessRate (WIFI_MOD_CLASS_HT, WIFI_CODE_RATE_1_2, 2, bitRate, sinr, 'ratio', pktLen);
    elseif bitRate==STA_802_11n_20M_RATE_13M
        psr=packetSuccessRate (WIFI_MOD_CLASS_HT, WIFI_CODE_RATE_1_2, 4, bitRate, sinr, 'ratio', pktLen);
    elseif bitRate==STA_802_11n_20M_RATE_19_5M
        psr=packetSuccessRate (WIFI_MOD_CLASS_HT, WIFI_CODE_RATE_3_4, 4, bitRate, sinr, 'ratio', pktLen);
    elseif bitRate==STA_802_11n_20M_RATE_26M
        psr=packetSuccessRate (WIFI_MOD_CLASS_HT, WIFI_CODE_RATE_1_2, 16, bitRate, sinr, 'ratio', pktLen);
    elseif bitRate==STA_802_11n_20M_RATE_39M
        psr=packetSuccessRate (WIFI_MOD_CLASS_HT, WIFI_CODE_RATE_3_4, 16, bitRate, sinr, 'ratio', pktLen);
    elseif bitRate==STA_802_11n_20M_RATE_52M
        psr=packetSuccessRate (WIFI_MOD_CLASS_HT, WIFI_CODE_RATE_2_3, 64, bitRate, sinr, 'ratio', pktLen);
    elseif bitRate==STA_802_11n_20M_RATE_58_5M
        psr=packetSuccessRate (WIFI_MOD_CLASS_HT, WIFI_CODE_RATE_3_4, 64, bitRate, sinr, 'ratio', pktLen);
    elseif bitRate==STA_802_11n_20M_RATE_65M    
        psr=packetSuccessRate (WIFI_MOD_CLASS_HT, WIFI_CODE_RATE_5_6, 64, bitRate, sinr, 'ratio', pktLen);
    else
        errorExit('Error in linkBerPerf(): no such modulation scheme!');
    end
    
    %process different events
     if(csPower<csThresh) %channel idle 
        if rxPower>=rxThresh & rand(1)<psr
            cntIdleSuc=cntIdleSuc+1;
        else
            cntIdleFail=cntIdleFail+1;
        end
     else %channel busy
        if (rxPower>=rxThresh & rand(1)<psr)
            cntBusySuc=cntBusySuc+1;
        else
            cntBusyFail=cntBusyFail+1;
        end
     end % if(csPower<csThresh)
     
end % for i=1:pktNum

ratioIdleSuc=cntIdleSuc/pktNum;
ratioIdleFail=cntIdleFail/pktNum;
ratioBusySuc=cntBusySuc/pktNum;
ratioBusyFail=cntBusyFail/pktNum;
y(1)=ratioIdleSuc;
y(2)=ratioIdleFail;
y(3)=ratioBusySuc;
y(4)=ratioBusyFail;