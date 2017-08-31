%%%It is the header file included by other source files and it consists of simulation constants.%%%
%packets
PKT_LEN=256*8;%bits MTU 7981 bytes
PKT_NUM=100; %number of packets to be transmitted
TGT_PSR=0.99; %target packet success ratio, to calculate fading margin (safe rx power)

%Standards
STA_802_11a=1; STA_802_11b=2; STA_802_11g=3; STA_802_11n_20M=4;
STA_NAMES=char('802.11a', '802.11b', '802.11g', '802.11n,20M');
%Standards' Bit rates
STA_802_11a_g_RATE_6M=1; STA_802_11a_g_RATE_9M=2; STA_802_11a_g_RATE_12M=3; STA_802_11a_g_RATE_18M=4; STA_802_11a_g_RATE_24M=5; STA_802_11a_g_RATE_36M=6; STA_802_11a_g_RATE_48M=7; STA_802_11a_g_RATE_54M=8;
STA_802_11b_g_RATE_1M=9; STA_802_11b_g_RATE_2M=10; STA_802_11b_g_RATE_5_5M=11; STA_802_11b_g_RATE_11M=12; %the common rate of 802.11b and g
STA_802_11n_20M_RATE_6_5M=13; STA_802_11n_20M_RATE_13M=14; STA_802_11n_20M_RATE_19_5M=15; STA_802_11n_20M_RATE_26M=16; STA_802_11n_20M_RATE_39M=17; STA_802_11n_20M_RATE_52M=18; STA_802_11n_20M_RATE_58_5M=19; STA_802_11n_20M_RATE_65M=20;
STA_802_11_RATE_NAMES=char('6M', '9M', '12M', '18M', '24M', '36M', '48M', '54M', '1M', '2M', '5.5M', '11M', '6.5M', '13M', '19.5M', '26M', '39M', '52M', '58.5M', '65M');%the common rate of 802.11a and g
%Modulation classes
WIFI_MOD_CLASS_ERP_OFDM=1; WIFI_MOD_CLASS_OFDM=2; WIFI_MOD_CLASS_HT=3; WIFI_MOD_CLASS_DSSS=4;
%Code rates
WIFI_CODE_RATE_1_2=1; WIFI_CODE_RATE_2_3=2; WIFI_CODE_RATE_3_4=3; WIFI_CODE_RATE_5_6=4; WIFI_CODE_RATE_UNDEFINED=5;
%Receive sensitivity of four bit rates
RX_THRESHES=[-84, -84, -84, -84, -83, -81, -76, -75, -89,-89,-89,-86, -86, -85, -84, -82, -78, -74, -72, -71];%dBm, from  Cisco Aironet 1014 series (we use 802.11g, 802.11b and 802.11n at 2.4G, 20MHz )
%Reception models
SNRT_MODEL=1; BER_MODEL=2; THEORY_MODEL=3;
%Reception states
IDLE_SUC=1; IDLE_FAIL=2; BUSY_SUC=3; BUSY_FAIL=4; 
%Path loss models
FRIIS=1; TWO_RAY_GROUND=2; GENERAL_PATH_LOSS=3; 
PATH_LOSS_EXPONENT=3; %path loss exponent "alpha" for the models in PATH_LOSS_NAMES
PATH_LOSS_NAMES=char('Friis', 'Two ray ground', 'General path loss');


%Fading models
NONFADING=1; RAYLEIGH=2; NAKAGAMI=3; WEIBULL=4;
FADING_NAMES=char('No fading', 'Rayleigh', 'Nakagami', 'WeiBull');

%%%The following are simulation parameters subject to change%%%
%powers
TX_POWER=15;%dBm

%For the general path-loss model, P0 is set to the receive power of Friis at D0 meter.
D0=2;%meter
P0=friis(TX_POWER, 'dbm', D0, 'dbm');%dbm
THERMAL_NOISE=-95.6; %dBm
INF_CS_THRESH=1000; %mW, %Infinite CS threshold to shut down carrier sensing
%SNR thresholds for different modulations & rates (*calculated by calcSnrThreshes()), for the SNRT recpetion model, which is the dBs of 50% packet success ratio for four bit rates of 2048 bits 
if PKT_LEN == 256*8
    %SNR thresholds in dB for 256*8 bits:
    SNR_THRESHES=[2.9000    5.7400    5.9100    8.7500   12.3300   15.4300   20.1600   21.3700   -4.8000   -0.3800    4.6200   8.6200    2.9000    5.9100    8.7500   12.3300   15.4300   20.1600   21.3700   21.3700]; %dBm for 256 bytes for STA_802_11a_g_RATE_..., STA_802_11b_g_RATE_..., STA_802_11n_20M_RATE_...; 512bytes的分组的接收阈值：-4.40, 0.09, 5.01, 9.09  
elseif PKT_LEN == 1024*8
    %SNR thresholds in dB for 1024*8 bits:
    SNR_THRESHES=[3.3100    6.1600    6.3200    9.1700   12.7800   15.8800   20.6200   21.8500   -4.0500    0.4800    5.3500 9.4500    3.3100    6.3200    9.1700   12.7800   15.8800   20.6200   21.8500   21.8500];
elseif PKT_LEN == 1500*8
    SNR_THRESHES=[3.4200    6.2800    6.4300    9.2900   12.9100   16.0000   20.7500   21.9800   -3.8600    0.6900    5.5300  9.6300    3.4200    6.4300    9.2900   12.9100   16.0000   20.7500   21.9800   21.9800];
elseif PKT_LEN == 7981*8 % WLAN (802.11)' MTU, from wiki MTU
    SNR_THRESHES=[3.9000    6.7000    6.9000    9.8000   13.4000   16.5000   21.3000   22.5000   -3.2000    1.5000    6.2000 10.0000    3.9000    6.9000    9.8000   13.4000   16.5000   21.3000   22.5000   22.5000];
else
    disp('Error: No such packet length! only support 1KB and 256B now.');       
end
%The latter vs the former in ratio: min 1.10, max 1.22, mean 1.13; in db: min 0.41, max 0.86, mean 0.51.
%fading parameters
NAKAGAMI_M=1; %m is the fading depth parameter for Nakagami fading (smaller m means more severe fading) 
%antenna height
ANTENNA_HEIGHT=2; %(0.223 is the default antenna height in the two ray ground model generating the same rx power as in Friis when d=5m)
