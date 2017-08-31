%Function friisRange: calculating the tx range for the given transmission power and reception threshold power under Friis path-loss model.
%Parameters: txPower is the transmission power in dBm or mW, unitTx is the unit of txPower in 'mw' or 'dbm', rxThresh is the reception sensitivity or threshold in dBm or mW, unitRxTh is the unit of rxThresh in 'mw' or 'dbm'
%Returned value: the transmission range
function y=friisRange(txPower, unitTx, rxThresh, unitRxTh)
%convert unit
if strcmpi(unitTx, 'dbm')
    txPower=10^(txPower/10); %to mW
elseif strcmpi(unitTx, 'mw')
else
    errorExit('Error using friisRange: the unit of txPower must be ''dbm'' or ''mw''.');
end
%convert unit
if strcmpi(unitRxTh, 'dbm')
    rxThresh=10^(rxThresh/10); %to mW
elseif strcmpi(unitRxTh, 'mw')
else
    errorExit('Error using friisRange: the unit of rxThresh must be ''dbm'' or ''mw''.');    
end
txGain=1;
rxGain=1;
freq=2.4*10^9; %for 802.11b
c=3.0*10^8;
waveLen=c/freq;
PI=3.1415926;
propLoss=1;
y=(txPower*txGain*rxGain*waveLen^2/(16*PI^2*rxThresh*propLoss))^0.5;