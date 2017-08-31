%Function generalPathLoss: calculating the large-scale average receive power in dBm by a general path loss model.
%
%Parameters: p0 is the reference receive power at d0, unit_p0 is p0's unit ('dbm' or 'mw'), d0 is the reference distance, d is the distance to be evaluated; alpha is the path-loss exponent; unit_out is  the unit of the function value (receive power to be calculated).
%
%Returned value: y is the average reception power at d.
%(note): p0 can be in some unit (i.e., 'unitOne') and unit_out must be in 'unitOne' here. 
function y=generalPathLoss(p0, unit_p0, d0, d, alpha, unit_out)
%convert unit
if strcmpi(unit_p0, 'dbm')
    p0=db2Origin(p0); %to mW
elseif strcmpi(unit_p0, 'mw') | strcmpi(unit_p0, 'unitOne')
else
    errorExit('Error using generalPathLoss: the unit of p0 must be ''dbm'' or ''mw''.');
end

p=p0*(d0/d)^alpha;

if strcmpi(unit_out, 'dbm')
    y=origin2dB(p);
elseif strcmpi(unit_out, 'mw') | strcmpi(unit_out, 'unitOne')
    y=p;
else
    errorExit('Error using generalPathLoss: the unit of the function value (receive power to be calculated) must be ''dbm'' or ''mw''.');
end