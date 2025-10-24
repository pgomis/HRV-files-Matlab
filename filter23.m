function [signal_out, perc] = filter23(signal_in, samples, percent)
%%REMOVE ARTIFACTS
%  [fRR, perc] = filter23(RRsignal, muestras, percent)
%
%Input: RRsignal= 1 row input values = RR intervals
% samples: Number of SAMPLE BEATS for the window: 5 (BY DEFAULT)
%  DEFAULT 5-beat sliding window algorithm rejecting any beat that 
%  deviated more than PERCENT (default=15%) from the MEAN
%  of the preceding R-R SAMPLES
% Output: fRR: filter RR
%         perc: percentage of filtered Beats
% GUIFRE original, using MEAN

%  P.Gomis 2017
if nargin < 2, samples=[]; end
if isempty(samples), samples=5; end
if nargin < 3, percent=[]; end
if isempty(percent), percent=15; end
signal_length = length(signal_in);
if signal_length < samples
   error('Not enough data points!');
end

if signal_length < 500
   s_mean = round(median(signal_in));          % Rounding to have an exact 
else                                         % number of milliseconds
   s_mean = round(median(signal_in(1:500)));
end

max_factor = 1 + percent/100;
min_factor = 1 - percent/100;
signal_out = signal_in;
% Evaluating the first samples-1 (First 4, by default)
for i = 1 : samples-1
   if signal_in(i) > max_factor*s_mean || signal_in(i) < min_factor*s_mean
       signal_in(i) = s_mean;
       signal_out(i) = -99;
   end
end
% Evaluating the rest of samples  (From 5th to END, by default)
for i = samples : signal_length
   s_mean = mean(signal_in(i-samples+1:i-1));
   s_mean2 = mean(signal_in(i-samples+1:i-2));
   if signal_in(i) > max_factor*s_mean || signal_in(i) < min_factor*s_mean
       signal_in(i) = s_mean2;
       signal_out(i) = -99;
   end
end
n99=signal_out==-99;
signal_out(n99)=[]; % removing the abnormal RR
perc = length(n99)/length(signal_length)*100;