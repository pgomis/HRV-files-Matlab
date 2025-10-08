function ENER=avgpwrAR24h2(data,nmin,Fs,bands,Nfft,na)
% Calculates the average power from the Power Spectral Density (PSD)
% using parametric AR model with the BURG methode and a "na" model order
%  for each 5-min segment (LF and HF) SPLIT in SEGMENTS AFTER 24-h spline re-sampling
%
% The routine is degigned to compute the standard HRV spectral indices (24h)
% The R-R interval time series is resampled at "fs" Hz.
%
% ENER = avgpwrAR24h2(data,nmin,Fs,bandes,Nfft,na)
% Input data: 2 columns = [time values]. After resampled, the series is 
% detrended.
% nmin: number of minutes of HRV spectral-segments, (default: nmin=5) 
%   fs: The R-R interval time series is resampled at "fs" Hz for 
%       spectral anlysis. Default value: fs = 4
%   bands: Default Bands: ULF: (0-0.003] Hz, VLF = (0.003 - 0.04] Hz, 
%           LF = [0.04 - 0.15], HF = [0.15 - 0.4] Hz 
%   Example: bands=[0.003 0.04;0.04 0.15;0.15 0.4]
% Number of computed points on the unitary circle of z-plane: Nfft = 2048; 
% Output: ENER(1)=Totalpower; ENER(2)=ULF; ENER(3)=VLF; ENER(4)=LF; 
%   ENER(5)=LFnorm; ENER(6)=HF; ENER(7)=HFnorm; ENER(8)=Ratio(LF/HF);
%
% TO AVOID DC values and SDNN^2 = Total Power
% TTotal Power according t Stein (2004), f=[1.5e-5 - 0.5] Hz
%                                     or f = (0 - 0.5] Hz
%  ULF for 24 h and VLF for 5-min start at 1.5e-5 Hz or f> 0
%
% This function uses armaspectra function from our toolbox.
% Pedro Gomis 2013

if nargin < 6, na=[]; end
if isempty(na), na=16; end
if nargin < 5, Nfft=[]; end
if isempty(Nfft), Nfft=2048; end
if nargin < 4, bands=[]; end
if isempty(bands), bands=[0.003 0.04;0.04 0.15;0.15 0.4]; end
if nargin < 3, Fs=[]; end
if isempty(Fs), Fs=4; end
if nargin < 2, nmin=5; end

% Whole (24h) computing ULF y VLF

XX=data(1,1):1/Fs:data(end,1);
resamp_data=spline(data(:,1),data(:,2),XX);
y=detrend(resamp_data);
N=length(y);
%PSD using parametric AR modeling of the whole segment
% Automatic choice of Model Order (CIC)
% nn=selarstruc(y,'arburg',2:100,'cic');
nn=25;  % Model order for the whole (24h) segment BEST order after search
[A,e]=arburg(y,nn);
[Pxx,f]=armaspectra(1,A,e,N,Fs);
% Option using FFT with Hanning window
% N=length(y);
% win=window(@hanning,N);
% [Pxx,f]=periodogram(y,win,N,Fs);
indTot = f> 0 & f<0.5;
indULF = f> 0 & f <= bands(1,1);
indVLF= f> bands(1,1) & f<bands(1,2);
Totalpower=Fs/N*sum(Pxx(indTot));
ULF=Fs/N*sum(Pxx(indULF));
VLF=Fs/N*sum(Pxx(indVLF));

% Compute LF and HF averaging all 5-min segments values
nsamp=round(60*nmin*Fs);
% t_end = XX(end);
nsegment = floor(length(XX)/(Fs*5*60));
LF5min = zeros(nsegment,1);
HF5min = zeros(nsegment,1);
LFnorm5 = zeros(nsegment,1);
HFnorm5 = zeros(nsegment,1);
for ii=0:nsegment-1
%     index = find(data(:,1)> nseg*ii & data(:,1) <= nseg*ii+nseg);
%     XX=data(index(1),1):1/Fs:data(index(end),1); 
%     resamp_data=spline(data(index,1),data(index,2),XX); 
%     y=detrend(resamp_data); 
%     index = find(XX >nsamp*ii & XX <= nsamp*ii+nsamp);
    index = ii*nsamp+1:ii*nsamp+nsamp;
    [A,e]=arburg(y(index),na); 
    [Pxx,f]=armaspectra(1,A,e,Nfft,Fs);
    indTot = f> 0 & f<0.5;
    indVLF= f> 0 & f<bands(1,2);
    indLF= f >= bands(2,1) & f <= bands(2,2);
    indHF= f> bands(3,1) & f<=bands(3,2);
    Totalpower5=Fs/Nfft*sum(Pxx(indTot)); 
    VLF5=Fs/Nfft*sum(Pxx(indVLF));
    LF5min(ii+1,1)=Fs/Nfft*sum(Pxx(indLF));
    HF5min(ii+1,1)=Fs/Nfft*sum(Pxx(indHF)); 
    LFnorm5(ii+1,1)= LF5min(ii+1,1)/(Totalpower5-VLF5)*100; 
    HFnorm5(ii+1,1)= HF5min(ii+1,1)/(Totalpower5-VLF5)*100;
end
LF=mean(LF5min);
HF=mean(HF5min);
% LFnorm=LF/(Totalpower-(VLF+ULF))*100;
% HFnorm=HF/(Totalpower-(VLF+ULF))*100;
LFnorm=mean(LFnorm5);
HFnorm=mean(HFnorm5);
Ratio=LF/HF;

ENER(1)=Totalpower;
ENER(2)=ULF;
ENER(3)=VLF;
ENER(4)=LF;
ENER(5)=LFnorm;
ENER(6)=HF;
ENER(7)=HFnorm;
ENER(8)=Ratio;
ENER=ENER';
