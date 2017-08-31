syms x y xmean ymean m %x: signal power in mW, y: interference power in mW
%m=1; 
beta0=xmean/ymean;
x0=0; %set receive threshold to zero because it is so small
xMax=inf; % it should be infinity in theory, but we can use a large value here (say 200).

f_Y=(m/ymean)^m/gamma(m)*y^(m-1)*exp(-m/ymean*y);
f_X=(m/xmean)^m/gamma(m)*x^(m-1)*exp(-m/xmean*x);
part1=int(f_Y, y, 0, x/beta0);
total=int(part1*f_X, x, x0, xMax)
