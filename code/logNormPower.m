%Function logNormPower: calculating the receive power in dBm by the log normal model (for shadowing).
%Parameters: mean is the receive power calculated by a large-scale propagation model (such as Frris, Two ray ground, etc.), stdDev is the standard deviation of the receive power, unitI is input power unit of 'dBm' or 'mW', unitOut is output power unit of 'dBm' or 'mW'.
%Returned value: y is the randomly generated reception power.
 %Note: this model may be used in three ways,
 %(1)generate one receive power value for one transmiter-receiver pair in log normal shadowing
 %(2)white Gaussian noise 
 %(3)generate receive power for one packet or one bit when there is a large number of interferers and the distribution can be approximately Gaussian.
function y=logNormPower(mean, stdDev, unitIn, unitOut)
if strcmpi(unitIn, 'dbm')
elseif strcmpi(unitIn, 'mw') 
	mean=10*log10(mean);%dbm
	stdDev=10*log10(stdDev);%dbm
end

y = normrnd(mean,stdDev);

if strcmpi(unitOut, 'dbm')
elseif  strcmpi(unitOut, 'mw')
	y=10^(y/10);
else
    errorExit('Error using logNormPower: the unit of the returned value of reception power must be ''dbm'' or ''mw''.');    
end
