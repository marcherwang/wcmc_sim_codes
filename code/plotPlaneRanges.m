%Function plotPlaneRanges(): plot the planes of interference ranges and cs ranges

function plotPlaneRanges()
constants; %constants.m
%%Running configuration

XS=[1:0.2:6];%X axis in range of d_ir in terms of multiple d_tr
x_t=0; %distance from the origin
x_r=10; %can be adjusted, x_r=50 will cause interference to be smaller than thermal noise.
d_tr=abs(x_r-x_t);
x_iVec=XS*d_tr;

%%% plot the link
draw_arrow([0,0],[1,0],0.5);
hold on;

%%% plot interference ranges

%m=1
%pfails=[0.9:-0.1:0.1];
%iRanges=([19 25 30 35 40 45 52 62 81]-1)*0.05;
pfails=[0.9:-0.2:0.1];
iRanges=([19  30  40  52  81]-1)*0.05;

text(1,0,'1.0', 'color', 'r');
for i=1:length(pfails)
    plotCircle(1, 0, iRanges(i), 'r');
    text(1+iRanges(i)*cos(pi/4), 0+iRanges(i)*sin(pi/4), num2str(pfails(i)), 'color', 'r');
    hold on;
end

%%% plot cs ranges
%dcs=dtr, m=1
% pbusys=[0.9:-0.2:0.1];
% csRanges=[0.45 0.7 0.9 1.05 1.3];
%dcs=2*dtr, m=1
pbusys=[0.9:-0.2:0.1];
csRanges=[0.95 1.4 1.75 2.1 2.65];

text(0,0,'1.0', 'color', 'b');
for i=1:length(pbusys)
    plotCircle(0, 0, csRanges(i), '--b');
    text(0+csRanges(i)*cos(0.75*pi), 0+csRanges(i)*sin(0.75*pi), num2str(pbusys(i)), 'color', 'b');
    hold on;
end

xlabel('X (x d_{TR})');
ylabel('Y (x d_{TR})');
title('Rayleigh, b/g 11M, r_C^{stat}=2d_{TR}');

