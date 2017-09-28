%EMG Lab: Biodynamics
%part 2
clear
clc
close all

fs=2000;
dt=1/fs;
fc=6;
%load raw data

% cd('C:\Users\maa5g8\Desktop\Biodynamics\Lab EMG'); 

for n=5:10    
filename=(['trial',num2str(n),'.csv']);   %define your filename according to the file index
temp{n}=csvread(filename);

end 
emg5_raw = temp{1,5};
emg6_raw = temp{1,6};
emg7_raw = temp{1,7};
emg8_raw = temp{1,8};
emg9_raw = temp{1,9};
emg10_raw = temp{1,10};

% for i=1:5;
%     subplot(5,2,i-1)
%     plot(time,EMG(:,i), 'red')
%     title(['Activation' i], '','')
% end

figure(1)
subplot(6,1,1)
plot(emg5_raw(:,1),emg5_raw(:,2));
title ('Biceps')
subplot(6,1,2)
plot(emg6_raw(:,1),emg6_raw(:,2));
subplot(6,1,3)
plot(emg7_raw(:,1),emg7_raw(:,2));
subplot(6,1,4)
plot(emg8_raw(:,1),emg8_raw(:,2));
subplot(6,1,5)
plot(emg9_raw(:,1),emg9_raw(:,2));
subplot(6,1,6)
plot(emg10_raw(:,1),emg10_raw(:,2));

figure(2)
subplot(6,1,1)
plot(emg5_raw(:,1),emg5_raw(:,3));
title ('Triceps')
subplot(6,1,2)
plot(emg6_raw(:,1),emg6_raw(:,3));
subplot(6,1,3)
plot(emg7_raw(:,1),emg7_raw(:,3));
subplot(6,1,4)
plot(emg8_raw(:,1),emg8_raw(:,3));
subplot(6,1,5)
plot(emg9_raw(:,1),emg9_raw(:,3));
subplot(6,1,6)
plot(emg10_raw(:,1),emg10_raw(:,3));


[row,column]=size(emg5_raw)
for i=2:column
    emg_5(:,i)=emg5_raw(:,i)-(mean(emg5_raw(:,i)));
    emg_6(:,i)=emg6_raw(:,i)-(mean(emg6_raw(:,i)));
    emg_7(:,i)=emg7_raw(:,i)-(mean(emg7_raw(:,i)));
    emg_8(:,i)=emg8_raw(:,i)-(mean(emg8_raw(:,i)));
    emg_9(:,i)=emg9_raw(:,i)-(mean(emg9_raw(:,i)));
    emg_10(:,i)=emg10_raw(:,i)-(mean(emg10_raw(:,i)));
end

emg5_rect=abs(emg_5);
emg6_rect=abs(emg_6);
emg7_rect=abs(emg_7);
emg8_rect=abs(emg_8);
emg9_rect=abs(emg_9);
emg10_rect=abs(emg_10);

emg5_rect(:,1)=[];
emg6_rect(:,1)=[];
emg7_rect(:,1)=[];
emg8_rect(:,1)=[];
emg9_rect(:,1)=[];
%emg10_rect(:,1)=[];

emg5_env=filter_data(emg5_rect, fc, fs, [1:2]);
emg6_env=filter_data(emg6_rect, fc, fs, [1:2]);
emg7_env=filter_data(emg7_rect, fc, fs, [1:2]);
emg8_env=filter_data(emg8_rect, fc, fs, [1:2]);
emg9_env=filter_data(emg9_rect, fc, fs, [1:2]);
emg10_env=filter_data(emg10_rect, fc, fs, [2:3]);

threshold=mean(emg5_env)+3*(std(emg5_env));

figure(3)
subplot(6,1,1)
plot(emg5_env(:,1));
title ('Biceps')
subplot(6,1,2)
plot(emg6_env(:,1));
subplot(6,1,3)
plot(emg7_env(:,1));
subplot(6,1,4)
plot(emg8_env(:,1));
subplot(6,1,5)
plot(emg9_env(:,1));
subplot(6,1,6)
plot(emg10_env(:,2));

maxEMG_t6=max(emg6_rect);
maxEMG_t7=max(emg7_rect);

%MVC:Biceps
mvc_biceps_sw=(emg8_env(:,1)/maxEMG_t6(1));
mvc_biceps_lw=(emg9_env(:,1)/maxEMG_t6(1));
figure(4)
plot(mvc_biceps_sw,'r')
hold
plot(mvc_biceps_lw,'g')
title('EMG compared to MVC:Biceps')
%xlabel('Time (Second)')
ylabel('% MVC')
legend('small weight curls','large weight curls');
grid on

%MVC:Triceps
mvc_triceps_sw=(emg8_env(:,2)/maxEMG_t6(2));
mvc_triceps_lw=(emg9_env(:,2)/maxEMG_t6(2));
figure(5)
plot(mvc_triceps_sw,'r')
hold
plot(mvc_triceps_lw,'g')
title('EMG compared to MVC:Triceps')
%xlabel('Time (Second)')
ylabel('% MVC')
legend('small weight curls','large weight curls');
grid on


% [f2,p2] = power_spectrum(emg10_raw,fs);
% 
% figure(6)
% plot(f2,p2);
% stem(f2,p2);
% axis([1 1000 0 2]);
% title('power Spectrum')
% xlabel('frequency')
% ylabel('power')
% grid on

%part_3
%power spectrum
time = emg10_raw(:,1);
relNums_bi = emg10_env(:,2);

%plot time series data
figure(6)
plot(time,relNums_bi)
title('MVC failure:Biceps')

%zoom in the 15-30 seconds of data
figure(7)
plot(time(30000:64000),relNums_bi(30000:64000))

%fft and power spectrum graphs
poS_bi = fft(relNums_bi);
poS_bi(1) = [];

%plot the Fourier coefficients
figure(8)
plot(poS_bi,'ro')
title('Fourier Coefficients')
xlabel('Real Axis')
ylabel('Imaginary Axis')

%calculate the power
num = length(poS_bi);
power = abs(poS_bi(1:floor(num/2))).^2;
nyquist = 1/2;
freq = (1:num/2)/(num/2)*nyquist;
freq = freq';

figure(9)
plot(freq(1500:2000),power(1500:2000),'r')
%plot(freq(1600:1800),power(1600:1800),'r')
hold on
coef_fit=polyfit(freq(1500:2000),power(1500:2000),4);
%coef_fit=polyfit(freq(1600:1800),power(1600:1800),4);
y_fit = polyval(coef_fit,[0.0211 0.0281]);
plot([0.0211 0.0281],y_fit,'r')
%y_fit = polyval(coef_fit,[0.0225 0.0253]);
%plot([0.0225 0.0253],y_fit,'r')
% plot(freq,power,'r')
% axis([0 40 0.005 0.05])
xlabel('cycles/sec')
ylabel('periodogram')


%replot with the x-axis changed to period
period = 1./freq;
figure(11)
plot(period,power)
%axis([0 0.010 0 3.5e-4])
ylabel('power')
xlabel('period(sec/cycle)')




% figure(11)
% %plot(freq(700:750),power(700:750),'r')
% plot(time(500:700),power(500:700),'r')
% %axis([0 40 0.005 0.05])
% xlabel('cycles/sec')
% ylabel('periodogram')