%Function plotStaticVsFadingCS.m: plot static versus fading channels with carrier sensing as x_i varies using the BER reception model.
%
%Parameters: bitRate; fadingType; nakagamiM; csThresh, carrier sense threshold; unitCsThresh, 'dbm' or 'mw' 
%
%Returned value: void
function plotStaticVsFadingCs(standardName, bitRate, fadingType, nakagamiM, csThresh, unitCsThresh)
%You can get the typical cs thresholds by £º
%  calcCsThresh(bitRate).
%%b/g 11M, PATH_LOSS_EXPONENT=3: plotStaticVsRayleighCsb_g_agg_cst_11m_4s.eps
%plotStaticVsFadingCs('b/g', STA_802_11b_g_RATE_11M, RAYLEIGH, 1, -52.0,'dbm');% for csRange=txDist in static channel 
%plotStaticVsFadingCs('b/g', STA_802_11b_g_RATE_11M, RAYLEIGH, 1, -66.1,'dbm');% for csRange=(1+snrThreshRatio^(1/PATH_LOSS_EXPONENT))*txDist in static channel
%%b/g 11M, PATH_LOSS_EXPONENT=6
%plotStaticVsFadingCs('b/g', STA_802_11b_g_RATE_11M, RAYLEIGH, 1, -73.0,'dbm');% for csRange=txDist in static channel 
%plotStaticVsFadingCs('b/g', STA_802_11b_g_RATE_11M, RAYLEIGH, 1, -99.9,'dbm');% for csRange=(1+snrThreshRatio^(1/PATH_LOSS_EXPONENT))*txDist in static channel
%%b/g 5.5M, PATH_LOSS_EXPONENT=3
%plotStaticVsFadingCs('b/g', STA_802_11b_g_RATE_5_5M, RAYLEIGH, 1, -52.0,'dbm');% for csRange=txDist in static channel 
%plotStaticVsFadingCs('b/g', STA_802_11b_g_RATE_5_5M, RAYLEIGH, 1, -63.6,'dbm');% for csRange=(1+snrThreshRatio^(1/PATH_LOSS_EXPONENT))*txDist in static channel
%%b/g 2M, PATH_LOSS_EXPONENT=3
%plotStaticVsFadingCs('b/g', STA_802_11b_g_RATE_2M, RAYLEIGH, 1, -52.0,'dbm');% for csRange=txDist in static channel 
%plotStaticVsFadingCs('b/g', STA_802_11b_g_RATE_2M, RAYLEIGH, 1, -60.9,'dbm');% for csRange=(1+snrThreshRatio^(1/PATH_LOSS_EXPONENT))*txDist in static channel
%%b/g 1M, PATH_LOSS_EXPONENT=3
%plotStaticVsFadingCs('b/g', STA_802_11b_g_RATE_1M, RAYLEIGH, 1, -52.0,'dbm');% for csRange=txDist in static channel 
%plotStaticVsFadingCs('b/g', STA_802_11b_g_RATE_1M, RAYLEIGH, 1, -58.9,'dbm');% for csRange=(1+snrThreshRatio^(1/PATH_LOSS_EXPONENT))*txDist in static channel
%%a/g 6M, PATH_LOSS_EXPONENT=3
%plotStaticVsFadingCs('a/g', STA_802_11a_g_RATE_6M, RAYLEIGH, 1, -62.6,'dbm');

%See below to set csThresh. 

%set simulation parameters
constants; %constants.m
XS=[-10:0.4:10];%X axis in range of d_ir in terms of multiple d_tr

%set the channel model (can be adjusted)
%see constants.m

%set the topology
x_t=0; %distance from the origin
x_r=10; %can be adjusted, x_r=50 will cause interference to be smaller than thermal noise.
d_tr=abs(x_r-x_t);
x_iVec=XS*d_tr;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%csThresh=generalPathLoss(P0, 'dBm', D0, d_tr, PATH_LOSS_EXPONENT, 'dBm') %-52.04 for csRange=txDist in static channels
%csThresh=generalPathLoss(P0, 'dBm', D0, d_tr*(db2Origin(SNR_THRESHES(bitRate))^(1/PATH_LOSS_EXPONENT)+1), PATH_LOSS_EXPONENT, 'dBm') %-64.35 for csRange=(1+snrThreshDb^(1/PATH_LOSS_EXPONENT))*txDist in static channels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bitRateName=STA_802_11_RATE_NAMES(bitRate,:);
fadingName=FADING_NAMES(fadingType,:);
if fadingType==NAKAGAMI
    fadingName = strcat(fadingName,'-',num2str(nakagamiM));
end
    
