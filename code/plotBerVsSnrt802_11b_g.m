%Function plotBerVsSnrt802_11b_g: plot for 802.11 b & g's 1M, 2M, 5.5M, 11M the average packet success ratio as x_i
%(interferer's location) varies when x_r (transmission distance) is fixed
%comparing the BER versus SIRT reception model simulations, without considering carrier sensing.
function plotBerVsSnrt802_11b_g()
%set simulation parameters
constants; %constants.m
alpha=6;
XS=[1:0.1:5];%X axis in range of d_ir in terms of multiple d_tr

%set the channel model (can be adjusted)
rxModels=[BER_MODEL, SNRT_MODEL];

%set the topology
x_t=0; %distance from the origin
x_r=10; %can be adjusted, x_r=50 will cause interference to be smaller than thermal noise.
d_tr=abs(x_r-x_t);
x_iVec=XS*d_tr;

% Eight curves: same dot, different lines for a pair of curves
markers={'o-r', 'o-.r', 's-g' , 's-.g', '^-b' , '^-.b', 'v-k' , 'v-.k'};%, '-.^', '-.v', '-o', '-s'];
i=1; 
for br=STA_802_11b_g_RATE_1M:STA_802_11b_g_RATE_11M
        for rxIter=1:length(rxModels)
            y=genCurveData(GENERAL_PATH_LOSS, alpha, NONFADING, NAKAGAMI_M, rxModels(rxIter), br, THERMAL_NOISE, 'dbm', ANTENNA_HEIGHT, TX_POWER, 'dbm', RX_THRESHES(br), 'dbm', INF_CS_THRESH, 'mW', SNR_THRESHES(br), 'db', PKT_NUM, PKT_LEN, x_t, x_r, x_iVec);
            plot(XS, y(:,1), cell2mat(markers(i)));
            hold on;
            i=i+1;
        end
end

hold off;
xlabel('x_I/x_R');
ylabel('p_{suc}');
ylim([0,1]);
legend('Static, b/g 1M, BER', 'Static, b/g 1M, SNRT', 'Static, b/g 2M, BER', 'Static, b/g 2M, SNRT', 'Static, b/g 5.5M, BER', 'Static, b/g 5.5M, SNRT', 'Static, b/g 11M, BER', 'Static, b/g 11M, SNRT');%add legend finally
