%EMG Lab: Biodynamics
%part 3:Power Spectrum & Median Frequency
clear
clc
close all

fs=2000;
dt=1/fs;
fc=6;
%load raw data
for n=5:10    
filename=(['trial',num2str(n),'.csv']);   %define your filename according to the file index
temp{n}=csvread(filename);

end 
emg10_raw = temp{1,10};

figure(1)
subplot(2,1,1)
plot(emg10_raw(:,1),emg10_raw(:,2));
title ('Biceps')
subplot(2,1,2)
plot(emg10_raw(:,1),emg10_raw(:,3));
title ('Triceps')

[row,column]=size(emg10_raw);
for i=2:column;
    emg_10(:,i)=emg10_raw(:,i)-(mean(emg10_raw(:,i)));
end
emg10_rect=abs(emg_10); %Rectification: Absolute value
%emg10_rect(:,1)=[];
emg10_env=filter_data(emg10_rect, fc, fs, [2:3]); %Low pass filter:Linear Envelope

figure(2)
subplot(2,1,1)
plot(emg10_raw(:,1),emg10_env(:,2));
title ('Biceps')
subplot(2,1,2)
plot(emg10_raw(:,1),emg10_env(:,3));
title ('Triceps')


% [freq,power] = power_spectrum(emg10_env(2001:3000,2),2000)
% freq=freq';
% figure(7)
% plot(freq,power)

% MF = medianfreq(freq(1:500),power(1:500))
for j = 1:20;
u = 1;
time = emg10_raw(u:u+1999,1);
relNums_bi = emg10_env(u:u+1999,2);

%plot time series data
figure(3)
plot(time,relNums_bi)
title('MVC failure:Biceps')

%fft and power spectrum graphs
poS_bi = fft(relNums_bi);
%poS_bi(1) = [];

%calculate the power
num = length(poS_bi);
power = abs(poS_bi(1:floor(num/2))).^2;
nyquist = fs/2;
freq = (1:num/2)/(num/2)*nyquist;
freq = freq';

freq(1)=[];
power(1)=[];
figure(4)
plot(freq,power,'r')
xlabel('cycles/sec')
ylabel('periodogram')

% figure(12)
% % freq(1)=[];
% % power(1)=[];
% plot(freq,power,'r')

for s=1:length(power)
int=trapz(power);
hpow=int/2;
x(s)=trapz(power(1:s));
x(s)=(x(s))';
div(s)=hpow./x(s);
% x=trapz(power(1:s));
% div(s)=hpow./x;
% if x>hpow
if div(s)>0.7 && div(s)<1.30
    medF(j)=s
    
end
end

% for s=2:997;
% int = trapz(power);
% hpow=int./2;
% pow(s)=trapz(power(s:997));
% pow=pow';
% div(s)=hpow./pow(s);
% div=div';
% if div(s)>0.9 && div(s)<1.1;
%     medF(s,j)= s;
% end
% end
u = u + 2000;
end
