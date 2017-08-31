%Function plotCircle: plot a circle
function plotCircle(x0, y0, radius, color)
thetas=0:pi/50:2*pi;
xs=x0+radius*cos(thetas);
ys=y0+radius*sin(thetas);
plot(xs,ys, color);
axis square;

