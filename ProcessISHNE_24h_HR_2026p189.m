%% Usa el software the THEW:
%  http://thew-project.org/THEWFileFormat.htm
%  http://thew-project.org/document/read_ishne.m.txt

% Author P. Gomis (2026)
% Lectura de señales exportadas de Synescope-Livanova en formato ISHNE
% Channels: 1-12 --> I, II, III, aVR, aVL, aVF, V1, V2, V3, V4, V5 and V6

%% read_ishne1.m is an adaptation of the original with  additional
% information in the header, including the "real" samples recorded
% Input: 'path\file name', initial time (seconds), Number of seconds
% este caso: 'path\file name' = 'F:\Export_RCG_Holter_Livanova\BH0133.ecg'
%% Prueba. Try 1st 12 sec starting at second=600, (my path) to see Holter length
[hd,ecg] = read_ishne1('F:\Export_RCG_Holter_Livanova\BH183.ecg',600,12);
% Output in ADC units
N = hd.samples_recorded;
fs = hd.Sampling_Rate; % Sampling frequency (original: 1000 Hz)
Resol = hd.Resolution;  % Resolution = 2500 nV each lead
t = (1:length(ecg))'/fs;
ecg = ecg.*Resol(1)*1e-6;  % Units in mV
ecg = detrend(ecg);
figure(1)
plot(t, ecg(:,1))
xlabel('t (s)')
ylabel('Amplitud (mV)')
% Para saber el número de horas
Time_in_hours = N/(fs*3600);  %  BH0134:  24.0037, more than 24 h
%% 1st 6 hours (starting at second 30, 1st 30 s control calibration)
% a partir de 30 s está la señal, mirar si hay que empezar más tarde por
%  ruido o problemas al comienzo de colocar los electrodos
[hd,ecg1] = read_ishne1('F:\Export_RCG_Holter_Livanova\BH189.ecg',1500,6*3600); % en este paciente ponemos 480s en lugar de 30
Resol = hd.Resolution;  % Resolution = 2500 nV each lead
% baseline= 0;  % Not given, the ISHNE standard is 0
% Convert to Physical units (by default nV)
% Units in nV (nanoVolts) --> mV (*1e-6)
% Saving lead II only! Se puede probar otro lead!
ecgII = ecg1(:,2).*Resol(1)*1e-6;  % Units in mV
% Vamos a diezmar por 4 las muestras: downsampling 1000 ---> 250 Hz
ecgII = decimate(ecgII,4);
fs2 = 250;  % fs2: frecuencia de muestreo, downsampled to 250 Hz

% diseño de los filtros
fN = fs2/2;  % Nyquist frequency
fc1=0.6;  %fc=0.6 Hz, high pass cut frequency
[Bfpa,Afpa]=butter(3,fc1/fN,'high'); %Filtro pasa alto: Bfpa/Afpa
fc2 = 30; %fc = 30 Hz, low pass cut frequency
[Bfpb,Afpb]=butter(3,fc2/fN);   %Filtro pasa bajo: Bfpb/Afp
ecgIIf=filtfilt(Bfpa,Afpa,ecgII);  % filtrado pasa alto
ecgIIf = filtfilt(Bfpb,Afpb,ecgIIf);  % filtrado pasa bajo
[N,~]=size(ecgIIf);
t=(1:N)'/fs2;
% ver señal cruda y filtrada
figure(1)
plot(t/3600,ecgII, t/3600, ecgIIf), grid, xlabel('t (hours)'), ylabel('mV')
title('ECG lead II, 1ras 6 horas'), legend('original','filtrado')
% Detección del QRS (onda R). detecrc() muestra plot, detectrcNP() sin plot
% Rpeaks = detecrcNP2(ecgIIf,fs2);  % Opción 1
% [pic,Rpeaks]=findpeaks(ecgIIf,'MINPEAKHEIGHT',0.3, 'MinPeakDistance', round(0.2*fs2)); % opción 2
Rpeaks = detectR_PT2(ecgIIf); % opción 3
RR = diff(Rpeaks)/fs2*1000;
tt = Rpeaks(2:end)/fs2;
figure(2)  % RR detectado, posiblemente con artefactos y falsos RR
plot(tt,RR), xlabel('tiempo (s)'), ylabel('RR (ms)')
% hay varias opciones de filtro de RR erróneas: filter1, filter2, filter22
RRf = filter2(RR,5,20);
% tt = cumsum(RRf)/1000;
figure(3)  % RRf filtrado 
plot(tt/3600, RRf), xlabel('tiempo (hours)'), ylabel('RR (ms)')
title('RR y RRf (filtrado), 1ras 6 horas')
clear ecgII ecgIIf
%% 2nd block of 6 hours
[~,ecg1] = read_ishne1('F:\Export_RCG_Holter_Livanova\BH189.ecg',6*3600,6*3600);
ecgII2 = ecg1(:,7).*Resol(1)*1e-6;
ecgII2 = decimate(ecgII2,4);
fs2 = 250;
% clear ecg1 
% save ecgII2 ecgII2 fs2

