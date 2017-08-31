%% A simple simulation of the effect of fading duration of k bits on packet success ratio. 

n=1024; %bits
m=10000; %sample size
a_min=0.999;
a=a_min+rand(1,m)*(1-a_min); %bit error rates for different SNRs (sample)
k=n; %bits for fading duration, typically k=1, n/2, n

%simulate average frame error rate
ks=[1,n/2,n];
for i=1:length(ks)
    k=ks(i);
    fprintf('k=%f, p_suc=%f\n', k, (sum(a.^k)/m)^(n/k));
end