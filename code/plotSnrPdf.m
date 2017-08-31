maxBeta=10; %alpha=3
snrThreshes=[-4.8000   -0.3800    4.6200   8.6200]; %dBm
snrThreshes=db2Origin(snrThreshes); %ratio

betas=[0:0.1:maxBeta];
ys=zeros(length(betas),1);

for i=1:length(betas)
    ys(i)=rayleighSnrPdf(2.5^3, 'ratio', betas(i), 'ratio');
end

plot(betas,ys, '-r');
hold on;

markers={'-','--', '-.', ':'};
for i=1:4
    x=[snrThreshes(i),snrThreshes(i)];
    y=[0,0.1];
    plot(x,y,cell2mat(markers(i)));
    hold on;
end


xlabel('\beta');
ylabel('PDF');
legend('PDF of SIR \it B', '1M SNR Threshold', '2M SNR Threshold', '5.5M SNR Threshold', '11M SNR Threshold');