markers4S={'o-r', 's-g', '^-b', 'v-k', 'o-.r', 's-.g', '^-.b', 'v-.k'}; % Eight curves (four curves vs four curves): different lines
markers2S={'o-r','s-b', 'o-.r','s-.b'};% Four curves: 1(2) and 3(4) is a pair using same dot but different line

%Run simulation for static and fading channels
statesStatic=genCurveData(GENERAL_PATH_LOSS, PATH_LOSS_EXPONENT, NONFADING, nakagamiM, BER_MODEL, bitRate, THERMAL_NOISE, 'dbm', ANTENNA_HEIGHT, TX_POWER, 'dbm', RX_THRESHES(bitRate), 'dbm', csThresh, unitCsThresh, SNR_THRESHES(bitRate), 'db', PKT_NUM, PKT_LEN, x_t, x_r, x_iVec);
statesFading=genCurveData(GENERAL_PATH_LOSS, PATH_LOSS_EXPONENT, fadingType, nakagamiM, BER_MODEL, bitRate, THERMAL_NOISE, 'dbm', ANTENNA_HEIGHT, TX_POWER, 'dbm', RX_THRESHES(bitRate), 'dbm', csThresh, unitCsThresh, SNR_THRESHES(bitRate), 'db', PKT_NUM, PKT_LEN, x_t, x_r, x_iVec);

%plot(XS, statesStatic(:,1), '*');

%Plot four states for static and rayleigh channels 
figure();
plot(XS, statesStatic(:,1), cell2mat(markers4S(1))); hold on;
plot(XS, statesStatic(:,2), cell2mat(markers4S(2))); hold on;
plot(XS, statesStatic(:,3), cell2mat(markers4S(3))); hold on;
plot(XS, statesStatic(:,4), cell2mat(markers4S(4))); hold on;
plot(XS, statesFading(:,1), cell2mat(markers4S(5))); hold on;
plot(XS, statesFading(:,2), cell2mat(markers4S(6))); hold on;
plot(XS, statesFading(:,3), cell2mat(markers4S(7))); hold on;
plot(XS, statesFading(:,4), cell2mat(markers4S(8))); 
xlabel('x_I/x_R');
ylabel('prob.');
ylim([0,1]);
%legend(strcat('Static,', standardName, ' ', bitRateName, ':(Idle,Succ)'), strcat('Static,', standardName, ' ', bitRateName, ':(Idle,Fail)'), strcat('Static,', standardName, ' ', bitRateName, ':(Busy,Succ)'), strcat('Static,', standardName, ' ', bitRateName, ':(Busy,Fail)'), strcat(fadingName, ',', standardName, ' ', bitRateName, ':(Idle,Succ)'), strcat(fadingName, ',', standardName, ' ', bitRateName, ':(Idle,Fail)'), strcat(fadingName, ',', standardName, ' ', bitRateName, ':(Busy,Succ)'), strcat(fadingName, ',', standardName, ' ', bitRateName, ':(Busy,Fail)'));    
legend(['Static,', standardName, ' ', bitRateName, ',(Idle,Succ)'], ['Static,', standardName, ' ', bitRateName, ',(Idle,Fail)'], ['Static,', standardName, ' ', bitRateName, ',(Busy,Succ)'], ['Static,', standardName, ' ', bitRateName, ',(Busy,Fail)'], [fadingName, ',', standardName, ' ', bitRateName, ',(Idle,Succ)'], [fadingName, ',', standardName, ' ', bitRateName, ',(Idle,Fail)'], [fadingName, ',', standardName, ' ', bitRateName, ',(Busy,Succ)'], [fadingName, ',', standardName, ' ', bitRateName, ',(Busy,Fail)']);    
title(strcat('CST=',num2str(csThresh),'dBm'));
hold off;

%Plot two states for static and rayleigh channels 
figure();
plot(XS, statesStatic(:,1)+statesStatic(:,2), cell2mat(markers2S(1))); hold on;
plot(XS, statesStatic(:,1)+statesStatic(:,3), cell2mat(markers2S(2))); hold on;
plot(XS, statesFading(:,1)+statesFading(:,2), cell2mat(markers2S(3))); hold on;
plot(XS, statesFading(:,1)+statesFading(:,3), cell2mat(markers2S(4))); 
xlabel('x_I/x_R');
ylabel('prob.');
ylim([0,1]);
legend(['Static,', standardName, ' ', bitRateName, ',Idle'], ['Static,', standardName, ' ', bitRateName, ',Succ'], [fadingName, ',', standardName, ' ', bitRateName, ',Idle'], [fadingName, ',', standardName, ' ', bitRateName, ',Succ']);
title(strcat('CST=',num2str(csThresh),'dBm'));
hold off;