%Function: generating a random reception power by the Nakagami-m multipath fading model
%Parameters: meanPower is the meanPower reception power calculated by a large-scale propagation model; m is the fading depth parameter (smaller m meanPowers more severe fading); unitMeanPower is 'mW' or 'dBm' for the input power, unitOut is 'mW' or 'dBm' for the output power;  
%Returned value: y is the randomly generated reception power considering the Rayleigh model 
%Note: If signal envelop follows Nakagami-m distribution, signal power(square of signal envelop) follows Gamma distribution. 
function y=nakagamiFading(meanPower, unitMeanPower, m, unitOut)
%convert unit
if strcmpi(unitMeanPower, 'dbm')
	meanPower=10^(meanPower/10); % mili watt
elseif strcmpi(unitMeanPower, 'mw')
else
    errorExit('Error using nakagamiFading: the unit of meanPower must be ''dbm'' or ''mw''.');    
end
y=gamrnd(m, meanPower/m); %k is m, theta is omega/m. omega is meanPower power.
%convert unit
if strcmpi(unitOut, 'dbm')
	y=10*log10(y); % mili watt
elseif strcmpi(unitOut, 'mw')
else
    errorExit('Error using nakagamiFading: the unit of returned value of reception power must be ''dbm'' or ''mw''.');        
end