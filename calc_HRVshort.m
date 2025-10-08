function [PwrAR,Estad,HR,alpha]=calc_HRVshort(data,Fs,bands,Nfft, na)
%Computes HRV standard time and frequency indices abd DFA fractal indices
%from entire R-R intervals series. Supose to be applied to short term RR 
%series (normally 5-min) 
%
%[PwrAR,Estad,HR,alpha]= calc_HRVshort(data,fs,bands,Nfft,na);
%
% Input: data= 2 column input [time values], values= filtered RR intervals
%   fs: The R-R interval time series is resampled at "fs" Hz for 
%       spectral anlysis. Default value: fs = 4
%   bands: Default Bands: ULF: <= 0.003 VLF = (0.003 - 0.04], 
%           LF = [0.04 - 0.15], HF = [0.15 - 0.4] Hz 
%           Example: bands=[0.003 0.04;0.04 0.15;0.15 0.4]
%   Nfft: fft computed points (default: 2048)
%   na: AR model order (default: 16)
%Output: 
%  PwrAR: frequency HRV indices (AR model) 
%       Whole (24h) computing ULF y VLF
%       Compute LF and HF averaging all 5-min segments values
% PwrAR(1)=Totalpower; PwrAR(2)=VLF; PwrAR(3)=LF; 
%  PwrAR(4)=LFnorm; PwrAR(5)=HF; PwrAR(6)=HFnorm; PwrAR(7)=Ratio(LF/HF);
% Estad: vector with the time indices. (units ms):
%(1)   RR mean value
%(2)   SDNN
%(3)   RMSSD Kaplan
%(4)   RMSSD finland
%(5)   SDSD
%(6)   NN50
%(7)   pNN50 (en %)
%(8)   MIRR ( PhD Tesis Garcia MA )
% HR: heart rate mean
%  alpha: DFA, alpha_1, alpha_2 indexes from whole (24h) R-R intervals
%       alpha_1 (Tulppo, 2004, Peña, 2009, Stein, 2010)  n1=4, n2=11
%       alpha_2 (Stein, 2010)  n1=12, n2=20
%
%  Pedro Gomis, 2013

if nargin < 5, na = 16; end
if nargin < 4, Nfft = 2048; end
if nargin < 3, bands=[]; end
if isempty(bands), bands=[0.003 0.04;0.04 0.15;0.15 0.4]; end
if nargin < 2, Fs=[]; end
if isempty(Fs), Fs=4; end

% PwrAR: Spectral HRV frequency-bands average power
% VLF, LF and HF computed on each (usually 5-min) segment
% (Huikuri, 2000, average of 512 beat blocks;, Stein, 2004 average 5-min segment)
%data(:,1)=data(:,1)/1000;  % time ms --> sec (maraton 2016!!!!)
Estad=estdtemps(data);
HR=1000/Estad(1)*60;
PwrAR=avgpwrARshort(data,Fs,bands,Nfft,na);

% Fractal DFA measurents: alpha_1 (short term) and alpha_2 (long term)
% during the 30-min
a1 = dfa_1(data);
a2 = dfa_2(data);
alpha = [a1 a2];


