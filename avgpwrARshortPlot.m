function ENER=avgpwrARshortPlot(data,Fs,bands,Nfft,na)
% Calculates the average power from the Power Spectral Density (PSD)
% using parametric AR model with the BURG methode and a "na" model order.
% The routine is degigned to compute the standard HRV spectral indices.
% The R-R interval time series is resampled at "fs" Hz.
%
% ENER = avgpwrAR(data,Fs,bandes,Nfft,na)
% 
% Input data: 2 columns = [time values]. After resampled, the series is 
% detrended.
% Default values: fs = 4; na = 16; 
% Number of computed points on the unitary circle of z-plane: Nfft = 2048; 
% Default Bands: VLF = (0 - 0.04], LF = [0.04 - 0.15], HF = [0.15 - 0.4] Hz
% bands=[0 0.04;0.04 0.15;0.15 0.4].
%
% Output: ENER(1)=Totalpower; ENER(2)=VLF; ENER(3)=LF; ENER(4)=LFnorm;
%         ENER(5)=HF; ENER(6)=HFnorm; ENER(7)=Ratio;
%
% TO AVOID DC values and SDNN^2 = Total Power
% TTotal Power according t Stein (2004), f=[1.5e-5 - 0.5] Hz
%  OR f=(0 - 0.15]
% VLF according t Stein (2004), f=[1.5e-5 - 0.04] Hz, or f=(0 - 0.04] Hz
% This function uses armaspectra function from our toolbox.
% Pedro Gomis 2013

if nargin < 5, na=[]; end
if isempty(na), na=16; end
if nargin < 4, Nfft=[]; end
if isempty(Nfft), Nfft=2048; end
if nargin < 3, bands=[]; end
if isempty(bands), bands=[1.5e-5 0.04;0.04 0.15;0.15 0.4]; end

XX=data(1,1):1/Fs:data(end,1);
resamp_data=spline(data(:,1),data(:,2),XX);
y=detrend(resamp_data);

[A,e]=arburg(y,na);
[Pxx,f]=armaspectra(1,A,e,Nfft,Fs);
figure(4)
plot(f,10*log10(Pxx)), xlabel('freq (Hz)'),grid
ylabel('dB/Hz')
title('PSD parametric AR modeling, 5-min (log scale)')   
figure(5)
plot(f(1:256),Pxx(1:256)), xlabel('freq (Hz)'),grid
ylabel('ms^2/Hz')
title('PSD parametric AR modeling, 5-min (absolute values)')   
% indTot = f>= bands(1,1) & f<0.5;
% indVLF= f>=bands(1,1) & f<bands(1,2);
indTot = f>0 & f<0.5;
indVLF= f>0 & f<bands(1,2);
indLF= f >= bands(2,1) & f <= bands(2,2);
indHF= f> bands(3,1) & f<=bands(3,2);

Totalpower=Fs/Nfft*sum(Pxx(indTot));
VLF=Fs/Nfft*sum(Pxx(indVLF));
LF=Fs/Nfft*sum(Pxx(indLF));
HF=Fs/Nfft*sum(Pxx(indHF));

LFnorm=LF/(Totalpower-VLF)*100;
HFnorm=HF/(Totalpower-VLF)*100;
Ratio=LF/HF;

ENER(1)=Totalpower;
ENER(2)=VLF;
ENER(3)=LF;
ENER(4)=LFnorm;
ENER(5)=HF;
ENER(6)=HFnorm;
ENER(7)=Ratio;
ENER=ENER';
