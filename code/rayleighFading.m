%Function: generating a random reception power by the Rayleigh multipath fading model
%Parameters: mean is the mean reception power calculated by a large-scale propagation model (such as Frris, Two ray ground, log normal shadowing, etc.); ; unitIn is 'mW' or 'dBm' for the input power, unitOut is 'mW' or 'dBm' for the output power. 
%Returned value: y is the randomly generatedly reception power  considering the Rayleigh model 
%Note: If signal envelop follows Rayleigh distribution, signal power(square of signal envelop) follows Exponential distribution. 
function y=rayleighFading(mean, unitIn, unitOut)
%convert unit
if strcmpi(unitIn, 'dbm')
	mean=10^(mean/10); % mili watt
elseif strcmpi(unitIn, 'mw')
else
    errorExit('Error using rayleighFading: the unit of mean must be ''dbm'' or ''mw''.');    
end
y=exprnd(mean);
%convert unit
if strcmpi(unitOut, 'dbm')
	y=10*log10(y); % mili watt
elseif strcmpi(unitOut, 'mw')
else
    errorExit('Error using rayleighFading: the unit of returned value of reception power must be ''dbm'' or ''mw''.');        
end