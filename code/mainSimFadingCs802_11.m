%Function mainSimFadingCs802_11(): simulate static and fading channels with carrier sensing for all scenarios and store the data into DB. 
function mainSimFadingCs802_11()
constants; %constants.m
%%Running configuration
XS=[0:0.2:10];%X axis in range of d_ir in terms of multiple d_tr

%set the topology
x_t=0; %distance from the origin
x_r=10; %can be adjusted, x_r=50 will cause interference to be smaller than thermal noise.
d_tr=abs(x_r-x_t);
%the (x,y) coordinate of interferer is generated from r_i and theta_i
r_iVec=XS*d_tr; % take the postive part of XS
theta_iVec=[0:pi/12:11/12*pi];

%set the channel model (can be adjusted)
fadingModels=[NONFADING, NAKAGAMI]; %RAYLEIGH is taken as nakagami-1
nakagamiMs=[0.5, 1, 2, 5]; %-1 represents "invalid" for the static channel
csThreshes=[-100:4:-20];

%create a database at D:/wifi_test.db
conn=database('wifi_test.db','','','org.sqlite.JDBC','jdbc:sqlite:D:/wifi_test.db');
ping(conn);
curs= exec(conn, 'create table if not exists wifi_test_tbl(path_loss int, alpha double, fading int, nakagami_m double, rx_model int, bit_rate int, thermal_noise double, antenna_height double, tx_power double, rx_thresh double, cs_thresh double, snr_thresh double, pkt_num int, pkt_len int, x_t double, x_r double, r_i double, theta_i double, idleSuccProb double, idleFailProb double, busySuccProb double, busyFailProb double)');

for br=STA_802_11n_20M_RATE_6_5M:STA_802_11n_20M_RATE_65M %different rates
    for fadingIter=1:length(fadingModels) %different fading models
        for cstIter=1:length(csThreshes) %different cs thresholds
            if fadingModels(fadingIter)==NAKAGAMI
                %***copy code*** (start)
                for nakaIter=1:length(nakagamiMs) %different m's for Nakagami fading                     
                    for k=1:length(r_iVec)
                        for j=1:length(theta_iVec)
                            x_i=r_iVec(k)*cos(theta_iVec(j));
                            y_i=r_iVec(k)*sin(theta_iVec(j));
                            d_ri=sqrt((x_r-x_i)^2+(0-y_i)^2);
                            d_ti=sqrt((x_t-x_i)^2+(0-y_i)^2);
                            states=linkBerPerf(GENERAL_PATH_LOSS, PATH_LOSS_EXPONENT, fadingModels(fadingIter), nakagamiMs(nakaIter), THERMAL_NOISE, 'dbm', br, ANTENNA_HEIGHT, TX_POWER, 'dbm', RX_THRESHES(br), 'dbm', csThreshes(cstIter), 'dbm', PKT_NUM, PKT_LEN, d_tr, d_ri, d_ti);
                            curs= exec(conn, ['insert into wifi_test_tbl values('  num2str(GENERAL_PATH_LOSS)  ','  num2str(PATH_LOSS_EXPONENT) ',' num2str(fadingModels(fadingIter)) ',' num2str(nakagamiMs(nakaIter)) ',' num2str(BER_MODEL) ',' num2str(br) ',' num2str(THERMAL_NOISE) ',' num2str(ANTENNA_HEIGHT) ',' num2str(TX_POWER) ',' num2str(RX_THRESHES(br)) ',' num2str(csThreshes(cstIter)) ',' num2str(SNR_THRESHES(br)) ',' num2str(PKT_NUM) ',' num2str(PKT_LEN) ',' num2str(x_t) ',' num2str(x_r) ',' num2str(r_iVec(k)) ',' num2str(theta_iVec(j)) ',' num2str(states(1)) ',' num2str(states(2)) ',' num2str(states(3)) ',' num2str(states(4)) ')']);   
                        end
                    end
                end
                %***copy code*** (end)
            elseif fadingModels(fadingIter)==NONFADING
                %***copy code from above***  nakagamiMs(nakaIter)->0; num2str(fadingModels(fadingIter))->0
                %***copy code*** (start)
                %for nakaIter=1:length(nakagamiMs) %different m's for Nakagami fading                     
                for k=1:length(r_iVec)
                    for j=1:length(theta_iVec)
                        x_i=r_iVec(k)*cos(theta_iVec(j));
                        y_i=r_iVec(k)*sin(theta_iVec(j));
                        d_ri=sqrt((x_r-x_i)^2+(0-y_i)^2);
                        d_ti=sqrt((x_t-x_i)^2+(0-y_i)^2);
                        states=linkBerPerf(GENERAL_PATH_LOSS, PATH_LOSS_EXPONENT, fadingModels(fadingIter), 0, THERMAL_NOISE, 'dbm', br, ANTENNA_HEIGHT, TX_POWER, 'dbm', RX_THRESHES(br), 'dbm', csThreshes(cstIter), 'dbm', PKT_NUM, PKT_LEN, d_tr, d_ri, d_ti);
                        curs=exec(conn, ['insert into wifi_test_tbl values('  num2str(GENERAL_PATH_LOSS)  ','  num2str(PATH_LOSS_EXPONENT) ',' num2str(fadingModels(fadingIter)) ',' num2str(-1) ',' num2str(BER_MODEL) ',' num2str(br) ',' num2str(THERMAL_NOISE) ',' num2str(ANTENNA_HEIGHT) ',' num2str(TX_POWER) ',' num2str(RX_THRESHES(br)) ',' num2str(csThreshes(cstIter)) ',' num2str(SNR_THRESHES(br)) ',' num2str(PKT_NUM) ',' num2str(PKT_LEN) ',' num2str(x_t) ',' num2str(x_r) ',' num2str(r_iVec(k)) ',' num2str(theta_iVec(j)) ',' num2str(states(1)) ',' num2str(states(2)) ',' num2str(states(3)) ',' num2str(states(4)) ')']);
                    end
                end
                %end
                %***copy code*** (end)
            else
                disp('Error: No such fading model!');
            end
        end    
    end
