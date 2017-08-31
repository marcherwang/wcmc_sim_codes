%Function plotBerVsSnrt802_11n: plot for 802.11 ns '6.5M', '13M', '19.5M', '26M', '39M', '52M', '58.5M', '65M' the average packet success ratio as x_i
%(interferer's location) varies when x_r (transmission distance) is fixed
%comparing the BER versus SIRT reception model simulations, without considering carrier sensing.
function plotBerVsSnrt802_11n()
%set simulation parameters
constants; %constants.m
XS=[1:0.1:9];%X axis in range of d_ir in terms of multiple d_tr

%set the channel model (can be adjusted)
rxModels=[BER_MODEL, SNRT_MODEL];

%set the topology
x_t=0; %distance from the origin
x_r=10; %can be adjusted, x_r=50 will cause interference to be smaller than thermal noise.
d_tr=abs(x_r-x_t);
x_iVec=XS*d_tr;

% Eight curves: same dot, different lines for a pair of curves
markers={'o-r', 'o-.r', 's-g' , 's-.g', '^-b' , '^-.b', 'v-k' , 'v-.k', '+-r', '+-.r', 'd-g' , 'd-.g', '>-b' , '>-.b', '<-k' , '<-.k'};
i=1;
for br=STA_802_11n_20M_RATE_6_5M:STA_802_11n_20M_RATE_65M
        for rxIter=1:length(rxModels)
            y=genCurveData(GENERAL_PATH_LOSS, 3, NONFADING, NAKAGAMI_M, rxModels(rxIter), br, THERMAL_NOISE, 'dbm', ANTENNA_HEIGHT, TX_POWER, 'dbm', RX_THRESHES(br), 'dbm', INF_CS_THRESH, 'mW', SNR_THRESHES(br), 'db', PKT_NUM, PKT_LEN, x_t, x_r, x_iVec);
            plot(XS, y(:,1), cell2mat(markers(i)));
            hold on;
            i=i+1;
        end
end

hold off;
xlabel('x_i/x_r');
ylabel('p_{suc}');
ylim([0,1]);
legend('Static, n 6.5M, BER', 'Static, n 6.5M, SNRT','Static, n 13M, BER', 'Static, n 13M, SNRT','Static, n 19.5M, BER', 'Static, n 19.5M, SNRT','Static, n 26M, BER', 'Static, n 26M, SNRT','Static, n 39M, BER', 'Static, n 39M, SNRT','Static, n 52M, BER', 'Static, n 52M, SNRT','Static, n 58.5M, BER', 'Static, n 58.5M, SNRT','Static, n 65M, BER', 'Static, n 65M, SNRT');