%Function plotCurve: plot a curve on the figure fig
%Parameters: fig, the figure object; x, a point vector on x axes; y, a point vector on y axes; marker 
%Returned value: none
function plotCurve(fig,x,y,marker)
plot(x,y,marker);
hold on; %do not alter existing plots on fig