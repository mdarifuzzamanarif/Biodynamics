%EMG Lab: Biodynamics
%part 3:Power Spectrum & Median Frequency
clear
clc
close all

fs=1000;
dt=1/fs;
fc=6;
%load raw data
% for n=5:10    
% filename=(['trial',num2str(n),'.csv']);   %define your filename according to the file index
% temp{n}=csvread(filename);
% 
% end 
% emg10_raw = temp{1,10};

name_list = {'trial1.txt' 'trial2.txt' 'trial3.txt' 'trial4.txt' 'trial5.txt' 'trial6.txt'};

for i = 1:length(name_list)
    placehold=importdata(name_list{i});
    %placehold_show = placehold;
    temp{i}=placehold.data;
end

data = temp{6};

figure(1)
%subplot(2,1,1)
plot(data(:,1),data(:,2));
title ('Biceps')
%subplot(2,1,2)
% plot(emg6_raw(:,1),emg6_raw(:,3));
% title ('Triceps')


[row,column]=size(data);
emg6_raw = data(:,2);

% for i=2:column;
    %emg6_raw(:,i)=emg6_raw(:,i)-(mean(emg6_raw(:,i)));
% end
emg6_raw=emg6_raw-(mean(emg6_raw));
emg6_rect=abs(emg6_raw); %Rectification: Absolute value
%emg10_rect(:,1)=[];
emg6_env=filter_data(emg6_rect, fc, fs, [1:1]); %Low pass filter:Linear Envelope

figure(2)
% subplot(2,1,1)
plot(data(:,1),emg6_env(:,1));
title ('Biceps')
% subplot(2,1,2)
% plot(emg6_raw(:,1),emg6_env(:,3));
% title ('Triceps')


% [freq,power] = power_spectrum(emg10_env(2001:3000,2),2000)
% freq=freq';
% figure(7)
% plot(freq,power)

% MF = medianfreq(freq(1:500),power(1:500))

% for j = 1:20;
% u = 1;
% time = emg6_raw(u:u+1999,1);

u=70000;
time = data(u:u+4999,1);
relNums_bi = emg6_env(u:u+4999,1);

% time = data(:,1);
% relNums_bi = emg6_env(:,1);

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

for s=2:length(power)
int=trapz(power);
hpow=int/2;
x(s)=trapz(power(1:s));
%x(s)=(x(s))';
div(s)=hpow./x(s);
% x=trapz(power(1:s));
% div(s)=hpow./x;
% if x>hpow
% if div(s)>0.7 && div(s)<1.30
%     medF(j)=s
    
end
%end

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
%u = u + 2000;
%end
