%Function plotFadingVsTheoryWoCs802_11n: plotting average packet success ratio
%as d_i (interference distance) varies when d_r (transmission distance) is
%fixed comparing a channel simulation and the theoretical result,
%without considering carrier sensing. 
function plotFadingVsTheoryWoCs802_11n(fadingType, nakagamiM)
constants; %constants.m
%%Running configuration
XS=[1:0.2:9];%X axis in range of d_ir in terms of multiple d_tr

%set the topology
x_t=0; %distance from the origin
x_r=10; %can be adjusted, x_r=50 will cause interference to be smaller than thermal noise.
d_tr=abs(x_r-x_t);
x_iVec=XS*d_tr;

%set the channel model (can be adjusted)
rxModels=[BER_MODEL, THEORY_MODEL];

% Eight curves: one dot, one line for a pair of curves (often used to compare experimental dots and theoretical lines)
markers={'or', '-r', 'sg' , '-g', '^b' , '-b', 'vk' , '-k', '+r', '-r', 'dg' , '-g', '>b' , '-b', '<k' , '-k'};
i=1;
for br=STA_802_11n_20M_RATE_6_5M:STA_802_11n_20M_RATE_65M
        for rxIter=1:length(rxModels)
            y=genCurveData(GENERAL_PATH_LOSS, 3, fadingType, nakagamiM, rxModels(rxIter), br, THERMAL_NOISE, 'dbm', ANTENNA_HEIGHT, TX_POWER, 'dbm', RX_THRESHES(br), 'dbm', INF_CS_THRESH, 'mW', SNR_THRESHES(br), 'db', PKT_NUM, PKT_LEN, x_t, x_r, x_iVec);
            plot(XS, y(:,1), cell2mat(markers(i)));
            hold on;
            i=i+1;
        end
end

hold off;
xlabel('x_i/x_r');
ylabel('p_{suc}');
ylim([0,1]);
if fadingType==RAYLEIGH
    legend('Rayleigh, n 6.5M, BER', 'Rayleigh, n 6.5M, Theory','Rayleigh, n 13M, BER', 'Rayleigh, n 13M, Theory','Rayleigh, n 19.5M, BER', 'Rayleigh, n 19.5M, Theory', 'Rayleigh, n 26M, BER', 'Rayleigh, n 26M, Theory','Rayleigh, n 39M, BER', 'Rayleigh, n 39M, Theory','Rayleigh, n 52M, BER', 'Rayleigh, n 52M, Theory','Rayleigh, n 58.5M, BER', 'Rayleigh, n 58.5M, Theory','Rayleigh, n 65M, BER', 'Rayleigh, n 65M, Theory');
elseif fadingType==NAKAGAMI
    legend(strcat('Nakagami-',num2str(nakagamiM),', n 6.5M, BER'), strcat('Nakagami-',num2str(nakagamiM),', n 6.5M, Theory'), strcat('Nakagami-',num2str(nakagamiM),', n 13M, BER'), strcat('Nakagami-',num2str(nakagamiM),', n 13M, Theory'), strcat('Nakagami-',num2str(nakagamiM),', n 19.5M, BER'), strcat('Nakagami-',num2str(nakagamiM),', n 19.5M, Theory'), strcat('Nakagami-',num2str(nakagamiM),', n 26M, BER'), strcat('Nakagami-',num2str(nakagamiM),', n 26M, Theory'), strcat('Nakagami-',num2str(nakagamiM),', n 39M, BER'), strcat('Nakagami-',num2str(nakagamiM),', n 39M, Theory'), strcat('Nakagami-',num2str(nakagamiM),', n 52M, BER'), strcat('Nakagami-',num2str(nakagamiM),', n 52M, Theory'), strcat('Nakagami-',num2str(nakagamiM),', n 58.5M, BER'), strcat('Nakagami-',num2str(nakagamiM),', n 58.5M, Theory'), strcat('Nakagami-',num2str(nakagamiM),', n 65M, BER'), strcat('Nakagami-',num2str(nakagamiM),', n 65M, Theory'));
elseif fadingType==WEIBULL
else
end