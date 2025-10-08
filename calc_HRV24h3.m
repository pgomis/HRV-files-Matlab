function [PwrAR,Estad,alpha]=calc_HRV24h3(data,nmin,Fs,bandes)
%Computes HRV standard time and frequency indices from 24h R-R intervals
% segments default: nmin = 5 min, uses avgpwrAR24h3
%                             (uses interpolation-splines each 5-min)
%
%[PwrAR,Estad,alpha]= calc_HRV24h3(data,nmin,fs,bands);
%
% Input: data= 2 column input [time values], values= filtered RR intervals
%   nmin: number of minutes of HRV spectral-segments, (default: nmin=5)
%   fs: The R-R interval time series is resampled at "fs" Hz for 
%       spectral anlysis. Default value: fs = 4
%   bands: Default Bands: ULF: <= 0.003 VLF = (0.003 - 0.04], 
%           LF = [0.04 - 0.15], HF = [0.15 - 0.4] Hz 
%   Example: bands=[0.003 0.04;0.04 0.15;0.15 0.4]
% 
%Output: 
%  PwrAR: frequency HRV indices (AR model) 
%       Whole (24h) computing ULF y VLF
%       Compute LF and HF averaging all 5-min segments values
% PwrAR(1)=Totalpower; PwrAR(2)=ULF; PwrAR(3)=VLF; PwrAR(4)=LF; 
%  PwrAR(5)=LFnorm; PwrAR(6)=HF; PwrAR(7)=HFnorm; PwrAR(8)=Ratio(LF/HF);
% Estad: vector with the time indices. (units ms):
%(1)   RR mean value
%(2)   SDNN
%(3)   RMSSD Kaplan
%(4)   SDANN
%(5)   SDNN_5min  
%(6)   SDSD
%(7)   NN50
%(8)   pNN50 (en %)
%(9)   MIRR ( PhD Tesis Garcia MA )
%  alpha: DFA, alpha_1, alpha_2 indexes from whole (24h) R-R intervals
%       alpha_1 (Tulppo, 2004, Peña, 2009, Stein, 2010)  n1=4, n2=11
%       alpha_2 (Stein, 2010)  n1=12, n2=20
%
%  Pedro Gomis, 2013

if nargin < 2, nmin=[]; end
if isempty(nmin), nmin=5; end
if nargin < 3, Fs=[]; end
if isempty(Fs), Fs=4; end
if nargin < 4, bandes=[]; end
if isempty(bandes), bandes=[0.003 0.04;0.04 0.15;0.15 0.4]; end
% PwrAR: Spectral HRV frequency-bands average power
% ULF and VLF computed on the whole (i.e. 24 h) segment
% LF and HF computed on each 5-min segmet and then averaged.
% (Huikuri, 2000, average of 512 beat blocks;, Stein, 2004 average 5-min segment)

Estad=estdtemps24h3(data);
PwrAR=avgpwrAR24h3(data,nmin,Fs,bandes);

% Fractal DFA measurents: alpha_1 (short term) and alpha_2 (long term)
% during the 30-min
a1 = dfa_1(data);
a2 = dfa_2(data);
alpha = [a1 a2];

