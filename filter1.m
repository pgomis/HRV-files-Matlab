function signal_out = filter1(signal_in, samples, percent)
%fRR = filter1(RRsignal, muestras, percent)
%
%Input: RRsignal= 1 row input values = RR intervals
% samples: Number of SAMPLE BEATS for the window:
% Default: five-beat sliding window algorithm rejecting any beat that 
% deviated more than PERCENT (default=15%) from the mean
% length of the preceding R-R intervals
% GUIFRE original
if nargin < 2, samples=[]; end
if isempty(samples), samples=5; end
if nargin < 3, percent=[]; end
if isempty(percent), percent=15; end
signal_length = length(signal_in);
if signal_length < samples
   error('Not enough data points!');
end

if signal_length < 25000
   s_mean = round(mean(signal_in));          % Rounding to have an exact 
else                                         % number of milliseconds
   s_mean = round(mean(signal_in(1:25000)));
end

max_factor = 1 + percent/100;
min_factor = 1 - percent/100;
signal_out = zeros(size(signal_in));

for i = 1 : samples-1
   if signal_in(i) > max_factor*s_mean || signal_in(i) < min_factor*s_mean
      signal_out(i) = s_mean;
   else
      signal_out(i) = signal_in(i);
   end
end

for i = samples : signal_length
   s_mean = mean(signal_in(i-samples+1:i));
   if signal_in(i) > max_factor*s_mean || signal_in(i) < min_factor*s_mean
      signal_out(i) = s_mean;
   else
      signal_out(i) = signal_in(i);
   end
end