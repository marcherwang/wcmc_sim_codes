%Function friisPower: caculating the large-scale average receive power in dBm by the Friis (free space) model (note: we call it "average" is because shadowing or multipath fading are not considered).
%Parameters: txPower is the transmit power in dBm or mW, d is the distance between the transmiter and receiver, unitIn is 'mW' or 'dBm' for the input power, unitOut is 'mW' or 'dBm' for the output power.
%Returned value: y is the average reception power.
function y=friis(txPower, unitIn, d, unitOut) 
%convert unit
if strcmpi(unitIn, 'dbm')
    txPower=10^(txPower/10); %to mW
elseif strcmpi(unitIn, 'mw')
else
    errorExit('Error using friis: the unit of txPower must be ''dbm'' or ''mw''.');
end
txGain=1;
rxGain=1;
freq=2.4*10^9; %for 802.11b
c=3.0*10^8;
waveLen=c/freq;
PI=3.1415926;
propLoss=1;
y=min(txPower*txGain*rxGain*waveLen^2/(16*PI^2*d^2*propLoss), txPower);
%convert unit
if strcmpi(unitOut, 'dbm')
    y=10*log10(y); %dbm
elseif strcmpi(unitOut, 'mw')
else
    errorExit('Error using friis: the unit of the returned value of average reception power must be ''dbm'' or ''mw''.');
end