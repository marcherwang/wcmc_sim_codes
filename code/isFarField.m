%Function isFarField: judging whether d is in the far field, which a validity condition of the Friis model. 
%Parameters: d is the distance in meters between the transmiter and receiver
%Returned value: y is the average receive power.
%Note: In the computation, dim is the max antenna dimension, set to 0.5 tentatively, and we use 5 times to denote "much larger than". 
function y=isFarField(d)
dim=0.5; %note: max antenna dimension, set to 0.5 tentatively
freq=2.4*10^9; %for 802.11b
c=3.0*10^8;
waveLen=c/freq;
dF=2*dim^2/waveLen; % Fraunhoffer region
if d>=5*dF & dF>=5*waveLen & dF>=5*dim %note: here we use 5 times to denote "much larger than" 
    y=true;
else
    y=false;
end
    


