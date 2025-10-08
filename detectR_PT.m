function posR = detectR_PT(ecg, fs)
% Función detecta posición picos de la señal de ecg con método Pan-Tompkins 
%
% posR = detectR_PT(ecg, fs)
%
% x: señal vector columna
% fs: frecuencia de muestreo; default: fs = 250
%
if nargin < 2, fs = []; end
if isempty(fs), fs = 250; end  % fs = 250
% Eliminar línea base con filtro pasa alto
hpFilt = designfilt('highpassiir','FilterOrder',4, ...
         'HalfPowerFrequency',0.5,'SampleRate',fs);
ecg_hp = filtfilt(hpFilt, ecg);

% Filtro pasa banda para eliminar ruido muscular y de red
ecg_filtered = bandpass(ecg_hp, [5 15], fs);

% Derivada para resaltar pendientes
ecg_derivative = diff(ecg_filtered);
% 4. Cuadrado para enfatizar picos
ecg_squared = ecg_derivative .^ 2;

% Integración por ventana (suavizado)
window_size = round(0.150 * fs); % 150 ms
ecg_integrated = conv(ecg_squared, ones(1, window_size)/window_size, 'same');

% Umbral adaptativo basado en la media
threshold = mean(ecg_integrated) + 0.5 * std(ecg_integrated);

% Detección de picos R
[~, posR] = findpeaks(ecg_integrated, 'MinPeakHeight', threshold, ...
                        'MinPeakDistance', round(0.25*fs));

% Visualización (opcional)
t = (0:length(ecg)-1)/fs;
figure;
plot(t, ecg);
hold on;
plot(t(posR), ecg(posR), 'ro');
title('Detección de picos R en señal ECG ruidosa');
xlabel('Tiempo (s)');
ylabel('Amplitud');
hold off
