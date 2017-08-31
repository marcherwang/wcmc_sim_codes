%Function twoRayGroundRange: calculating the tx range for the given tx and rx power under Two ray ground path
%   loss model
%Parameters: txPower, the tx power in dBm; rxPower, the rx power in dBm; txHeight, height of tx antenna; rxHeight,
%   height of rx antenna (0.223 is the default antenna height generating the
%   same rx power as in Friis when d=5m)
%Returned value: y, the tx range
function y=twoRayGroundRange(txPower, unitTx, rxPower, unitRx, txHeight, rxHeight)
%convert unit
if strcmpi(unitTx, 'dbm')
	txPower=10^(txPower/10); % mili watt
elseif strcmpi(unitTx, 'mw') 
else
    errorExit('Error using twoRayGroundRange: the unit of txPower must be ''dbm'' or ''mw''.');
end
%convert unit
if strcmpi(unitRx, 'dbm')
	rxPower=10^(rxPower/10); % mili watt
elseif strcmpi(unitRx, 'mw')
else
    errorExit('Error using twoRayGroundRange: the unit of rxPower must be ''dbm'' or ''mw''.');
end
txGain=1;
rxGain=1;
propLoss=1;
y=(txPower*txGain*rxGain*txHeight^2*rxHeight^2/(rxPower*propLoss))^0.25;