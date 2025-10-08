%% 1st 6 hours (starting at second 30, 1st 30 s control calibration)
[hd,ecg1] = read_ishne1('F:\Export_RCG_Holter_Livanova\BH0001.ecg',30,6*3600);
Resol = hd.Resolution;  % Resolution = 2500 nV each lead
% baseline= 0;  % Not given, the ISHNE standard is 0
% Convert to Physical units (by default nV)
% Units in nV (nanoVolts) --> mV (*1e-6)
% Saving lead II only!
% ecg1 = detrend(ecg1);
ecgII = ecg1(:,2).*Resol(1)*1e-6;  % Units in mV
% Vamos a diezmar por 4 las muestras: downsampling 1000 ---> 250 Hz
ecgII = decimate(ecgII,4);
fs2 = 250;  % fs2: frecuencia de muestreo, downsampled to 250 Hz
clear ecg1 ecg
% save ecgII ecgII fs2
% diseño de los filtros
fN = fs2/2;  % Nyquist frequency
fc1=0.6;  %fc=0.6 Hz, high pass cut frequency
[Bfpa,Afpa]=butter(3,fc1/fN,'high'); %Filtro pasa alto: Bfpa/Afpa
fc2 = 30; %fc = 30 Hz, low pass cut frequency
[Bfpb,Afpb]=butter(3,fc2/fN);   %Filtro pasa bajp: Bfpb/Afp
ecgIIf=filtfilt(Bfpa,Afpa,ecgII);  % filtrado pasa alto
ecgIIf = filtfilt(Bfpb,Afpb,ecgIIf);  % filtrado pasa bajo
% [N,~]=size(ecgIIf);
% t=(1:N)'/fs2;
% figure(1)
% plot(t/3600,ecgII, t/3600, ecgIIf), grid, xlabel('t (hours)'), ylabel('mV')
% title('ECG lead II, 1ras 6 horas'), legend('original','filtrado')
% Detección del QRS (onda R). detecrc() muestra plot, detectrcNP() sin plot
Rpeaks = detecrcNP(ecgIIf,fs2);
RR = diff(Rpeaks)/fs2*1000;
tt = Rpeaks(2:end)/fs2;
figure(2)  % RR detectado, posiblemente con artefactos y falsos RR
plot(tt,RR), xlabel('tiempo (s)'), ylabel('RR (ms)')
RRf = filter2(RR);
figure(3)  % RRf filtrado
plot(tt/3600,RR, tt/3600, RRf), xlabel('tiempo (hours)'), ylabel('RR (ms)')
title('RR y RRf (filtrado), 1ras 6 horas')
clear ecgII ecgIIf
%% 2nd block of 6 hours
[~,ecg1] = read_ishne1('F:\Export_RCG_Holter_Livanova\BH0001.ecg',6*3600,6*3600);
ecgII2 = ecg1(:,2).*Resol(1)*1e-6;
ecgII2 = decimate(ecgII2,4);
fs2 = 250;
clear ecg1
% save ecgII2 ecgII2 fs2
ecg1=filtfilt(Bfpa,Afpa,ecgII2); % filtrado pasa alto
ecgII2f = filtfilt(Bfpb,Afpb,ecg1); % filtrado pasa bajo
% [N,~]=size(ecgII2f);
% t=(1:N)'/fs2;
% figure(4)
% plot(t/3600,ecgII2, t/3600, ecgII2f), grid, xlabel('t (hours)'), ylabel('mV')
% title('ECG lead II, horas 6 a 12'), legend('original','filtrado')
% Detección del QRS (onda R). detecrc() muestra plot, detectrcNP() sin plot
Rpeaks = detecrcNP(ecgII2f,fs2);
RR2 = diff(Rpeaks)/fs2*1000;
tt2 = Rpeaks(2:end)/fs2;
% figure(5)
% plot(tt2/3600,RR2), xlabel('tiempo (hours)'), ylabel('RR (ms)')
RR2f = filter2(RR2);
figure(5)
plot(tt2/3600,RR2, tt2/3600, RR2f), xlabel('tiempo (hours)'), ylabel('RR (ms)')
title('RR y RRf (filtrado), horas 6 a 12')
%RRTotalf = [RRf;RR2f];
tt2 = tt2+tt(end);
% ttotal = [tt;tt2];
% figure
% plot(ttotal/3600, RRTotalf), xlabel('tiempo (hours)'), ylabel('RR (ms)')
%% 3th block of 6 hours
[~,ecg1] = read_ishne1('F:\Export_RCG_Holter_Livanova\BH0001.ecg',12*3600,6*3600);
ecgII3 = ecg1(:,2).*Resol(1)*1e-6;
ecgII3 = decimate(ecgII3,4);
fs2 = 250;
clear ecg1
% save ecgII3 ecgII3 fs2
ecg1=filtfilt(Bfpa,Afpa,ecgII3);
ecgII3f = filtfilt(Bfpb,Afpb,ecg1);
% [N,~]=size(ecgII3f);
% t=(1:N)'/fs2;
% figure(6)
% plot(t/3600,ecgII3, t/3600, ecgII3f), grid, xlabel('t (hours)'), ylabel('mV')
% title('ECG lead II, horas 12  18'), legend('original','filtrado')
% Detección del QRS (onda R). detecrc() muestra plot, detectrcNP() sin plot
Rpeaks = detecrcNP(ecgII3f,fs2);
RR3 = diff(Rpeaks)/fs2*1000;
tt3 = Rpeaks(2:end)/fs2;
% figure(7)
% plot(tt3/360,RR3), xlabel('tiempo (hours)'), ylabel('RR (ms)')
RR3f = filter1(RR3);
figure(7)
% plot(tt3/3600,RR3, tt3/3600, RR3f), xlabel('tiempo (hours)'), ylabel('RR (ms)')
plot(tt3/3600, RR3f), xlabel('tiempo (hours)'), ylabel('RR (ms)')
title('RR y RRf (filtrado), horas 12 a 18')
%RRTotalf = [RRf;RR2f;RR3f];
tt3 = tt3+tt2(end);
% ttotal = [tt;tt2;tt3];
% figure
% plot(ttotal/3600, RRTotalf), xlabel('tiempo (hours)'), ylabel('RR (ms)')
%% 4th block of 6 hours
% OjO. En paciente BH0007 la señal ECG está hasta las 22,5 horas.
% La última hora y media se quedó encendido el Holter.
% ¡Puede ocurrir en mas pacientes!
[hd,ecg1] = read_ishne1('F:\Export_RCG_Holter_Livanova\BH0001.ecg',18*3600,6*3600);
ecgII4 = ecg1(:,2).*Resol(1)*1e-6;
ecgII4 = decimate(ecgII4,4);
fs2 = 250;
clear ecg1
% save ecgII4 ecgII4 fs2
ecg1=filtfilt(Bfpa,Afpa,ecgII4);
ecgII4f = filtfilt(Bfpb,Afpb,ecg1);
% [N,leads]=size(ecgII4f);
% t=(1:N)'/fs2;
% figure(8)
% plot(t/3600,ecgII4, t/3600, ecgII4f), grid, xlabel('t (hours)'), ylabel('mV')
% title('ECG lead II, horas 18 a 24'), legend('original','filtrado')
% Detección del QRS (onda R). detecrc() muestra plot, detectrcNP() sin plot
Rpeaks = detecrcNP(ecgII4f,fs2);
RR4 = diff(Rpeaks)/fs2*1000;
tt4 = Rpeaks(2:end)/fs2;
% figure
% plot(tt4/360,RR4), xlabel('tiempo (hours)'), ylabel('RR (ms)')
RR4f = filter1(RR4);
figure(9)
plot(tt4/3600,RR4, tt4/3600, RR4f), xlabel('tiempo (hours)'), ylabel('RR (ms)')
title('RR y RRf (filtrado), horas 18 a 24')
RRTotalf = [RRf;RR2f;RR3f;RR4f];
tt4 = tt4+tt3(end);
ttotal = [tt;tt2;tt3;tt4];
% Volvemos a filtrar los RR (mas riguroso: ventana de 10 muestras y 10%
% de desvio de la media de la ventana de 10 muestras
% RRTotalff = filter1(RRTotalf, 10, 15);
RRTotalff = filter1(RRTotalf, 10, 15);
figure(10)
% plot(ttotal/3600, RRTotalf, ttotal/3600, RRTotalff)
plot(ttotal/3600, RRTotalff)
xlabel('tiempo (hours)'), ylabel('RR (ms)')
HR = 1./RRTotalff*60000;
figure(11)
plot(ttotal/3600, HR)
xlabel('tiempo (hours)'), ylabel('HR (latidos/min - bpm)')
title('HR durante 24 h, paciente BH0005')

save RR24h_01 RRTotalf RRTotalff HR ttotal