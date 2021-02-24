% Script to whiten a given colored noise data

% QYQ 2021/02/24

clear
%% load data
load('/Users/qyq/Library/Mobile Documents/com~apple~CloudDocs/Development/GWSC/NOISE/testData.txt');
fs = (length(testData(:,1)) - 1)/testData(end,1); % get the sampling frequency.

noiseTime = testData(testData(:,1) <= 5,1);
noiseVals = testData(testData(:,1) <= 5,2);
[pxx,f]=pwelch(noiseVals, 256,[],[],fs);
figure
plot(f,pxx)
xlabel('Frequency [Hz]')
ylabel('PSD')

% Filter design
TF = 1/sqrt(pxx); % transfer function for filter
fltOrder = 500; % number of filter orders
b = fir2(fltOrder,f'/(fs/2),TF);

filtered_Data = fftfilt(b,testData(:,2));

figure 
[S,F,T] = spectrogram(testData(:,2),[],[],[],fs);
imagesc(T,F,abs(S));
title('Original Data')
xlabel('Time [s]')
ylabel('Frequency [Hz]')

figure
[SF,F,T] = spectrogram(filtered_Data,[],[],[],fs);
imagesc(T,F,abs(SF));
title('Filtered Data')
xlabel('Time [s]')
ylabel('Frequency [Hz]')

figure
plot(testData(:,1),testData(:,2))
title('Original Data Time Series')
xlabel('Time [s]')
ylabel('Strain')

figure
plot(testData(:,1),filtered_Data)
title('Filtered Data Time Series')
xlabel('Time [s]')
ylabel('Strain')

% END