ecg2=filtfilt(Bfpa,Afpa,ecgII2); % filtrado pasa alto
ecgII2f = filtfilt(Bfpb,Afpb,ecg2); % filtrado pasa bajo

[N,~]=size(ecgII2f);
t=(1:N)'/fs2;
figure(4)
plot(t/3600,ecgII2, t/3600, ecgII2f), grid, xlabel('t (hours)'), ylabel('mV')
title('ECG lead II, horas 6 a 12'), legend('original','filtrado')
% Detección del QRS (onda R). detecrc() muestra plot, detectrcNP() sin plot
% Rpeaks = detecrcNP2(ecgII2f,fs2);
Rpeaks = detectR_PT2(ecgII2f);
% [pic,pos]=findpeaks(ecgII2f,'MINPEAKHEIGHT',0.25, 'MinPeakDistance', round(0.2*fs2));
RR2 = diff(Rpeaks)/fs2*1000;
tt2 = Rpeaks(2:end)/fs2;
figure(5)
plot(tt2/3600,RR2), xlabel('tiempo (hours)'), ylabel('RR (ms)')
RR2f = filter2(RR2,5,20);  
% si se usa filter22 y filter23 que remueven artefactos, hay que hallar tt2
% tt2=cumsum(RR2f)/1000;
figure(5)
plot(tt2/3600, RR2f), xlabel('tiempo (hours)'), ylabel('RR (ms)')
title('RRf (filtrado), horas 6 a 12')
tt2 = tt2+tt(end);
%% 3th block of 6 hours
[~,ecg1] = read_ishne1('F:\Export_RCG_Holter_Livanova\BH189.ecg',12*3600,6*3600);
ecgII3 = ecg1(:,7).*Resol(1)*1e-6;
ecgII3 = decimate(ecgII3,4);
fs2 = 250;

ecg2=filtfilt(Bfpa,Afpa,ecgII3);
ecgII3f = filtfilt(Bfpb,Afpb,ecg2);
[N,~]=size(ecgII3f);
t=(1:N)'/fs2;

figure(6)
plot(t/3600,ecgII3, t/3600, ecgII3f), grid, xlabel('t (hours)'), ylabel('mV')
title('ECG lead II, horas 12  18'), legend('original','filtrado')
% Detección del QRS (onda R). detecrc() muestra plot, detectrcNP() sin plot
% Rpeaks = detecrcNP2(ecgII3f,fs2);
Rpeaks = detectR_PT2(ecgII3f, fs2);
% [pic,pos]=findpeaks(ecgII3f,'MINPEAKHEIGHT',0.45, 'MinPeakDistance', round(0.2*fs2));
% Rpeaks=pos;
RR3 = diff(Rpeaks)/fs2*1000;
tt3 = Rpeaks(2:end)/fs2;
figure(7)
plot(tt3/360,RR3), xlabel('tiempo (hours)'), ylabel('RR (ms)')
RR3f = filter1(RR3,5,15);
figure(7)
% plot(tt3/3600,RR3, tt3/3600, RR3f), xlabel('tiempo (hours)'), ylabel('RR (ms)')
plot(tt3/3600, RR3f), xlabel('tiempo (hours)'), ylabel('RR (ms)')
title('RR y RRf (filtrado), horas 12 a 18')
%RRTotalf = [RRf;RR2f;RR3f];
tt3 = tt3+tt2(end);
%% 4th block of 6 hours
% OjO. En paciente BH0007 y varios más la señal ECG < 24h
% En BH007 la última hora y media se quedó encendido el Holter. 
% ¡Puede ocurrir en mas pacientes!
% en ECGs de 24h el final: % final hasta 6*3600
[hd,ecg1] = read_ishne1('F:\Export_RCG_Holter_Livanova\BH189.ecg',18*3600,3.57*3600); % final antes
ecgII4 = ecg1(:,2).*Resol(1)*1e-6;
ecgII4 = decimate(ecgII4,4);
fs2 = 250;

