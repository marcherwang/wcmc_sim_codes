%Function: caculating the probalility density function of SNR for rayleigh distribution 
%Parameters: plSnr is the path-loss SNR got by (path-loss signal power/path-loss interference power); unitPlSnr is the unit of plSnr in "db" or "ratio"; x is the SNR where we want to get the prob. density; unitX is the unit of x in "db" or "ratio" 
%Returned value: pdf is the probalility density distribution at x 
function y=rayleighSnrPdf(plSnr, unitPlSnr, x, unitX)
%convert unit
if strcmpi(unitPlSnr, 'db')
	plSnr=10^(plSnr/10); % ratio
elseif strcmpi(unitPlSnr, 'ratio')
else
    errorExit('Error using rayleighSnrPdf: the unit of plSnr must be ''db'' or ''ratio''.');    
end
%convert unit
if strcmpi(unitX, 'db')
	x=10^(x/10); % ratio
elseif strcmpi(unitX, 'ratio')
else
    errorExit('Error using rayleighSnrPdf: the unit of x must be ''db'' or ''ratio''.');       
end
y=1/(plSnr+x^2/plSnr+2*x);

