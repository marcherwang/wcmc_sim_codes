%Function plotStaticVsRayleighWoCs: plotting average packet success ratio as d_i (interference distance) varies when d_r (transmission distance) is fixed comparing the static versus Rayleigh fading channel simulations, without considering carrier sensing.
function plotStaticVsRayleighWoCs()
constants; %constants.m
alpha=6;
%%Running configuration
XS=[1:0.1:5];%X axis in range of d_ir in terms of multiple d_tr

%set the topology
x_t=0; %distance from the origin
x_r=10; %can be adjusted, x_r=50 will cause interference to be smaller than thermal noise.
d_tr=abs(x_r-x_t);
x_iVec=XS*d_tr;

%set the channel model (can be adjusted)
fadingModels=[NONFADING, RAYLEIGH];

% Eight curves: one dot, one line for a pair of curves (often used to compare experimental dots and theoretical lines)
markers={'o-r', 'o-.r', 's-g' , 's-.g', '^-b' , '^-.b', 'v-k' , 'v-.k'};
i=1;
for br=STA_802_11b_g_RATE_1M:STA_802_11b_g_RATE_11M
    for fadingIter=1:length(fadingModels);
        y=genCurveData(GENERAL_PATH_LOSS, alpha, fadingModels(fadingIter), 1, BER_MODEL, br, THERMAL_NOISE, 'dbm', ANTENNA_HEIGHT, TX_POWER, 'dbm', RX_THRESHES(br), 'dbm', INF_CS_THRESH, 'mW', SNR_THRESHES(br), 'db', PKT_NUM, PKT_LEN, x_t, x_r, x_iVec);
        plot(XS, y(:,1), cell2mat(markers(i)));
        hold on;
        i=i+1;
    end    
end

hold off;
xlabel('x_I/x_R');
ylabel('p_{suc}');
ylim([0,1]);
legend('Static, b/g 1M, BER', 'Rayleigh, b/g 1M, BER', 'Static, b/g 2M, BER', 'Rayleigh, b/g 2M, BER','Static, b/g 5.5M, BER', 'Rayleigh, b/g 5.5M, BER','Static, b/g 11M, BER', 'Rayleigh, b/g 11M, BER');%add legend finally
% if fadingType==RAYLEIGH
%     legend('Rayleigh, a/g 6M, BER', 'Rayleigh, a/g 6M, Theory','Rayleigh, a/g 9M, BER', 'Rayleigh, a/g 9M, Theory','Rayleigh, a/g 12M, BER', 'Rayleigh, a/g 12M, Theory', 'Rayleigh, a/g 18M, BER', 'Rayleigh, a/g 18M, Theory','Rayleigh, a/g 24M, BER', 'Rayleigh, a/g 24M, Theory','Rayleigh, a/g 36M, BER', 'Rayleigh, a/g 36M, Theory','Rayleigh, a/g 48M, BER', 'Rayleigh, a/g 48M, Theory','Rayleigh, a/g 54M, BER', 'Rayleigh, a/g 54M, Theory');
% elseif fadingType==NAKAGAMI
%     legend(strcat('Nakagami-',num2str(nakagamiM),', a/g 6M, BER'), strcat('Nakagami-',num2str(nakagamiM),', a/g 6M, Theory'), strcat('Nakagami-',num2str(nakagamiM),', a/g 9M, BER'), strcat('Nakagami-',num2str(nakagamiM),', a/g 9M, Theory'), strcat('Nakagami-',num2str(nakagamiM),', a/g 12M, BER'), strcat('Nakagami-',num2str(nakagamiM),', a/g 12M, Theory'), strcat('Nakagami-',num2str(nakagamiM),', a/g 18M, BER'), strcat('Nakagami-',num2str(nakagamiM),', a/g 18M, Theory'), strcat('Nakagami-',num2str(nakagamiM),', a/g 24M, BER'), strcat('Nakagami-',num2str(nakagamiM),', a/g 24M, Theory'), strcat('Nakagami-',num2str(nakagamiM),', a/g 36M, BER'), strcat('Nakagami-',num2str(nakagamiM),', a/g 36M, Theory'), strcat('Nakagami-',num2str(nakagamiM),', a/g 48M, BER'), strcat('Nakagami-',num2str(nakagamiM),', a/g 48M, Theory'), strcat('Nakagami-',num2str(nakagamiM),', a/g 54M, BER'), strcat('Nakagami-',num2str(nakagamiM),', a/g 54M, Theory'));
% elseif fadingType==WEIBULL
% else
% end