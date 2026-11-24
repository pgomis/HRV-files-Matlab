%% Script para segmentar en 48 segmentos de 30 min c/u los datos RR de un 
% lote de pacientes CONTROL obtenidos de ProcessISHNE_24h_HR_2026cxxx.m 
% (ej. ProcessISHNE_24h_HR_2026c22.m). 
% El guión llama a la función segment30min2control.m que tiene como parámetro de
% entrada el número del paciente y salva un fichero RR_cxx.mat (ej. RR_c22.mat)
% Cada fichero segmentado tendrá n variables RRdata1 hasta <= RRdata48
% si hay menos de 24 horas, n <= 48
patients=[1,2,5:9, 11:12, 15:17, 19, 22:24, 26:27, 30:32, 35:37, 39,...
    45, 47:50, 52:53, 56, 60, 62, 77, 81, 93]; % Controles
for i=1:length(patients)
    segment30min2control(patients(i));
end