ecg2=filtfilt(Bfpa,Afpa,ecgII4);
ecgII4f = filtfilt(Bfpb,Afpb,ecg2);

[N,leads]=size(ecgII4f);
t=(1:N)'/fs2;
figure(8)
% plot(t/3600,ecgII4, t/3600, ecgII4f), grid, xlabel('t (hours)'), ylabel('mV')
% legend('original','filtrado')
plot( t/3600, ecgII4f), grid, xlabel('t (hours)'), ylabel('mV')
title('ECG lead II, horas 18 a 24'), legend('original')
% Detección del QRS (onda R). detecrc() muestra plot, detectrcNP() sin plot
% Rpeaks = detecrcNP2(ecgII4f,fs2);
% [pic,Rpeaks]=findpeaks(ecgII4f,'MINPEAKHEIGHT',0.4,'MinPeakDistance', round(0.2*fs2));
% [pic,Rpeaks]=findpeaks(ecgII4f,'MINPEAKHEIGHT',0.2,'MinPeakDistance', round(0.2*fs2)); % pac 92
Rpeaks = detectR_PT2(ecgII4f, fs2);
RR4 = diff(Rpeaks)/fs2*1000;
tt4 = Rpeaks(2:end)/fs2;
figure(9)
plot(tt4/360,RR4), xlabel('tiempo (hours)'), ylabel('RR (ms)')
RR4f = filter1(RR4,5,15);
% al usar filter22 o filter23 que quitan los RR erróneos, hay que
% recalcular los tiempos (tt4, en este caso) con cumsum
% tt4 = cumsum(RR4f)/1000;
figure(9)
plot(tt4/3600, RR4f), xlabel('tiempo (hours)'), ylabel('RR (ms)')
title('RR y RRf (filtrado), horas 18 a 24')
RRTotalf = [RRf;RR2f;RR3f;RR4f];
tt4 = tt4+tt3(end);
ttotal = [tt;tt2;tt3;tt4];
% Volvemos a filtrar los RR (mas riguroso: ventana de 10 muestras y 10%
% de desvio de la media de la ventana de 10 muestras
% RRTotalff = filter1(RRTotalf,10, 20);
RRTotalff = filter1(RRTotalf,5, 10);
figure(10)
% plot(ttotal/3600, RRTotalf, ttotal/3600, RRTotalff)
% ttotal = cumsum(RRTotalff./1000);
plot(ttotal/3600, RRTotalff)
xlabel('tiempo (hours)'), ylabel('RR (ms)')
% Heart rate (HR) total. Hay picos por los artefactos o errores de
% detección del RR. 
HR = 1./RRTotalff*60000;
figure(11)
plot(ttotal/3600, HR)
xlabel('tiempo (hours)'), ylabel('HR (latidos/min - bpm)')
title('HR durante 24 h, paciente BH0134')
%% Opcional para graficar HR en escala de hora:min:seg
%El inicio se puede ajustar con la hora de colocación % del Holter.
%Por ejemplo, ecg-kit:
% ECG = ECGwrapper('recording_name','F:\Export_RCG_Holter_Livanova\BH0128.ecg');
% d = ECG.ECG_header.btime;  % '15:35:29'
% Si la hora es incorrecta, se puede poner a mano!
% inicio = datenum(d);
% inicio = rem(inicio,1)*24; % 15.5914 en formato numérico (0->1)=(0-->24h)
% ttotalN = ttotal+inicio*3600;
% % La hora inicial que se muestra es la de colocación del Holter,
% Se convierte a formato HH:mm:ss
% ttotal2 = datetime(ttotalN, 'ConvertFrom', 'epochtime', 'Epoch', 0, 'Format', 'HH:mm:ss');
% figure(12)
% plot(ttotal2, HR), xlabel('tiempo (hours)'), ylabel('HR (latidos/min - bpm)')
% datetick('x','HH:MM')
%Salvar con número del paciente
save RR24h_189.mat RRTotalf RRTotalff HR ttotal