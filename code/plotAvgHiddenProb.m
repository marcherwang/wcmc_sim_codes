%Function plotAvgHiddenProb calculate the average sensing accuracy from DB
%Parameters: bitRate; k_max, the max ratio of radius of interferer from the
%origin to the link distance
%Returned Value: null.
function plotAvgHiddenProb(bitRate, k_max, standardName)
close all;
constants;
%set the topology
x_t=0; %distance from the origin
x_r=10; %can be adjusted, x_r=50 will cause interference to be smaller than thermal noise.
d_tr=abs(x_r-x_t);
maxRi=k_max*d_tr;

%set the channel model (can be adjusted)
fadingModels=[NONFADING, NAKAGAMI]; %RAYLEIGH is taken as nakagami-1
nakagamiMs=[0.5, 1, 2, 5];%-1 represents "invalid" for the static channel
csThreshes=[-100:4:-20];
accuracy_cst_static=-1*ones(length(csThreshes),1); %initialize to -1 for checking whether there is a non-set value by simulation
accuracy_cst_nakaM=-1*ones(length(csThreshes), length(nakagamiMs));

conn=database('wifi_test_bg11m.db','','','org.sqlite.JDBC','jdbc:sqlite:D:/wifi_test_bg11m.db');
ping(conn);

for cstIter=1:length(csThreshes) %different cs thresholds
    for fadingIter=1:length(fadingModels) %different fading models
        
        cst=csThreshes(cstIter);
        fadingModel=fadingModels(fadingIter);
        
        if fadingModels(fadingIter)==NONFADING
            curs= exec(conn, ['select avg(idleFailProb) from wifi_test_tbl where bit_rate='  num2str(bitRate)  ' and fading='  num2str(fadingModel)  ' and cs_thresh=' num2str(cst)  ' and r_i >=0 and r_i<='  num2str(maxRi)]);
            curs = fetch(curs);
            data=curs.Data;
            accuracy_cst_static(cstIter)=cell2mat(data(1));
            %accuracy_cst_static(cstIter)=data(1);
            
        elseif fadingModels(fadingIter)==NAKAGAMI

            for nakaIter=1:length(nakagamiMs) %different m's for Nakagami fading 
                nakaM=nakagamiMs(nakaIter);
                curs= exec(conn, ['select avg(idleFailProb) from wifi_test_tbl where bit_rate='  num2str(bitRate)  ' and fading='  num2str(fadingModel)    ' and nakagami_m='  num2str(nakaM)  ' and cs_thresh=' num2str(cst)  ' and r_i >=0 and r_i<='  num2str(maxRi)]);
                curs = fetch(curs);
                data=curs.Data;
                accuracy_cst_nakaM(cstIter, nakaIter)=cell2mat(data(1));
                %accuracy_cst_nakaM(cstIter, nakaIter)=data(1);
            end
            
        else
            disp('Error: No such fading model!');
        end
        
    end %different fading models
end %different cs thresholds


%plot
plot(csThreshes, accuracy_cst_static, '*-k');
hold on;

markers=char('^-', 'v-', 's-', 'o-');
for nakaIter=1:length(nakagamiMs)
    plot(csThreshes, accuracy_cst_nakaM(:,nakaIter), markers(nakaIter,:));
    hold on;
end    

bitRateName=STA_802_11_RATE_NAMES(bitRate,:);
xlabel('CST (dBm)');
ylabel('(Idle, Fail) Probability');
legend(['Static, ' standardName ' ' bitRateName], ['Nakagami-0.5, ' standardName ' ' bitRateName], ['Rayleigh, ' standardName ' ' bitRateName], ['Nakagami-2, ' standardName ' ' bitRateName], ['Nakagami-5, ' standardName ' ' bitRateName]);
title(['k_{max}=' num2str(k_max)]);