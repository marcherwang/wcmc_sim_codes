%function plotCsRange: plot the carrier sense range for a given CS threshold
%parameters: none
%returned value: none.
function plotCsRange()
constants;
close;
%set the topology
x_t=0; %distance from the origin
x_r=10; %can be adjusted, x_r=50 will cause interference to be smaller than thermal noise.
d_tr=abs(x_r-x_t);

%Adjustable parameters
alpha=3;
%csRangeStatic=d_tr; %%%%%%%%%%%%%%%%%%%%
csRangeStatic=2*d_tr;

c0=generalPathLoss(P0, 'dBm', D0, csRangeStatic, alpha, 'mW');

nakaMs=[0.5, 1, 2, 5];
markers={':', '-.', '--', '-'};

curveId=1;
for m=nakaMs % for each m
    csRanges=[0.1*d_tr : 0.05*d_tr : 100*d_tr];
    p_busyVector=zeros(1,length(csRanges));
    
    %Try different CS ranges to match p_busy 
    i=1; %count the real "used" length of csRanges and p_busyVector
    for csRange=csRanges
        cmean=generalPathLoss(P0, 'dBm', D0, csRange, alpha, 'mW');
        %calculate p_busy
        syms c;
        f_C=(m/cmean)^m/gamma(m)*c^(m-1)*exp(-m*c/cmean);
        F_C=int(f_C, c, 0, c0);
        p_busy=1-double(F_C);
        
        %store p_busy
        p_busyVector(i)=p_busy;
        if p_busy<=0.05 %break condition
            break;
        end    

        i=i+1;
    end
    
    %plot a curve
    plot(p_busyVector(1:i), csRanges(1:i)/d_tr, cell2mat(markers(curveId)));
    hold on;
    curveId=curveId+1;
    %output
    m
    p_busyVector(1:i)
    csRanges(1:i)/d_tr
    
end


%test code:
%hold on; 
%plot(p_busyVector(1:i), (-log(p_busyVector(1:i))).^(1/alpha)*d_tr, 'o');

xlabel('p_{busy}');
ylabel('r_{C}  (\times d_{TR})');
%title('r_C^{Stat}=d_{TR}');%%%%%%%%%%%%%%%%%%%%
title('r_C^{Stat}=2d_{TR}');
legend('Nakagami-0.5, Theory', 'Nakagami-1(Rayleigh), Theory', 'Nakagami-2, Theory', 'Nakagami-5, Theory');
