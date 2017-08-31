%Function plotNakagamiTheoryWoCs802_11b_11M: plotting average packet success ratio
%as d_i (interference distance) varies when d_r (transmission distance) is
%fixed comparing different Nakagami-m theoretical curves.

function plotNakagamiTheoryWoCs802_11b_11M()
constants; %constants.m
%%Running configuration
XS=[1:0.2:6];%X axis in range of d_ir in terms of multiple d_tr

%set the topology
x_t=0; %distance from the origin
x_r=10; %can be adjusted, x_r=50 will cause interference to be smaller than thermal noise.
d_tr=abs(x_r-x_t);
x_iVec=XS*d_tr;

%set the channel model (can be adjusted)
%rxModels=[BER_MODEL, THEORY_MODEL];
br=STA_802_11b_g_RATE_11M;
nakagamiMs=[0.5, 1, 2, 5];

% Eight curves: one dot, one line for a pair of curves (often used to compare experimental dots and theoretical lines)
%markers={'*-b', '*-b', 'd-b', 'd-b', '+-b', '+-b', '.-b', '.-b'};
markers={':', '-.', '--', '-'};

%plot p_suc vs x_I/x_R
figure(1);
for i=1:length(nakagamiMs)
    nakagamiM=nakagamiMs(i);
    y=genCurveData(GENERAL_PATH_LOSS, 3, NAKAGAMI, nakagamiM, THEORY_MODEL, br, THERMAL_NOISE, 'dbm', ANTENNA_HEIGHT, TX_POWER, 'dbm', RX_THRESHES(br), 'dbm', INF_CS_THRESH, 'mW', SNR_THRESHES(br), 'db', PKT_NUM, PKT_LEN, x_t, x_r, x_iVec);
    plot(XS/d_tr, y(:,1), cell2mat(markers(i)));
    hold on;
end
hold off;
xlabel('x_I/x_R');
ylabel('p_{suc}');
xlim([0,2]);
ylim([0,1]);
legend(strcat('Nakagami-',num2str(nakagamiMs(1)),', b/g 11M, Theory'), strcat('Nakagami-',num2str(nakagamiMs(2)),'(Rayleigh), b/g 11M, Theory'), strcat('Nakagami-',num2str(nakagamiMs(3)),', b/g 11M, Theory'), strcat('Nakagami-',num2str(nakagamiMs(4)),', b/g 11M, Theory'));

%plot p_fail vs x_I (r_I)
figure(2);
for i=1:length(nakagamiMs)
    nakagamiM=nakagamiMs(i);
    nakagamiM
    y=genCurveData(GENERAL_PATH_LOSS, 3, NAKAGAMI, nakagamiM, THEORY_MODEL, br, THERMAL_NOISE, 'dbm', ANTENNA_HEIGHT, TX_POWER, 'dbm', RX_THRESHES(br), 'dbm', INF_CS_THRESH, 'mW', SNR_THRESHES(br), 'db', PKT_NUM, PKT_LEN, x_t, x_r, x_iVec);
    plot(y(:,2), (XS-1), cell2mat(markers(i)));%plot p_fail
    XS-1
    y(:,2)'
    hold on;
end
hold off;
xlabel('p_{fail}');
ylabel('r_I (x d_{TR})');
xlim([0,1]);
ylim([0,5]);
%set(gca,'YTick',[0:x_r:9*x_r]); 
%set(gca,'YTickLabel',{'0','d_R','2d_R','3d_R','4d_R','5d_R'}); %设置每个刻度的标签为A, B, C
legend(strcat('Nakagami-',num2str(nakagamiMs(1)),', b/g 11M, Theory'), strcat('Nakagami-',num2str(nakagamiMs(2)),'(Rayleigh), b/g 11M, Theory'), strcat('Nakagami-',num2str(nakagamiMs(3)),', b/g 11M, Theory'), strcat('Nakagami-',num2str(nakagamiMs(4)),', b/g 11M, Theory'));