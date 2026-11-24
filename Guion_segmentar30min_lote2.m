%% Script para segmentar en 48 segmentos de 30 min c/u los datos RR de un 
% lote de pacientes obtenidos de ProcessISHNE_24h_HR_2026pxxx.m 
% (ej. ProcessISHNE_24h_HR_2026p189.m). 
% El guión llama a la función segment30min.m que tiene como parámetro de
% entrada el número del paciente y salva un fichero RRxx.mat (ej. RR44.mat)
% Cada fichero segmentado tendrá n variables RRdata1 hasta <= RRdata48
% si hay menos de 24 horas, n <= 48
patients=[117, 132, 135, 161, 172, 182, 197, 202, 205, 206, 208, ...
    237, 225, 263, 282]; % pacientes
for i=1:length(patients)
    segment30min2(patients(i));
end