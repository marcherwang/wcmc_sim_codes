%function calcSnrThreshes: calculate the SNR threshold (dB) for each bit rate in a set of bit rates and the given packet length.
%parameters: bitRates, a set of bit rates
%returned value: null (print SNR thresholds on the console)

function calcSnrThreshes(bitRates)
constants;
pktLen=PKT_LEN; %packet length is set in constants.m
minSnr=-5; maxSnr=50; stepSnr=0.01;
epsilon=0.05; % the max deviation of PSR from 0.5 
impossibleSnr=1000;
snrThreshes=zeros(1,length(bitRates));
snrThreshPSRs=ones(1,length(bitRates)); %must be ones
for i=1:length(bitRates)
    snrThreshes(i)=impossibleSnr;
end
finishCount=0;


%For each SNR, check which bit rate generates 50% packet success rate. On
%that condition, the SNR is the SNR threshold for that bit rate.
for snr=minSnr:stepSnr:maxSnr
    %Examine each bit rate
    for brIter=1:length(bitRates)
        bitRate=bitRates(brIter);
        % The folowing is four rates in 802.11 b/g
        if bitRate==STA_802_11b_g_RATE_1M && snrThreshes(brIter)==impossibleSnr 
            psr=packetSuccessRate (WIFI_MOD_CLASS_DSSS, WIFI_CODE_RATE_UNDEFINED, 2, bitRate, snr, 'dB', pktLen);
            %psr=dsssDbpskSuccessRate(rxPower/totalNoise, 'dB', pktLen);
        elseif bitRate==STA_802_11b_g_RATE_2M && snrThreshes(brIter)==impossibleSnr
            psr=packetSuccessRate (WIFI_MOD_CLASS_DSSS, WIFI_CODE_RATE_UNDEFINED, 4, bitRate, snr, 'dB', pktLen);
            %psr=dsssDqpskSuccessRate(rxPower/totalNoise, 'dB', pktLen);
        elseif bitRate==STA_802_11b_g_RATE_5_5M && snrThreshes(brIter)==impossibleSnr
            psr=packetSuccessRate (WIFI_MOD_CLASS_DSSS, WIFI_CODE_RATE_UNDEFINED, 4, bitRate, snr, 'dB', pktLen);
            %psr=dsssDqpskCck5_5SuccessRate(rxPower/totalNoise, 'dB', pktLen);
        elseif bitRate==STA_802_11b_g_RATE_11M && snrThreshes(brIter)==impossibleSnr
            psr=packetSuccessRate (WIFI_MOD_CLASS_DSSS, WIFI_CODE_RATE_UNDEFINED, 4, bitRate, snr, 'dB', pktLen);
            %psr=dsssDqpskCck11SuccessRate(rxPower/totalNoise, 'dB', pktLen);
        % The folowing is eight rates in 802.11 a/g    
        elseif bitRate==STA_802_11a_g_RATE_6M  && snrThreshes(brIter)==impossibleSnr
            psr=packetSuccessRate (WIFI_MOD_CLASS_OFDM, WIFI_CODE_RATE_1_2, 2, bitRate, snr, 'dB', pktLen);%It should be WIFI_MOD_CLASS_ERP_OFDM for 802.11g, but the processing of packetSuccessRate() is same as 802.11a. 
        elseif bitRate==STA_802_11a_g_RATE_9M  && snrThreshes(brIter)==impossibleSnr
            psr=packetSuccessRate (WIFI_MOD_CLASS_OFDM, WIFI_CODE_RATE_3_4, 2, bitRate, snr, 'dB', pktLen);
        elseif bitRate==STA_802_11a_g_RATE_12M  && snrThreshes(brIter)==impossibleSnr   
            psr=packetSuccessRate (WIFI_MOD_CLASS_OFDM, WIFI_CODE_RATE_1_2, 4, bitRate, snr, 'dB', pktLen);
        elseif bitRate==STA_802_11a_g_RATE_18M  && snrThreshes(brIter)==impossibleSnr   
            psr=packetSuccessRate (WIFI_MOD_CLASS_OFDM, WIFI_CODE_RATE_3_4, 4, bitRate, snr, 'dB', pktLen);
        elseif bitRate==STA_802_11a_g_RATE_24M  && snrThreshes(brIter)==impossibleSnr
            psr=packetSuccessRate (WIFI_MOD_CLASS_OFDM, WIFI_CODE_RATE_1_2, 16, bitRate, snr, 'dB', pktLen);
        elseif bitRate==STA_802_11a_g_RATE_36M  && snrThreshes(brIter)==impossibleSnr
            psr=packetSuccessRate (WIFI_MOD_CLASS_OFDM, WIFI_CODE_RATE_3_4, 16, bitRate, snr, 'dB', pktLen);
        elseif bitRate==STA_802_11a_g_RATE_48M  && snrThreshes(brIter)==impossibleSnr
            psr=packetSuccessRate (WIFI_MOD_CLASS_OFDM, WIFI_CODE_RATE_2_3, 64, bitRate, snr, 'dB', pktLen);
        elseif bitRate==STA_802_11a_g_RATE_54M  && snrThreshes(brIter)==impossibleSnr
            psr=packetSuccessRate (WIFI_MOD_CLASS_OFDM, WIFI_CODE_RATE_3_4, 64, bitRate, snr, 'dB', pktLen);
        % The folowing is eight rates in 802.11n
        elseif bitRate==STA_802_11n_20M_RATE_6_5M  && snrThreshes(brIter)==impossibleSnr 
            psr=packetSuccessRate (WIFI_MOD_CLASS_HT, WIFI_CODE_RATE_1_2, 2, bitRate, snr, 'dB', pktLen);
        elseif bitRate==STA_802_11n_20M_RATE_13M  && snrThreshes(brIter)==impossibleSnr
            psr=packetSuccessRate (WIFI_MOD_CLASS_HT, WIFI_CODE_RATE_1_2, 4, bitRate, snr, 'dB', pktLen);
        elseif bitRate==STA_802_11n_20M_RATE_19_5M  && snrThreshes(brIter)==impossibleSnr
            psr=packetSuccessRate (WIFI_MOD_CLASS_HT, WIFI_CODE_RATE_3_4, 4, bitRate, snr, 'dB', pktLen);
        elseif bitRate==STA_802_11n_20M_RATE_26M  && snrThreshes(brIter)==impossibleSnr
            psr=packetSuccessRate (WIFI_MOD_CLASS_HT, WIFI_CODE_RATE_1_2, 16, bitRate, snr, 'dB', pktLen);
        elseif bitRate==STA_802_11n_20M_RATE_39M  && snrThreshes(brIter)==impossibleSnr
            psr=packetSuccessRate (WIFI_MOD_CLASS_HT, WIFI_CODE_RATE_3_4, 16, bitRate, snr, 'dB', pktLen);
        elseif bitRate==STA_802_11n_20M_RATE_52M  && snrThreshes(brIter)==impossibleSnr
            psr=packetSuccessRate (WIFI_MOD_CLASS_HT, WIFI_CODE_RATE_2_3, 64, bitRate, snr, 'dB', pktLen);
        elseif bitRate==STA_802_11n_20M_RATE_58_5M  && snrThreshes(brIter)==impossibleSnr
            psr=packetSuccessRate (WIFI_MOD_CLASS_HT, WIFI_CODE_RATE_3_4, 64, bitRate, snr, 'dB', pktLen);
        elseif bitRate==STA_802_11n_20M_RATE_65M  && snrThreshes(brIter)==impossibleSnr   
            psr=packetSuccessRate (WIFI_MOD_CLASS_HT, WIFI_CODE_RATE_5_6, 64, bitRate, snr, 'dB', pktLen);
        else
            %errorExit('Error in calcSnrThreshes(): no such modulation scheme!');
        end
        
        %Set the SNR threshold on the satisfied condition
        if abs(psr-0.5)<epsilon && snrThreshes(brIter)==impossibleSnr
            snrThreshes(brIter)=snr;
            finishCount=finishCount+1;
        end 
    end %inner for
    
    %Early exit (it considered setting snr thresholds repetitively for the same rate)
    if finishCount==length(bitRates)
        break;
    end
end %outside for

if  finishCount==length(bitRates)
    snrThreshes
else
    disp('Error: SNR thresholds of some rates are not set!');
    snrThreshes
end
