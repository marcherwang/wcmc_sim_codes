%Function dqpskFunction: used for calculating the success decoding rate of a packet for 2Mbps 802.11b
%Parameters: x is EbN0 
%Returned value: y is the function value

function y=dqpskFunction(x)
y=((sqrt (2.0) + 1.0) / sqrt (8.0 * 3.1415926 * sqrt (2.0))) * (1.0 / sqrt (x)) * exp (-(2.0 - sqrt (2.0)) * x); %We adopted the following approximation (equation (8) from [FC04]), see the paper "Validation of ns-3 802.11b PHY model" 
if y>1 %y is infinity when x is 0
    y=1;
end