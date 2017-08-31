%Function: caculating the "average" receive power by the two ray ground model (note: we call it "average" is because shadowing or multipath fading are not considered)
%(note: txHeight and rxHeight is set to 2 tentatively)
%Parameters: txPower is the transmit power; unit is 'mW' or 'dBm'; d is the
%distance between the transmiter and receiver; txHeight is the height of tx
%antenna; rxHeight is the height of rx antenna (0.223 is the default antenna height generating the same rx power as in Friis when d=5m); unitIn is 'mW' or 'dBm' for the input power, unitOut is 'mW' or 'dBm' for the output power.
%Returned value: y is the average receive power
function y=twoRayGround(txPower, unitIn, d, txHeight, rxHeight, unitOut)
txGain=1;
rxGain=1;
propLoss=1;
%convert unit
if strcmpi(unitIn, 'dbm')
	txPower=10^(txPower/10); % mili watt
elseif strcmpi(unitIn, 'mw')
else
    errorExit('Error using twoRayGround: the unit of txPower must be ''dbm'' or ''mw''.');
end

y=txPower*txGain*rxGain*txHeight^2*rxHeight^2/(d^4*propLoss);
%convert unit
if strcmpi(unitOut, 'dbm')
	y=10*log10(y); % dBm
elseif strcmpi(unitOut, 'mw')
else
    errorExit('Error using twoRayGround: the unit of the returned value of reception power must be ''dbm'' or ''mw''.');    
end
