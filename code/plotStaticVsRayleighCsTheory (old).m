%Function plotStaticVsRayleighWCsTheory.m: plotting the states (i.e., idle &
%success, idle & failure, busy & sucess, busy & failure) as d_i
%(interference distance) varies when d_r (transmission distance) is fixed
%comparing static and Rayleigh channels using theorectical formulae, with
%carrier sensing considered.
%
%Parameters: bitRateName is '1M', '2M', '5.5M' and '11M' denoting RATE_1, RATE_2, RATE_5_5,
%RATE_11; csThresh is the carrier sensing threshold; unitCsTh is the unit
%of carrier sensing threshold in 'dbm' or 'mw'.
%
%Returned value: void
function plotStaticVsRayleighCsTheory(bitRateName, csThresh, unitCsTh)
constants; %constants.m
%%Running configuration  
txPower=15; %dBm
TGT_PSR=0.99; % target packet success ratio, to calculate fading margin (safe rx power)
antennaH=2; %(0.223 is the default antenna height in the two ray ground model generating the same rx power as in Friis when d=5m)
pktLen=256*8;%bits, 256bytes+511header
XS=[-10:0.4:10];%X axis in range of d_ir in terms of multiple d_tr
%XS=[2];
pktNum=1000; %number of packets to be transmitted

%bitRate type id
switch bitRateName
    case '1M'
        bitRate=RATE_1;
    case '2M'
        bitRate=RATE_2;
    case '5.5M'
        bitRate=RATE_5_5;
    case '11M'
        bitRate=RATE_11;
    otherwise
        errorExit('Error: unrecognized bitRateName and it must be ''1M'',''2M'',''5.5M'',''11M''');
end

%set the topology
x_t=0; %distance from the origin
x_r=70; %can be adjusted
d_tr=abs(x_r-x_t);
x_iVec=XS*d_tr;

markers4S={'o-r', 's-g', '^-b', 'v-k', 'o-.r', 's-.g', '^-.b', 'v-.k'}; % Eight curves (four curves vs four curves): different lines
markers2S={'o-r','s-b', 'o-.r','s-.b'};% Four curves: 1(2) and 3(4) is a pair using same dot but different line

%Run simulation for static and rayleigh channels
statesStatic=genCurveData(FRIIS, NONFADING, THEORY_MODEL, bitRate, THERMAL_NOISE, 'dbm', antennaH, txPower, 'dbm', RX_THRESHES(bitRate), 'dbm', csThresh, 'dbm', SNR_THRESHES(bitRate), 'db', pktNum, pktLen, x_t, x_r, x_iVec);
statesRayleigh=genCurveData(FRIIS, RAYLEIGH, THEORY_MODEL, bitRate, THERMAL_NOISE, 'dbm', antennaH, txPower, 'dbm', RX_THRESHES(bitRate), 'dbm', csThresh, 'dbm', SNR_THRESHES(bitRate), 'db', pktNum, pktLen, x_t, x_r, x_iVec);

%plot(XS, statesStatic(:,1), '*');

%Plot 4 states for static and rayleigh channels 
figure();
plot(XS, statesStatic(:,1), cell2mat(markers4S(1))); hold on;
plot(XS, statesStatic(:,2), cell2mat(markers4S(2))); hold on;
plot(XS, statesStatic(:,3), cell2mat(markers4S(3))); hold on;
plot(XS, statesStatic(:,4), cell2mat(markers4S(4))); hold on;
plot(XS, statesRayleigh(:,1), cell2mat(markers4S(5))); hold on;
plot(XS, statesRayleigh(:,2), cell2mat(markers4S(6))); hold on;
plot(XS, statesRayleigh(:,3), cell2mat(markers4S(7))); hold on;
plot(XS, statesRayleigh(:,4), cell2mat(markers4S(8))); hold off;
xlabel('x_i/x_r');
ylabel('prob.');
ylim([0,1]);
switch bitRate
    case RATE_1
        legend('Static,1M:Idle,Suc', 'Static,1M:Idle,Fail', 'Static,1M:Busy,Suc', 'Static,1M:Busy,Fail','Rayleigh,1M:Idle,Suc', 'Rayleigh,1M:Idle,Fail', 'Rayleigh,1M:Busy,Suc', 'Rayleigh,1M:Busy,Fail');
    case RATE_2
        legend('Static,2M:Idle,Suc', 'Static,2M:Idle,Fail', 'Static,2M:Busy,Suc', 'Static,2M:Busy,Fail','Rayleigh,2M:Idle,Suc', 'Rayleigh,2M:Idle,Fail', 'Rayleigh,2M:Busy,Suc', 'Rayleigh,2M:Busy,Fail');
    case RATE_5_5
        legend('Static,5.5M:Idle,Suc', 'Static,5.5M:Idle,Fail', 'Static,5.5M:Busy,Suc', 'Static,5.5M:Busy,Fail','Rayleigh,5.5M:Idle,Suc', 'Rayleigh,5.5M:Idle,Fail', 'Rayleigh,5.5M:Busy,Suc', 'Rayleigh,5.5M:Busy,Fail');
    case RATE_11
        legend('Static,11M:Idle,Suc', 'Static,11M:Idle,Fail', 'Static,11M:Busy,Suc', 'Static,11M:Busy,Fail','Rayleigh,11M:Idle,Suc', 'Rayleigh,11M:Idle,Fail', 'Rayleigh,11M:Busy,Suc', 'Rayleigh,11M:Busy,Fail');
end

%Plot 2 states for static and rayleigh channels 
figure();
plot(XS, statesStatic(:,1)+statesStatic(:,2), cell2mat(markers2S(1))); hold on;
plot(XS, statesStatic(:,1)+statesStatic(:,3), cell2mat(markers2S(2))); hold on;
plot(XS, statesRayleigh(:,1)+statesRayleigh(:,2), cell2mat(markers2S(3))); hold on;
plot(XS, statesRayleigh(:,1)+statesRayleigh(:,3), cell2mat(markers2S(4))); hold off;
xlabel('x_i/x_r');
ylabel('prob.');
ylim([0,1]);
switch bitRate
    case RATE_1
        legend('Static,1M:Idle', 'Static,1M:Succ', 'Rayleigh,1M:Idle', 'Rayleigh,1M:Succ');
    case RATE_2
        legend('Static,2M:Idle', 'Static,2M:Succ', 'Rayleigh,2M:Idle', 'Rayleigh,2M:Succ');
    case RATE_5_5
        legend('Static,5.5M:Idle', 'Static,5.5M:Succ', 'Rayleigh,5.5M:Idle', 'Rayleigh,5.5M:Succ');
    case RATE_11
        legend('Static,11M:Idle', 'Static,11M:Succ', 'Rayleigh,11M:Idle', 'Rayleigh,11M:Succ');
end