end

%test
% br=STA_802_11b_g_RATE_1M;
% y=genCurveData(GENERAL_PATH_LOSS, 3, fadingModels(1), nakagamiMs(1), BER_MODEL, br, THERMAL_NOISE, 'dbm', ANTENNA_HEIGHT, TX_POWER, 'dbm', RX_THRESHES(br), 'dbm', csThreshes(1), 'dbm', SNR_THRESHES(br), 'db', PKT_NUM, PKT_LEN, x_t, x_r, r_iVec)
% for k=1:length(r_iVec)
%     curs= exec(conn, ['insert into wifi_test_tbl values('  num2str(GENERAL_PATH_LOSS)  ','  num2str(3) ',' num2str(fadingModels(1)) ',' num2str(nakagamiMs(1)) ',' num2str(BER_MODEL) ',' num2str(br) ',' num2str(THERMAL_NOISE) ',' num2str(ANTENNA_HEIGHT) ',' num2str(TX_POWER) ',' num2str(RX_THRESHES(br)) ',' num2str(csThreshes(1)) ',' num2str(SNR_THRESHES(br)) ',' num2str(PKT_NUM) ',' num2str(PKT_LEN) ',' num2str(x_t) ',' num2str(x_r) ',' num2str(r_iVec(k)) ',' num2str(0) ',' num2str(0) ',' num2str(0) ',' num2str(0) ')']);
% end

%test
% curs= exec(conn, 'select * from wifi_test_tbl');
% % curssor.fetch returns a curssor object on which you can run many other functions, such as get and rows.
% curs = fetch(curs);
% % curss.Data是一个矩阵，每行是一个记录，每列对应一个字段
% data=curs.Data


%close database
close(conn);
