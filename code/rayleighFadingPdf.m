%Function: caculate the probalility density distribution of x by the Rayleigh fading distribution
%Parameters: pr is the power to evaluate,  unitPr is the unit of pr in 'dbm' or 'mw', meanPr is the mean recpetion power calculated by a large-scale propagation model (such as Frris, Two ray ground, log normal shadowing, etc.), unitPrMean is the unit of pr in 'dbm' or 'mw'
%Returned value: the probalility density distribution at the power pr 
function y=rayleighFadingPdf(pr, unitPr, meanPr, unitMeanPr)
%convert unit
if strcmpi(unitPr, 'dbm')
    pr=10^(pr/10); %mW
elseif strcmpi(unitPr, 'mw')
else
    errorExit('Error using rayleighFadingPdf: the unit of pr must be ''dbm'' or ''mw''.');
end
%convert unit
if strcmpi(unitMeanPr, 'dbm')
    meanPr=10^(meanPr/10); %mW
elseif strcmpi(unitPr, 'mw')
else
    errorExit('Error using rayleighFadingPdf: the unit of meanPr must be ''dbm'' or ''mw''.');
end
y=(1/meanPr)*exp(-pr/meanPr);