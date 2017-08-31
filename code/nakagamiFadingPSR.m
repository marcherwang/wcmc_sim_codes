%Function nakagamiFadingPSR: calculate the theoretical packet success ratio in Nakagami fading, assuming the SNRT model.
%
%Parameters: avgRxPower, average receive power;  avgInfPower, average
%interference power; unitPower, unit of powers in 'dbm' or 'mw';
%snrThresh, SNR threshold; unitSnr, unit of SNR in 'db' or 'ratio'; m,
%fading depth parameter in the Nakagami model.
%
%Returned value: y is packet success ratio
function y=nakagamiFadingPSR(avgRxPower, avgInfPower, unitPower, snrThresh, unitSnr, m)
%convert unit
if strcmpi(unitPower, 'dbm')
    avgRxPower=10^(avgRxPower/10); %to mW
    avgInfPower=10^(avgInfPower/10); %to mW
elseif strcmpi(unitPower, 'mw') | strcmpi(unitPower, 'ratio')
else
    errorExit('Error using nakagamiFadingPSR: the unit of receive and interference powers must be ''dbm'' or ''mw''.');
end
%
if strcmpi(unitSnr, 'db')
    snrThresh=10^(snrThresh/10); %to ratio
elseif strcmpi(unitSnr, 'ratio')
else
    errorExit('Error using nakagamiFadingPSR: the unit of SNR must be ''db'' or ''ratio''.');
end

syms x y %x: signal power, y: interference power
%m=1; 
xmean=avgRxPower; %X's mean
ymean=avgInfPower; %Y's mean
beta0=snrThresh;
x0=0; %set receive threshold to zero because it is so small
xMax=inf; % it should be infinity in theory, but we can use a large value here (say 200).

f_Y=(m/ymean)^m/gamma(m)*y^(m-1)*exp(-m/ymean*y);
f_X=(m/xmean)^m/gamma(m)*x^(m-1)*exp(-m/xmean*x);
part1=int(f_Y, y, 0, x/beta0);
total=int(part1*f_X, x, x0, xMax); %resort to numerical solution as the indefinite integral consists of besselk functions
y=double(total);