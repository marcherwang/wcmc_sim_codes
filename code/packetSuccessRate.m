%function packetSuccessRate: calculate the success rate of a packet transmitted for any modulation scheme at the given SINR.
%parameters: modClass, modulation class; codeRate, code rate; constellationSize, constellation size; dataRate, data rate; sinr, the SINR of a packet; unit (of sinr), which is 'ratio' or 'db'; nbits, the number of bits of a packet.
%returned value: y, packet success rate of the packet.
%(Modified from: NS-3's NistErrorRateModel::GetChunkSuccessRate() method)
function y=packetSuccessRate (modClass, codeRate, constellationSize, dataRate, sinr, unit, nbits)
    constants; %wireless contants
    if modClass==WIFI_MOD_CLASS_ERP_OFDM | modClass==WIFI_MOD_CLASS_OFDM | modClass==WIFI_MOD_CLASS_HT
        if constellationSize==2
            if codeRate == WIFI_CODE_RATE_1_2
                y=fecBpskSuccessRate(sinr, unit, nbits, 1);
                return;
            else
                y=fecBpskSuccessRate(sinr, unit, nbits, 3);
                return;
            end
        elseif constellationSize==4
            if codeRate == WIFI_CODE_RATE_1_2
                y=fecQpskSuccessRate(sinr, unit, nbits, 1);
                return;
            else
                y=fecQpskSuccessRate(sinr, unit, nbits, 3);
                return;
            end
        elseif constellationSize==16
            if codeRate == WIFI_CODE_RATE_1_2
                y=fec16QamSuccessRate (sinr, unit, nbits, 1);
                return;
            else
                y=fec16QamSuccessRate (sinr, unit, nbits, 3);
                return;
            end
        elseif constellationSize==64
            if codeRate==WIFI_CODE_RATE_2_3
              y=fec64QamSuccessRate (sinr, unit, nbits, 2);
              return;
            else
              y=fec64QamSuccessRate (sinr, unit, nbits, 3);
              return;
            end
        else
            y=0;
            errorExit('Error using packetSuccessRate(): no such constellation size!');   
            return;
        end
    elseif modClass == WIFI_MOD_CLASS_DSSS
        switch dataRate
            case STA_802_11b_g_RATE_1M
                y=dsssDbpskSuccessRate(sinr, unit, nbits);
                return;
            case STA_802_11b_g_RATE_2M
                y=dsssDqpskSuccessRate(sinr, unit, nbits);
                return;
            case STA_802_11b_g_RATE_5_5M
                y=dsssDqpskCck5_5SuccessRate(sinr, unit, nbits);
                return;
            case STA_802_11b_g_RATE_11M
                y=dsssDqpskCck11SuccessRate(sinr, unit, nbits);
                return;
            otherwise
                y=0;
                errorExit('Error using packetSuccessRate(): no such data rate in the modulation class of WIFI_MOD_CLASS_DSSS (802.11b)!');  
                return;
        end
    else
        y=0;
        errorExit('Error using packetSuccessRate(): no such modulation class!');   
        return;
    end
