function signal_out = filter12(signal_in, samples, percent)
%fRR = filter1(RRsignal, muestras, percent)
%
%Input: RRsignal= 1 row input values = RR intervals
% samples: Number of SAMPLE BEATS for the window:
% Default: five-beat sliding window algorithm rejecting any beat that 
% deviated more than PERCENT (default=15%) from the mean
% length of the preceding R-R intervals
% GUIFRE original but usin MEDIAN instead of MEAN
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
signal_out = zeros(size(signal_in));
% Evaluating the first samples-1 (First 4, by default)
for i = 1 : samples-1
   if signal_in(i) > max_factor*s_mean || signal_in(i) < min_factor*s_mean
      signal_out(i) = s_mean;
   else
      signal_out(i) = signal_in(i);
   end
end
% Evaluating the rest of samples  (From 5th to END, by default)
for i = samples : signal_length
   s_mean = median(signal_in(i-samples+1:i));
   s_mean2 = median(signal_in(i-samples+1:i-2));
   if signal_in(i) > max_factor*s_mean || signal_in(i) < min_factor*s_mean
       signal_in(i) = s_mean2;
       signal_out(i) = s_mean;
   else
       signal_out(i) = signal_in(i);
   end
end