%% Análisis estadístico TFM Brugada. Pedro Gomis, Sergio Guato 2026.

%% Previo se usa el Guion_concatena_BrS_Control, que carga
% load indexes_HRV_30min.mat
% load indexes_HRV_30minC.mat
Guion_concatena_BrS_Control
% borra los originales BrS y Control luego de concatenarlos
%% Cálculo de la media, mediana y desviación estándar (std) de todos  los biomarcadores

% lnfreqHF
lnfreqHFtotalT = lnRes_freqHF30minT(:,4:51);
medialnfreqHF = mean(lnfreqHFtotalT,2,'omitnan');
medianalnfreqHF = median(lnfreqHFtotalT,2,'omitnan');
stdlnfreqHF = std(lnfreqHFtotalT,0,2,'omitnan');
% A la matriz de resultados del marcador agregamos al final columnas con la
% nmedia, mediana y STD de cada fila (paciente). Columnas 54, 55, 56
% lnRes_freqHF30minT = [lnRes_freqHF30minT medialnfreqHF medianalnfreqHF stdlnfreqHF];

% freqHFnrom
freqHFnormtotalT = Res_freqHFnorm30minT(:,4:51);
mediafreqHFnorm = mean(freqHFnormtotalT,2,'omitnan');
medianafreqHFnorm = median(freqHFnormtotalT,2,'omitnan');
stdfreqHFnorm = std(freqHFnormtotalT,0,2,'omitnan');

% lnfreqLF
lnfreqLFtotalT = lnRes_freqLF30minT(:,4:51);
medialnfreqLF = mean(lnfreqLFtotalT,2,'omitnan');
medianalnfreqLF = median(lnfreqLFtotalT,2,'omitnan');
stdlnfreqLF = std(lnfreqLFtotalT,0,2,'omitnan');
% lnRes_freqLF30minT = [lnRes_freqLF30minT medialnfreqLF medianalnfreqLF stdlnfreqLF];

% freqLFnorm
freqLFnormtotalT = Res_freqLFnorm30minT(:,4:51);
mediafreqLFnorm = mean(freqLFnormtotalT,2,'omitnan');
medianafreqLFnorm = median(freqLFnormtotalT,2,'omitnan');
stdfreqLFnorm = std(freqLFnormtotalT,0,2,'omitnan');

% freqRatio
freqRatiototalT = Res_freqRatio30minT(:,4:51);
mediafreqRatio = mean(freqRatiototalT,2,'omitnan');
medianafreqRatio = median(freqRatiototalT,2,'omitnan');
stdfreqRatio = std(freqRatiototalT,0,2,'omitnan');
% lnRes_freqLF30minT = [lnRes_freqLF30minT mediafreqRatio medianafreqRatio stdfreqRatio];

% DFA
DFAtotalT = Res_DFA30minT(:,4:51);
mediaDFA = mean(DFAtotalT,2,'omitnan');
medianaDFA = median(DFAtotalT,2,'omitnan');
stdDFA = std(DFAtotalT,0,2,'omitnan');
% Res_DFA30minT = [Res_DFA30minT mediaDFA medianaDFA stdDFA];

% HR
HRtotalT = Res_HR30minT(:,4:51);
mediaHR = mean(HRtotalT,2,'omitnan');
medianaHR = median(HRtotalT,2,'omitnan');
stdHR = std(HRtotalT,0,2,'omitnan');
% Res_HR30minT = [Res_HR30minT mediaHR medianaHR stdHR];

% tempRMSSD
tempRMSSDtotalT = Res_tempRMSSD30minT(:,4:51);
mediatempRMSSD = mean(tempRMSSDtotalT,2,'omitnan');
medianatempRMSSD = median(tempRMSSDtotalT,2,'omitnan');
stdtempRMSSD = std(tempRMSSDtotalT,0,2,'omitnan');
% Res_tempRMSSD30minT = [Res_tempRMSSD30minT mediatempRMSSD medianatempRMSSD stdtempRMSSD];

% tempRRmean
tempRRmeantotalT = Res_tempRRmean30minT(:,4:51);
mediatempRRmean = mean(tempRRmeantotalT,2,'omitnan');
medianatempRRmean = median(tempRRmeantotalT,2,'omitnan');
stdtempRRmean = std(tempRRmeantotalT,0,2,'omitnan');
% Res_tempRRmean30minT = [Res_tempRRmean30minT mediatempRRmean medianatempRRmean stdtempRRmean];

% tempSDNN
tempSDNNtotalT = Res_tempSDNN30minT(:,4:51);
mediatempSDNN = mean(tempSDNNtotalT,2,'omitnan');
medianatempSDNN = median(tempSDNNtotalT,2,'omitnan');
stdtempSDNN = std(tempSDNNtotalT,0,2,'omitnan');
% Res_tempSDNN30minT = [Res_tempSDNN30minT mediatempSDNN medianatempSDNN stdtempSDNN];

%% Prueba de normalidad de cada biomrcador (se prueba a la hora 10, segmento 20)

[hNormHF, pNormHF] = lillietest(lnfreqHFtotalT(:,20)); % Normal
[hNormHFnorm, pNormHFnorm] = lillietest(freqHFnormtotalT(:,20)); % Normal
[hNormLF, pNormLF] = lillietest(lnfreqLFtotalT(:,20)); % Normal
[hNormLFnorm, pNormLFnorm] = lillietest(freqLFnormtotalT(:,20)); % Normal
[hNormDFA, pNormDFA] = lillietest(DFAtotalT(:,20)); % Normal
[hNormRatio, pNormRatio] = lillietest(freqRatiototalT(:,20)); % NO normal
[hNormHR, pNormHR] = lillietest(HRtotalT(:,20)); % Normal
[hNormtempRMSSD, pNormtempRMSSD] = lillietest(tempRMSSDtotalT(:,20)); % NO normal
[hNormtempRRmean, pNormtempRRmean] = lillietest(tempRRmeantotalT(:,20)); % Normal
[hNormtempSDNN, pNormtempSDNN] = lillietest(tempSDNNtotalT(:,20)); % NO normal

%% Estadística inferencial de ver diferencias significativas (p<0.05) o no
%  entre sintomáticos y asintomáticos, Se prueba la media y std, 
% para cada biomarcador a lo latrgo de las 24 horas
%% lnfreqHF
% std (desviación estándar del marcador lnfreqHF)
GAsintHFStd = stdlnfreqHF(lnRes_freqHF30minT(:,2)==0); % STD grupo Asintomatico
GSintHFStd = stdlnfreqHF(lnRes_freqHF30minT(:,2)==1); %STD grupo Sintomático
GContHFStd = stdlnfreqHF(lnRes_freqHF30minT(:,2)==2); %STD grupo Control
 %estas líneas las implementamos únicamente para obtener los valores de tabla
MeanGAsintHFStd = mean(GAsintHFStd); 
MeanGSintHFStd = mean(GSintHFStd);
MeanGContHFStd = mean(GContHFStd);
StdGAsintHFStd = std(GAsintHFStd);
StdGSintHFStd = std(GSintHFStd);
StdGContHFStd = std(GContHFStd);
[hHFStd, pHFStd] = ttest2(GAsintHFStd,GSintHFStd); %ttest2 para datos independientes con distribución Normal
[h, p] = ttest2(GAsintHFStd,GContHFStd);
[h, p] = ttest2(GSintHFStd,GContHFStd);
boxplot(stdlnfreqHF,lnRes_freqHF30minT(:,2),'Labels',{'Asintomático','Sintomático', 'Control'})
title('HFStd Asint vs. Sint');

% media (mean del marcador lnfreqHF)
GAsintHFMedia = medialnfreqHF(lnRes_freqHF30minT(:,2)==0);
GSintHFMedia = medialnfreqHF(lnRes_freqHF30minT(:,2)==1);
GContHFMedia = medialnfreqHF(lnRes_freqHF30minT(:,2)==2);
MeanGAsintHFMedia = mean(GAsintHFMedia);
MeanGSintHFMedia = mean(GSintHFMedia);
MeanGContHFMedia = mean(GContHFMedia);
StdGAsintHFMedia = std(GAsintHFMedia);
StdGSintHFMedia = std(GSintHFMedia);
StdGContHFMedia = std(GContHFMedia);
[hHFMedia, pHFMedia] = ttest2(GAsintHFMedia,GSintHFMedia); % Asintom vs Sintom
[hHFMedia, pHFMedia] = ttest2(GAsintHFMedia,GContHFMedia); % Asintom vs Control
[hHFMedia, pHFMedia] = ttest2(GContHFMedia,GSintHFMedia); % Sintom vs Control
[hHFMedia, pHFMedia] = ttest2(GContHFMedia,[GAsintHFMedia;GSintHFMedia]); % Control vs BrS todos
boxplot(medialnfreqHF,lnRes_freqHF30minT(:,2),'Labels',{'Asintomático','Sintomático', 'Control'})
title('HFMedia Asint vs. Sint');

%% freqHFnorm
% std
GAsintHFnormStd = stdfreqHFnorm(Res_freqHFnorm30minT(:,2)==0);
GSintHFnormStd = stdfreqHFnorm(Res_freqHFnorm30minT(:,2)==1);
GContHFnormStd = stdfreqHFnorm(Res_freqHFnorm30minT(:,2)==2);
MeanGAsintHFnormStd = mean(GAsintHFnormStd); 
MeanGSintHFnormStd = mean(GSintHFnormStd);
MeanGContHFnormStd = mean(GContHFnormStd);
StdGAsintHFnormStd = std(GAsintHFnormStd);
StdGSintHFnormStd = std(GSintHFnormStd);
StdGContHFnormStd = std(GContHFnormStd);
[hHFnormStd, pHFnormStd] = ttest2(GAsintHFnormStd,GSintHFnormStd); %ttest2 para datos independientes con distribución Normal
[hHFnormStd, pHFnormStd] = ttest2(GAsintHFnormStd,GContHFnormStd);
[hHFnormStd, pHFnormStd] = ttest2(GContHFnormStd,GSintHFnormStd);
boxplot(stdfreqHFnorm,Res_freqHFnorm30minT(:,2),'Labels',{'Asintomático','Sintomático'})
title('HFnormStd Asint vs. Sint');

% media
GAsintHFnormMedia = mediafreqHFnorm(Res_freqHFnorm30minT(:,2)==0);
GSintHFnormMedia = mediafreqHFnorm(Res_freqHFnorm30minT(:,2)==1);
GContHFnormMedia = mediafreqHFnorm(Res_freqHFnorm30minT(:,2)==2);
MeanGAsintHFnormMedia = mean(GAsintHFnormMedia);
MeanGSintHFnormMedia = mean(GSintHFnormMedia);
MeanGContHFnormMedia = mean(GContHFnormMedia);
StdGAsintHFnormMedia = std(GAsintHFnormMedia);
StdGSintHFnormMedia = std(GSintHFnormMedia);
StdGContHFnormMedia = std(GContHFnormMedia)
[hHFnormMedia, pHFnormMedia] = ttest2(GAsintHFnormMedia,GSintHFnormMedia);
[hHFnormMedia, pHFnormMedia] = ttest2(GAsintHFnormMedia,GContHFnormMedia);
[hHFnormMedia, pHFnormMedia] = ttest2(GContHFnormMedia,GSintHFnormMedia);
boxplot(mediafreqHFnorm,Res_freqHFnorm30minT(:,2),'Labels',{'Asintomático','Sintomático'})
title('HFnormMedia Asint vs. Sint');

%% lnfreqLF
% std
GAsintLFStd = stdlnfreqLF(lnRes_freqLF30minT(:,2)==0);
GSintLFStd = stdlnfreqLF(lnRes_freqLF30minT(:,2)==1);
GContLFStd = stdlnfreqLF(lnRes_freqLF30minT(:,2)==2);
MeanGAsintLFStd = mean(GAsintLFStd); 
MeanGSintLFStd = mean(GSintLFStd);
MeanGContLFStd = mean(GContLFStd)
StdGAsintLFStd = std(GAsintLFStd);
StdGSintLFStd = std(GSintLFStd);
StdGContLFStd = std(GContLFStd)
[hLFStd, pLFStd] = ttest2(GAsintLFStd,GSintLFStd);
[hLFStd, pLFStd] = ttest2(GAsintLFStd,GContLFStd)
[hLFStd, pLFStd] = ttest2(GContLFStd,GSintLFStd)
boxplot(stdlnfreqLF,lnRes_freqLF30minT(:,2),'Labels',{'Asintomático','Sintomático'})
title('LFStd Asint vs. Sint');
% media
GAsintLFMedia = medialnfreqLF(lnRes_freqLF30minT(:,2)==0);
GSintLFMedia = medialnfreqLF(lnRes_freqLF30minT(:,2)==1);
GContLFMedia = medialnfreqLF(lnRes_freqLF30minT(:,2)==2);
MeanGAsintLFMedia = mean(GAsintLFMedia);
MeanGSintLFMedia = mean(GSintLFMedia);
MeanGContLFMedia = mean(GContLFMedia);
StdGAsintLFMedia = std(GAsintLFMedia);
StdGSintLFMedia = std(GSintLFMedia);
StdGContLFMedia = std(GContLFMedia)
[hLFMedia, pLFMedia] = ttest2(GAsintLFMedia,GSintLFMedia);
[hLFMedia, pLFMedia] = ttest2(GAsintLFMedia,GContLFMedia)
[hLFMedia, pLFMedia] = ttest2(GContLFMedia,GSintLFMedia)
boxplot(medialnfreqLF,lnRes_freqLF30minT(:,2),'Labels',{'Asintomático','Sintomático'})
title('LFMedia Asint vs. Sint');

%% freqLFnorm
GAsintLFnormStd = stdfreqLFnorm(Res_freqLFnorm30minT(:,2)==0);
GSintLFnormStd = stdfreqLFnorm(Res_freqLFnorm30minT(:,2)==1);
GContLFnormStd = stdfreqLFnorm(Res_freqLFnorm30minT(:,2)==2);
MeanGAsintLFnormStd = mean(GAsintLFnormStd); 
MeanGSintLFnormStd = mean(GSintLFnormStd);
MeanGContLFnormStd = mean(GContLFnormStd)
StdGAsintLFnormStd = std(GAsintLFnormStd);
StdGSintLFnormStd = std(GSintLFnormStd);
StdGContLFnormStd = std(GContLFnormStd)
[hLFnormStd, pLFnormStd] = ttest2(GAsintLFnormStd,GSintLFnormStd); %ttest2 para datos independientes con distribución Normal
[hLFnormStd, pLFnormStd] = ttest2(GAsintLFnormStd,GContLFnormStd)
[hLFnormStd, pLFnormStd] = ttest2(GContLFnormStd,GSintLFnormStd)
boxplot(stdfreqLFnorm,Res_freqLFnorm30minT(:,2),'Labels',{'Asintomático','Sintomático'})
title('LFnormStd Asint vs. Sint');

GAsintLFnormMedia = mediafreqLFnorm(Res_freqLFnorm30minT(:,2)==0);
GSintLFnormMedia = mediafreqLFnorm(Res_freqLFnorm30minT(:,2)==1);
GContLFnormMedia = mediafreqLFnorm(Res_freqLFnorm30minT(:,2)==2);
MeanGAsintLFnormMedia = mean(GAsintLFnormMedia);
MeanGSintLFnormMedia = mean(GSintLFnormMedia);
MeanGContLFnormMedia = mean(GContLFnormMedia)
StdGAsintLFnormMedia = std(GAsintLFnormMedia);
StdGSintLFnormMedia = std(GSintLFnormMedia);
StdGContLFnormMedia = std(GContLFnormMedia)
[hLFnormMedia, pLFnormMedia] = ttest2(GAsintLFnormMedia,GSintLFnormMedia);
[hLFnormMedia, pLFnormMedia] = ttest2(GAsintLFnormMedia,GContLFnormMedia)
[hLFnormMedia, pLFnormMedia] = ttest2(GContLFnormMedia,GSintLFnormMedia)
boxplot(mediafreqLFnorm,Res_freqLFnorm30minT(:,2),'Labels',{'Asintomático','Sintomático'})
title('LFnormMedia Asint vs. Sint');

%% freqRatio
% std
GAsintRatioStd = stdfreqRatio(Res_freqRatio30minT(:,2)==0);
GSintRatioStd = stdfreqRatio(Res_freqRatio30minT(:,2)==1);
GContRatioStd = stdfreqRatio(Res_freqRatio30minT(:,2)==2);
MedianGAsintRatioStd = median(GAsintRatioStd);
MedianGSintRatioStd = median(GSintRatioStd);
MedianGContRatioStd = median(GContRatioStd);
% InterQuartilRange, Q1(p25), Q3(p75)
[IQRGAsintRatioStd, Q1GAsintRatioStd, Q3GAsintRatioStd] = iqr_nan(GAsintRatioStd);
[IQRGSintRatioStd, Q1GSintRatioStd, Q3GSintRatioStd] = iqr_nan(GSintRatioStd);
[IQRGSintRatioStd, Q1GSintRatioStd, Q3GSintRatioStd] = iqr_nan(GContRatioStd);
[pRatioStd] = ranksum(GAsintRatioStd,GSintRatioStd); %ranksum para datos independientes con distribución NO normal
[pRatioStd] = ranksum(GAsintRatioStd,GContRatioStd)
[pRatioStd] = ranksum(GContRatioStd,GSintRatioStd)
boxplot(stdfreqRatio,lnRes_freqLF30minT(:,2),'Labels',{'Asintomático','Sintomático'})
title('freqRatioStd Asint vs. Sint');
% media
GAsintRatioMedia = mediafreqRatio(Res_freqRatio30minT(:,2)==0);
GSintRatioMedia = mediafreqRatio(Res_freqRatio30minT(:,2)==1);
GContRatioMedia = mediafreqRatio(Res_freqRatio30minT(:,2)==2);
MedianGAsintRatioMedia = median(GAsintRatioMedia);
MedianGSintRatioMedia = median(GSintRatioMedia);
MedianGContRatioMedia = median(GContRatioMedia)
[IQRGAsintRatioMedia, Q1GAsintRatioMedia, Q3GAsintRatioMedia] = iqr_nan(GAsintRatioMedia);
[IQRGSintRatioMedia, Q1GSintRatioMedia, Q3GSintRatioMedia] = iqr_nan(GSintRatioMedia);
[IQRGSintRatioMedia, Q1GSintRatioMedia, Q3GSintRatioMedia] = iqr_nan(GContRatioMedia)
[pRatioMedia] = ranksum(GAsintRatioMedia,GSintRatioMedia);
[pRatioMedia] = ranksum(GAsintRatioMedia,GContRatioMedia)
[pRatioMedia] = ranksum(GContRatioMedia,GSintRatioMedia)
boxplot(mediafreqRatio,lnRes_freqLF30minT(:,2),'Labels',{'Asintomático','Sintomático'})
title('freqRatioMedia Asint vs. Sint');

%% DFA
%std
GAsintDFAStd = stdDFA(Res_DFA30minT(:,2)==0); 
GSintDFAStd = stdDFA(Res_DFA30minT(:,2)==1);
GContDFAStd = stdDFA(Res_DFA30minT(:,2)==2);
MeanGAsintDFAStd = mean(GAsintDFAStd); 
MeanGSintDFAStd = mean(GSintDFAStd);
MeanGContDFAStd = mean(GContDFAStd)
StdGAsintDFAStd = std(GAsintDFAStd);
StdGSintDFAStd = std(GSintDFAStd);
StdGContDFAStd = std(GContDFAStd)
[hDFAStd, pDFAStd] = ttest2(GAsintDFAStd,GSintDFAStd);
[hDFAStd, pDFAStd] = ttest2(GAsintDFAStd,GContDFAStd)
[hDFAStd, pDFAStd] = ttest2(GContDFAStd,GSintDFAStd)
boxplot(stdDFA,Res_DFA30minT(:,2),'Labels',{'Asintomático','Sintomático'})
title('DFAStd Asint vs. Sint');
% media
GAsintDFAMedia = mediaDFA(Res_DFA30minT(:,2)==0);
GSintDFAMedia = mediaDFA(Res_DFA30minT(:,2)==1);
GContDFAMedia = mediaDFA(Res_DFA30minT(:,2)==2);
MeanGAsintDFAMedia = mean(GAsintDFAMedia); 
MeanGSintDFAMedia = mean(GSintDFAMedia);
MeanConttDFAMedia = mean(GContDFAMedia)
StdGAsintDFAMedia = std(GAsintDFAMedia);
StdGContDFAMedia = std(GSintDFAMedia);
StdGSintDFAMedia = std(GContDFAMedia)
[hDFAMedia, pDFAMedia] = ttest2(GAsintDFAMedia,GSintDFAMedia);
[hDFAMedia, pDFAMedia] = ttest2(GAsintDFAMedia,GContDFAMedia)
[hDFAMedia, pDFAMedia] = ttest2(GContDFAMedia,GSintDFAMedia)
boxplot(mediaDFA,Res_DFA30minT(:,2),'Labels',{'Asintomático','Sintomático'})
title('DFAMedia Asint vs. Sint');

%% HR
%std
GAsintHRStd = stdHR(Res_HR30minT(:,2)==0);
GSintHRStd = stdHR(Res_HR30minT(:,2)==1);
GContHRStd = stdHR(Res_HR30minT(:,2)==2);
MeanGAsintHRStd = mean(GAsintHRStd);
MeanGSintHRStd = mean(GSintHRStd);
MeanGContHRStd = mean(GContHRStd);
StdGAsintHRStd = std(GAsintHRStd);
StdGSintHRStd = std(GSintHRStd);
StdGContHRStd = std(GContHRStd);
[hHRStd, pHRStd] = ttest2(GAsintHRStd,GSintHRStd);
[hHRStd, pHRStd] = ttest2(GAsintHRStd,GContHRStd)
[hHRStd, pHRStd] = ttest2(GContHRStd,GSintHRStd)
boxplot(stdHR,Res_HR30minT(:,2),'Labels',{'Asintomático','Sintomático'})
ylim([3.5 18]);
title('HRStd Asint vs. Sint');
ylabel('bpm/min');
% media
GAsintHRMedia = mediaHR(Res_HR30minT(:,2)==0);
GSintHRMedia = mediaHR(Res_HR30minT(:,2)==1);
GContHRMedia = mediaHR(Res_HR30minT(:,2)==2);
MeanGAsintHRMedia = mean(GAsintHRMedia);
MeanGSintHRMedia = mean(GSintHRMedia);
MeanGContHRMedia = mean(GContHRMedia);
StdGAsintHRMedia = std(GAsintHRMedia);
StdGSintHRMedia = std(GSintHRMedia);
StdGContHRMedia = std(GContHRMedia);
[hHRMedia, pHRMedia] = ttest2(GAsintHRMedia,GSintHRMedia);
[hHRMedia, pHRMedia] = ttest2(GAsintHRMedia,GContHRMedia)
[hHRMedia, pHRMedia] = ttest2(GContHRMedia,GSintHRMedia)
boxplot(mediaHR,Res_HR30minT(:,2),'Labels',{'Asintomático','Sintomático'})
title('HRMedia Asint vs. Sint');

%% tempRMSSD
%std
GAsinttempRMSSDStd = stdtempRMSSD(Res_tempRMSSD30minT(:,2)==0);
GSinttempRMSSDStd = stdtempRMSSD(Res_tempRMSSD30minT(:,2)==1);
GConttempRMSSDStd = stdtempRMSSD(Res_tempRMSSD30minT(:,2)==2);
MedianGAsinttempRMSSDStd = median(GAsinttempRMSSDStd);
MedianGSinttempRMSSDStd = median(GSinttempRMSSDStd);
MedianGConttempRMSSDStd = median(GConttempRMSSDStd);
[IQRGAsinttempRMSSDStd, Q1GAsinttempRMSSDStd, Q3GAsinttempRMSSDStd] = iqr_nan(GAsinttempRMSSDStd);
[IQRGSinttempRMSSDStd, Q1GSinttempRMSSDStd, Q3GSinttempRMSSDStd] = iqr_nan(GSinttempRMSSDStd);
[IQRGConttempRMSSDStd, Q1GSinttempRMSSDStd, Q3GSinttempRMSSDStd] = iqr_nan(GConttempRMSSDStd);
[ptempRMSSDStd] = ranksum(GAsinttempRMSSDStd,GSinttempRMSSDStd);
[ptempRMSSDStd] = ranksum(GAsinttempRMSSDStd,GConttempRMSSDStd)
[ptempRMSSDStd] = ranksum(GConttempRMSSDStd,GSinttempRMSSDStd)
boxplot(stdtempRMSSD,Res_tempRMSSD30minT(:,2),'Labels',{'Asintomático','Sintomático'})
title('tempRMSSDStd Asint vs. Sint');
%media
GAsinttempRMSSDMedia = mediatempRMSSD(Res_tempRMSSD30minT(:,2)==0);
GSinttempRMSSDMedia = mediatempRMSSD(Res_tempRMSSD30minT(:,2)==1);
GConttempRMSSDMedia = mediatempRMSSD(Res_tempRMSSD30minT(:,2)==2);
MedianGAsinttempRMSSDMedia = median(GAsinttempRMSSDMedia);
MedianGSinttempRMSSDMedia = median(GSinttempRMSSDMedia);
MedianGConttempRMSSDMedia = median(GConttempRMSSDMedia);
[IQRGAsinttempRMSSDMedia, Q1GAsinttempRMSSDMedia, Q3GAsinttempRMSSDMedia] = iqr_nan(GAsinttempRMSSDMedia);
[IQRGSinttempRMSSDMedia, Q1GSinttempRMSSDMedia, Q3GSinttempRMSSDMedia] = iqr_nan(GSinttempRMSSDMedia);
[IQRGConttempRMSSDMedia, Q1GSinttempRMSSDMedia, Q3GSinttempRMSSDMedia] = iqr_nan(GConttempRMSSDMedia);
[ptempRMSSDMedia] = ranksum(GAsinttempRMSSDMedia,GSinttempRMSSDMedia);
[ptempRMSSDMedia] = ranksum(GAsinttempRMSSDMedia,GConttempRMSSDMedia)
[ptempRMSSDMedia] = ranksum(GConttempRMSSDMedia,GSinttempRMSSDMedia)
boxplot(mediatempRMSSD,Res_tempRMSSD30minT(:,2),'Labels',{'Asintomático','Sintomático'})
title('tempRMSSDMedia Asint vs. Sint');

%% tempRRmean
% std
GAsinttempRRmeanStd = stdtempRRmean(Res_tempRRmean30minT(:,2)==0);
GSinttempRRmeanStd = stdtempRRmean(Res_tempRRmean30minT(:,2)==1);
GConttempRRmeanStd = stdtempRRmean(Res_tempRRmean30minT(:,2)==2);
MeanGAsinttempRRmeanStd = mean(GAsinttempRRmeanStd);
MeanGConttempRRmeanStd = mean(GSinttempRRmeanStd);
MeanGSinttempRRmeanStd = mean(GConttempRRmeanStd);
StdGAsinttempRRmeanStd = std(GAsinttempRRmeanStd);
StdGSinttempRRmeanStd = std(GSinttempRRmeanStd);
StdGConttempRRmeanStd = std(GConttempRRmeanStd)
[htempRRmeanStd, ptempRRmeanStd] = ttest2(GAsinttempRRmeanStd,GSinttempRRmeanStd);
[htempRRmeanStd, ptempRRmeanStd] = ttest2(GAsinttempRRmeanStd,GConttempRRmeanStd)
[htempRRmeanStd, ptempRRmeanStd] = ttest2(GConttempRRmeanStd,GSinttempRRmeanStd)
boxplot(stdtempRRmean,Res_tempRRmean30minT(:,2),'Labels',{'Asintomático','Sintomático'})
ylim([40 195]);
title('tempRRmeanStd Asint vs. Sint');
ylabel('ms');
% media
GAsinttempRRmeanMedia = mediatempRRmean(Res_tempRMSSD30minT(:,2)==0);
GSinttempRRmeanMedia = mediatempRRmean(Res_tempRMSSD30minT(:,2)==1);
GConttempRRmeanMedia = mediatempRRmean(Res_tempRMSSD30minT(:,2)==2);
MeanGAsinttempRRmeanMedia = mean(GAsinttempRRmeanMedia);
MeanGConttempRRmeanMedia= mean(GSinttempRRmeanMedia);
MeanGSinttempRRmeanMedia= mean(GConttempRRmeanMedia)
StdGAsinttempRRmeanMedia = std(GAsinttempRRmeanMedia);
StdGConttempRRmeanMedia = std(GSinttempRRmeanMedia);
StdGSinttempRRmeanMedia = std(GConttempRRmeanMedia)
[htempRRmeanMedia, ptempRRmeanMedia] = ttest2(GAsinttempRRmeanMedia,GSinttempRRmeanMedia);
[htempRRmeanMedia, ptempRRmeanMedia] = ttest2(GAsinttempRRmeanMedia,GConttempRRmeanMedia)
[htempRRmeanMedia, ptempRRmeanMedia] = ttest2(GConttempRRmeanMedia,GSinttempRRmeanMedia)
boxplot(mediatempRRmean,Res_tempRRmean30minT(:,2),'Labels',{'Asintomático','Sintomático'})
title('tempRRmeanMedia Asint vs. Sint');

%% tempSDNN
% std
GAsinttempSDNNStd = stdtempSDNN(Res_tempSDNN30minT(:,2)==0);
GSinttempSDNNStd = stdtempSDNN(Res_tempSDNN30minT(:,2)==1);
GConttempSDNNStd = stdtempSDNN(Res_tempSDNN30minT(:,2)==2)
MedianGAsinttempSDNNStd = median(GAsinttempSDNNStd);
MedianGSinttempSDNNStd = median(GSinttempSDNNStd);
MedianGConttempSDNNStd = median(GConttempSDNNStd)
[IQRGAsinttempSDNNStd, Q1GAsinttempSDNNStd, Q3GAsinttempSDNNStd] = iqr_nan(GAsinttempSDNNStd);
[IQRGSinttempSDNNStd, Q1GSinttempSDNNStd, Q3GSinttempSDNNStd] = iqr_nan(GSinttempSDNNStd);
[IQRGConttempSDNNStd, Q1GSinttempSDNNStd, Q3GSinttempSDNNStd] = iqr_nan(GConttempSDNNStd)
[ptempSDNNStd] = ranksum(GAsinttempSDNNStd,GSinttempSDNNStd);
[ptempSDNNStd] = ranksum(GAsinttempSDNNStd,GConttempSDNNStd)
[ptempSDNNStd] = ranksum(GConttempSDNNStd,GSinttempSDNNStd)
boxplot(stdtempSDNN,Res_tempSDNN30minT(:,2),'Labels',{'Asintomático','Sintomático'})
title('tempSDNNStd Asint vs. Sint');
% media
GAsinttempSDNNMedia = mediatempSDNN(Res_tempSDNN30minT(:,2)==0);
GSinttempSDNNMedia = mediatempSDNN(Res_tempSDNN30minT(:,2)==1);
GConttempSDNNMedia = mediatempSDNN(Res_tempSDNN30minT(:,2)==2);
MedianGAsinttempSDNNMedia = median(GAsinttempSDNNMedia);
MedianGSinttempSDNNMedia = median(GSinttempSDNNMedia);
MedianGConttempSDNNMedia = median(GConttempSDNNMedia)
[IQRGAsinttempSDNNMedia, Q1GAsinttempSDNNMedia, Q3GAsinttempSDNNMedia] = iqr_nan(GAsinttempSDNNMedia);
[IQRGSinttempSDNNMedia, Q1GSinttempSDNNMedia, Q3GSinttempSDNNMedia] = iqr_nan(GSinttempSDNNMedia);
[IQRGConttempSDNNMedia, Q1GSinttempSDNNMedia, Q3GSinttempSDNNMedia] = iqr_nan(GConttempSDNNMedia)
[ptempSDNNMedia] = ranksum(GAsinttempSDNNMedia,GSinttempSDNNMedia);
[ptempSDNNMedia] = ranksum(GAsinttempSDNNMedia,GConttempSDNNMedia)
[ptempSDNNMedia] = ranksum(GConttempSDNNMedia,GSinttempSDNNMedia)
boxplot(mediatempSDNN,Res_tempSDNN30minT(:,2),'Labels',{'Asintomático','Sintomático'})
title('tempSDNNMedia Asint vs. Sint');

%% Cálculo estadística entre Día Control y Noche Control (apareados/dependientes)  
% se toma una ventana de 30 min de día y otra de noche
% con todos los biomarcadores
% lnfreqHF
Asint = lnRes_freqHF30minT(:,2) == 0;
HFAsintDia = lnRes_freqHF30minT(Asint,52);
HFAsintNoche = lnRes_freqHF30minT(Asint,53);
SintHF = lnRes_freqHF30minT(:,2) == 1;
HFSintDia = lnRes_freqHF30minT(SintHF,52);
HFSintNoche = lnRes_freqHF30minT(SintHF,53);
% Filtramos los pacientes Control
ContHF = lnRes_freqHF30minT(:,2) == 2;
HFContDia = lnRes_freqHF30minT(ContHF,52);
HFContNoche = lnRes_freqHF30minT(ContHF,53);
MeanHFSintDia = mean(HFContDia);
MeanHFSintNoche = mean(HFContNoche);
StdHFSintDia = std(HFContDia)
StdHFSintNoche = std(HFContNoche)
[hHFSint, pHFSint] = ttest(HFContDia, HFContNoche);
boxplot([HFContDia, HFContNoche], 'Labels', {'Día', 'Noche'})
title('HFSint. Día vs Noche');

% freqHFnorm
HFnormAsintDia = Res_freqHFnorm30minT(Asint,52);
HFnormAsintNoche = Res_freqHFnorm30minT(Asint,53);
SintHFnorm = Res_freqHFnorm30minT(:,2) == 1;
HFnormSintDia = Res_freqHFnorm30minT(SintHFnorm,52);
HFnormSintNoche = Res_freqHFnorm30minT(SintHFnorm,53);
ContHFnorm = Res_freqHFnorm30minT(:,2) == 2;

HFnormContDia = Res_freqHFnorm30minT(ContHFnorm,52);
HFnormContNoche = Res_freqHFnorm30minT(ContHFnorm,53);
MeanHFnormSintDia = mean(HFnormContDia)
MeanHFnormSintNoche = mean(HFnormContNoche)
StdHFnormSintDia = std(HFnormContDia)
StdHFnormSintNoche = std(HFnormContNoche)
[hHFnormSint, pHFnormSint] = ttest(HFnormContDia, HFnormContNoche);
boxplot([HFnormContDia, HFnormContNoche], 'Labels', {'Día', 'Noche'})
title('HFSint. Día vs Noche');

% lnfreqLF
LFAsintDia = lnRes_freqLF30minT(Asint,52);
LFAsintNoche = lnRes_freqLF30minT(Asint,53)
SintLF = lnRes_freqLF30minT(:,2) == 1;
LFSintDia = lnRes_freqLF30minT(SintLF,52);
LFSintNoche = lnRes_freqLF30minT(SintLF,53);
ContLF = lnRes_freqLF30minT(:,2) == 2;

LFContDia = lnRes_freqLF30minT(ContLF,52);
LFContNoche = lnRes_freqLF30minT(ContLF,53);
MeanLFSintDia = mean(LFContDia)
MeanLFSintNoche = mean(LFContNoche)
StdLFSintDia = std(LFContDia)
StdLFSintNoche = std(LFContNoche)
[hLFSint, pLFSint] = ttest(LFContDia, LFContNoche)
boxplot([LFContDia, LFContNoche], 'Labels', {'Día', 'Noche'})
title('LFSint. Día vs Noche');

% freqLFnorm
LFnormAsintDia = Res_freqLFnorm30minT(Asint,52);
LFnormAsintNoche = Res_freqLFnorm30minT(Asint,53);
SintLFnorm = Res_freqLFnorm30minT(:,2) == 1;

LFnormSintDia = Res_freqLFnorm30minT(SintLFnorm,52);
LFnormSintNoche = Res_freqLFnorm30minT(SintLFnorm,53);
ContLFnorm = Res_freqLFnorm30minT(:,2) == 2;

LFnormContDia = Res_freqLFnorm30minT(ContLFnorm,52);
LFnormContNoche = Res_freqLFnorm30minT(ContLFnorm,53);
MeanLFnormSintDia = mean(LFnormContDia)
MeanLFnormSintNoche = mean(LFnormContNoche)
StdLFnormSintDia = std(LFnormContDia)
StdLFnormSintNoche = std(LFnormContNoche)
[hLFnormSint, pLFnormSint] = ttest(LFnormContDia, LFnormContNoche);
boxplot([LFnormContDia, LFnormContNoche], 'Labels', {'Día', 'Noche'})
title('LFSint. Día vs Noche');

% DFA
DFAAsintDia = Res_DFA30minT(Asint,52);
DFAAsintNoche = Res_DFA30minT(Asint,53);
SintDFA = Res_DFA30minT(:,2) == 1;
DFASintDia = Res_DFA30minT(SintDFA,52);
DFASintNoche = Res_DFA30minT(SintDFA,53);
ContDFA = Res_DFA30minT(:,2) == 2;

DFAContDia = Res_DFA30minT(ContDFA,52);
DFAContNoche = Res_DFA30minT(ContDFA,53);
MeanDFASintDia = mean(DFAContDia)
MeanDFASintNoche = mean(DFAContNoche)
StdDFASintDia = std(DFAContDia)
StdDFASintNoche = std(DFAContNoche)
[hDFASint, pDFASint] = ttest(DFAContDia, DFAContNoche)
boxplot([DFAContDia, DFAContNoche], 'Labels', {'Día', 'Noche'})
title('DFACont. Día vs Noche');

% freqRatio
RatioAsintDia = Res_freqRatio30minT(Asint,52);
RatioAsintNoche = Res_freqRatio30minT(Asint,53);
SintRatio = Res_freqRatio30minT(:,2) == 1;

RatioSintDia = Res_freqRatio30minT(SintRatio,52);
RatioSintNoche = Res_freqRatio30minT(SintRatio,53);
ContRatio = Res_freqRatio30minT(:,2) == 2;

RatioContDia = Res_freqRatio30minT(ContRatio,52);
RatioContNoche = Res_freqRatio30minT(ContRatio,53);
MedianRatioSintDia = median(RatioContDia)
MedianRatioSintNoche = median(RatioContNoche)
[IQRRatioSintDia, Q1RatioSintDia, Q3RatioSintDia] = iqr_nan(RatioContDia)
[IQRRatioSintNoche, Q1RatioSintNoche, Q3RatioSintNoche] = iqr_nan(RatioContNoche)
[pRatioSint] = signrank(RatioContDia, RatioContNoche)
boxplot([RatioContDia, RatioContNoche], 'Labels', {'Día', 'Noche'})
title('RatioSint. Día vs Noche');

% HR
HRAsintDia = Res_HR30minT(Asint,52);
HRAsintNoche = Res_HR30minT(Asint,53);
SintHR = Res_HR30minT(:,2) == 1;

HRSintDia = Res_HR30minT(SintHR,52);
HRSintNoche = Res_HR30minT(SintHR,53);
ContHR = Res_HR30minT(:,2) == 2;

HRContDia = Res_HR30minT(ContHR,52);
HRContNoche = Res_HR30minT(ContHR,53);
MeanHRSintDia = mean(HRContDia)
MeanHRSintNoche = mean(HRContNoche)
StdHRSintDia = std(HRContDia)
StdHRSintNoche = std(HRContNoche)
[hHRSint, pHRSint] = ttest(HRContDia, HRContNoche)
boxplot([HRContDia, HRContNoche], 'Labels', {'Día', 'Noche'})
title('HRCont. Día vs Noche');

% tempRMSSD
RMSSDAsintDia = Res_tempRMSSD30minT(Asint,52);
RMSSDAsintNoche = Res_tempRMSSD30minT(Asint,53);
SintRMSSD = Res_tempRMSSD30minT(:,2) == 1;

RMSSDSintDia = Res_tempRMSSD30minT(SintRMSSD,52);
RMSSDSintNoche = Res_tempRMSSD30minT(SintRMSSD,53);
ContRMSSD = Res_tempRMSSD30minT(:,2) == 2;

RMSSDContDia = Res_tempRMSSD30minT(ContRMSSD,52);
RMSSDContNoche = Res_tempRMSSD30minT(ContRMSSD,53);
MedianRMSSDSintDia = median(RMSSDContDia)
MedianRMSSDSintNoche = median(RMSSDContNoche)
[IQRRMSSDSintDia, Q1RMSSDSintDia, Q3RMSSDSintDia] = iqr_nan(RMSSDContDia)
[IQRRMSSDSintNoche, Q1RMSSDSintNoche, Q3RMSSDSintNoche] = iqr_nan(RMSSDContNoche)
[pRMSSDSint] = signrank(RMSSDContDia, RMSSDContNoche)
boxplot([RMSSDContDia, RMSSDContNoche], 'Labels', {'Día', 'Noche'})
title('RMSSDSint. Día vs Noche');

% tempRRmean
RRmeanAsintDia = Res_tempRRmean30minT(Asint,52);
RRmeanAsintNoche = Res_tempRRmean30minT(Asint,53);
SintRRmean = Res_tempRRmean30minT(:,2) == 1;

RRmeanSintDia = Res_tempRRmean30minT(SintRRmean,52);
RRmeanSintNoche = Res_tempRRmean30minT(SintRRmean,53);
ContRRmean = Res_tempRRmean30minT(:,2) == 2;

RRmeanContDia = Res_tempRRmean30minT(ContRRmean,52);
RRmeanContNoche = Res_tempRRmean30minT(ContRRmean,53);
MeanRRmeanSintDia = mean(RRmeanContDia)
MeanRRmeanSintNoche = mean(RRmeanContNoche)
StdRRmeanSintDia = std(RRmeanContDia)
StdRRmeanSintNoche = std(RRmeanContNoche)
[hRRmeanSint, pRRmeanSint] = ttest(RRmeanContDia, RRmeanContNoche)
boxplot([RRmeanContDia, RRmeanContNoche], 'Labels', {'Día', 'Noche'})
title('RRmeanSint. Día vs Noche');

% tempSDNN
SDNNAsintDia = Res_tempSDNN30minT(Asint,52);
SDNNAsintNoche = Res_tempSDNN30minT(Asint,53);
SintSDNN = Res_tempSDNN30minT(:,2) == 1; 
SDNNSintDia = Res_tempSDNN30minT(SintSDNN,52);
SDNNSintNoche = Res_tempSDNN30minT(SintSDNN,53);
ContSDNN = Res_tempSDNN30minT(:,2) == 2; 

SDNNContDia = Res_tempSDNN30minT(ContSDNN,52);
SDNNContNoche = Res_tempSDNN30minT(ContSDNN,53);
MedianSDNNSintDia = median(SDNNContDia)
MedianSDNNSintNoche = median(SDNNContNoche)
[IQRSDNNSintDia, Q1SDNNSintDia, Q3SDNNSintDia] = iqr_nan(SDNNContDia)
[IQRSDNNSintNoche, Q1SDNNSintNoche, Q3SDNNSintNoche] = iqr_nan(SDNNContNoche)
[pSDNNSint] = signrank(SDNNContDia, SDNNContNoche)
boxplot([SDNNContDia, SDNNContNoche], 'Labels', {'Día', 'Noche'})
title('SDNNSint. Día vs Noche');

%% Cálulos estadísticos entre DíaAsint y DíaSint (independientes) con todos los biomarcadores

%lnfreqHF
[hHFDia, pHFDia] = ttest2(HFAsintDia, HFSintDia); 
[hHFDia, pHFDia] = ttest2(HFAsintDia, HFContDia)
[hHFDia, pHFDia] = ttest2(HFContDia, HFSintDia)
HFDia = [HFAsintDia; HFSintDia; HFContDia];             
grupo = [repmat({'Asintomático'}, length(HFAsintDia), 1); repmat({'Sintomático'}, length(HFSintDia), 1); repmat({'Control'}, length(HFContDia), 1)]; 
boxplot(HFDia, grupo)
title('HFDía Asint. vs Sint. vs. Control')

%freqHFnorm
[hHFnormDia, pHFnormDia] = ttest2(HFnormAsintDia, HFnormSintDia); 
[hHFnormDia, pHFnormDia] = ttest2(HFnormAsintDia, HFnormContDia)
[hHFnormDia, pHFnormDia] = ttest2(HFnormSintDia, HFnormContDia);
HFnormDia = [HFnormAsintDia; HFnormContDia];             
grupo = [repmat({'Asintomático'}, length(HFnormAsintDia), 1); repmat({'Sintomático'}, length(HFnormContDia), 1)]; 
boxplot(HFnormDia, grupo)
title('HFnormDía Asint. vs Sint.')

%lnfreqLF
[hLFDia, pLFDia] = ttest2(LFAsintDia, LFSintDia)
[hLFDia, pLFDia] = ttest2(LFAsintDia, LFContDia)
[hLFDia, pLFDia] = ttest2(LFSintDia, LFContDia)
LFDia = [LFAsintDia; LFContDia];             
grupo = [repmat({'Asintomático'}, length(LFAsintDia), 1); repmat({'Sintomático'}, length(LFContDia), 1)]; 
boxplot(LFDia, grupo)
title('LFDía Asint. vs Sint.')

%freqLFnorm
[hLFnormDia, pLFnormDia] = ttest2(LFnormAsintDia, LFnormSintDia)
[hLFnormDia, pLFnormDia] = ttest2(LFnormAsintDia, LFnormContDia)
[hLFnormDia, pLFnormDia] = ttest2(LFnormSintDia, LFnormContDia)

LFnormDia = [LFnormAsintDia; LFnormSintDia];
grupo = [repmat({'Asintomático'}, length(LFnormAsintDia), 1); repmat({'Sintomático'}, length(LFnormContDia), 1)]; 
boxplot(LFnormDia, grupo)
title('LFnormDía Asint. vs Sint.')

%DFA
[hDFADia, pDFADia] = ttest2(DFAAsintDia, DFASintDia)
[hDFADia, pDFADia] = ttest2(DFAAsintDia, DFAContDia)
[hDFADia, pDFADia] = ttest2(DFASintDia, DFAContDia)
DFADia = [DFAAsintDia; DFAContDia];             
grupo = [repmat({'Asintomático'}, length(DFAAsintDia), 1); repmat({'Sintomático'}, length(DFAContDia), 1)]; 
boxplot(DFADia, grupo)
title('DFADía Asint. vs Sint.')

%freqRatio
[pRatioDia] = ranksum(RatioAsintDia, RatioSintDia)
[pRatioDia] = ranksum(RatioAsintDia, RatioContDia)
[pRatioDia] = ranksum(RatioSintDia, RatioContDia)
RatioDia = [RatioAsintDia; RatioContDia];             
grupo = [repmat({'Asintomático'}, length(RatioAsintDia), 1); repmat({'Sintomático'}, length(RatioContDia), 1)]; 
boxplot(RatioDia, grupo)
title('RatioDía Asint. vs Sint.')

%HR
[hHRDia, pHRDia] = ttest2(HRAsintDia, HRSintDia)
[hHRDia, pHRDia] = ttest2(HRAsintDia, HRContDia)
[hHRDia, pHRDia] = ttest2(HRSintDia, HRContDia)
HRDia = [HRAsintDia; HRContDia];             
grupo = [repmat({'Asintomático'}, length(HRAsintDia), 1); repmat({'Sintomático'}, length(HRContDia), 1)]; 
boxplot(HRDia, grupo)
title('HRDía Asint. vs Sint.')

%tempRMSSD
[pRMSSDDia] = ranksum(RMSSDAsintDia, RMSSDSintDia)
[pRMSSDDia] = ranksum(RMSSDAsintDia, RMSSDContDia)
[pRMSSDDia] = ranksum(RMSSDSintDia, RMSSDContDia)

RMSSDDia = [RMSSDAsintDia; RMSSDContDia];             
grupo = [repmat({'Asintomático'}, length(RMSSDAsintDia), 1); repmat({'Sintomático'}, length(RMSSDContDia), 1)]; 
boxplot(RMSSDDia, grupo)
title('RMSSDDía Asint. vs Sint.')

%tempRRmean
[hRRmeanDia, pRRmeanDia] = ttest2(RRmeanAsintDia, RRmeanSintDia)
[hRRmeanDia, pRRmeanDia] = ttest2(RRmeanAsintDia, RRmeanContDia)
[hRRmeanDia, pRRmeanDia] = ttest2(RRmeanSintDia, RRmeanContDia)
RRmeanDia = [RRmeanAsintDia; RRmeanContDia];             
grupo = [repmat({'Asintomático'}, length(RRmeanAsintDia), 1); repmat({'Sintomático'}, length(RRmeanContDia), 1)]; 
boxplot(RRmeanDia, grupo)
title('RRmeanDía Asint. vs Sint.')

%tempSDNN
[pSDNNDia] = ranksum(SDNNAsintDia, SDNNSintDia)
[pSDNNDia] = ranksum(SDNNAsintDia, SDNNContDia)
[pSDNNDia] = ranksum(SDNNSintDia, SDNNContDia)
SDNNDia = [SDNNAsintDia; SDNNContDia];             
grupo = [repmat({'Asintomático'}, length(SDNNAsintDia), 1); repmat({'Sintomático'}, length(SDNNContDia), 1)]; 
boxplot(SDNNDia, grupo)
title('SDNNDía Asint. vs Sint.')

%% Cálulos estadísticos entre NocheAsint y NocheSint (independientes) con todos los biomarcadores

%lnfreqHF
[hHFNoche, pHFNoche] = ttest2(HFAsintNoche, HFSintNoche)
[hHFNoche, pHFNoche] = ttest2(HFAsintNoche, HFContNoche)
[hHFNoche, pHFNoche] = ttest2(HFContNoche, HFSintNoche)
figure
HFNoche = [HFAsintNoche; HFSintNoche; HFContNoche];             
grupo = [repmat({'Asintomático'}, length(HFAsintNoche), 1); repmat({'Sintomático'}, length(HFSintNoche), 1); repmat({'Control'}, length(HFContNoche), 1)]; 
boxplot(HFNoche, grupo)
title('HF Noche Asint. vs Sint. vs Control')
            


%freqHFnorm
[hHFnormNoche, pHFnormNoche] = ttest2(HFnormAsintNoche, HFnormSintNoche)
[hHFnormNoche, pHFnormNoche] = ttest2(HFnormAsintNoche, HFnormContNoche)
[hHFnormNoche, pHFnormNoche] = ttest2(HFnormSintNoche, HFnormContNoche) 

HFnormNoche = [HFnormAsintNoche; HFnormContNoche];             
grupo = [repmat({'Asintomático'}, length(HFnormAsintNoche), 1); repmat({'Sintomático'}, length(HFnormContNoche), 1)]; 
boxplot(HFnormNoche, grupo)
title('HFnormNoche Asint. vs Sint.')

%lnfreqLF
[hLFNoche, pLFNoche] = ttest2(LFAsintNoche, LFSintNoche)
[hLFNoche, pLFNoche] = ttest2(LFAsintNoche, LFContNoche)
[hLFNoche, pLFNoche] = ttest2(LFSintNoche, LFContNoche)

LFNoche = [LFAsintNoche; LFContNoche];             
grupo = [repmat({'Asintomático'}, length(LFAsintNoche), 1); repmat({'Sintomático'}, length(LFContNoche), 1)]; 
boxplot(LFNoche, grupo)
title('LFNoche Asint. vs Sint.')

%freqLFnorm
[hLFnormNoche, pLFnormNoche] = ttest2(LFnormAsintNoche, LFnormSintNoche)
[hLFnormNoche, pLFnormNoche] = ttest2(LFnormAsintNoche, LFnormContNoche)
[hLFnormNoche, pLFnormNoche] = ttest2(LFnormSintNoche, LFnormContNoche)

LFnormNoche = [LFnormAsintNoche; LFnormContNoche];             
grupo = [repmat({'Asintomático'}, length(LFnormAsintNoche), 1); repmat({'Sintomático'}, length(LFnormContNoche), 1)]; 
boxplot(LFnormNoche, grupo)
title('LFnormNoche Asint. vs Sint.')

%DFA
[hDFANoche, pDFANoche] = ttest2(DFAAsintNoche, DFASintNoche)
[hDFANoche, pDFANoche] = ttest2(DFAAsintNoche, DFAContNoche)
[hDFANoche, pDFANoche] = ttest2(DFASintNoche, DFAContNoche)

DFANoche = [DFAAsintNoche; DFAContNoche];             
grupo = [repmat({'Asintomático'}, length(DFAAsintNoche), 1); repmat({'Sintomático'}, length(DFAContNoche), 1)]; 
boxplot(DFANoche, grupo)
title('DFANoche Asint. vs Sint.')

%freqRatio
[pRatioNoche] = ranksum(RatioAsintNoche, RatioSintNoche)
[pRatioNoche] = ranksum(RatioAsintNoche, RatioContNoche)
[pRatioNoche] = ranksum(RatioSintNoche, RatioContNoche)
RatioNoche = [RatioAsintNoche; RatioContNoche];             
grupo = [repmat({'Asintomático'}, length(RatioAsintNoche), 1); repmat({'Sintomático'}, length(RatioContNoche), 1)]; 
boxplot(RatioNoche, grupo)
title('RatioNoche Asint. vs Sint.')

%HR
[hHRNoche, pHRNoche] = ttest2(HRAsintNoche, HRSintNoche)
[hHRNoche, pHRNoche] = ttest2(HRAsintNoche, HRContNoche)
[hHRNoche, pHRNoche] = ttest2(HRSintNoche, HRContNoche)

HRNoche = [HRAsintNoche; HRContNoche];             
grupo = [repmat({'Asintomático'}, length(HRAsintNoche), 1); repmat({'Sintomático'}, length(HRContNoche), 1)]; 
boxplot(HRNoche, grupo)
title('HRNoche Asint. vs Sint.')

%tempRMSSD
[pRMSSDNoche] = ranksum(RMSSDAsintNoche, RMSSDSintNoche)
[pRMSSDNoche] = ranksum(RMSSDAsintNoche, RMSSDContNoche)
[pRMSSDNoche] = ranksum(RMSSDSintNoche, RMSSDContNoche)

RMSSDNoche = [RMSSDAsintNoche; RMSSDContNoche];             
grupo = [repmat({'Asintomático'}, length(RMSSDAsintNoche), 1); repmat({'Sintomático'}, length(RMSSDContNoche), 1)]; 
boxplot(RMSSDNoche, grupo)
title('RMSSDNoche Asint. vs Sint.')

%tempRRmean
[hRRmeanNoche, pRRmeanNoche] = ttest2(RRmeanAsintNoche, RRmeanSintNoche)
[hRRmeanNoche, pRRmeanNoche] = ttest2(RRmeanAsintNoche, RRmeanContNoche)
[hRRmeanNoche, pRRmeanNoche] = ttest2(RRmeanSintNoche, RRmeanContNoche)

RRmeanNoche = [RRmeanAsintNoche; RRmeanContNoche];             
grupo = [repmat({'Asintomático'}, length(RRmeanAsintNoche), 1); repmat({'Sintomático'}, length(RRmeanContNoche), 1)]; 
boxplot(RRmeanNoche, grupo)
title('RRmeanNoche Asint. vs Sint.')

%tempSDNN
[pSDNNNoche] = ranksum(SDNNAsintNoche, SDNNSintNoche)
[pSDNNNoche] = ranksum(SDNNAsintNoche, SDNNContNoche)
[pSDNNNoche] = ranksum(SDNNSintNoche, SDNNContNoche)
figure
SDNNNoche = [SDNNAsintNoche; SDNNSintNoche; SDNNContNoche];             
grupo = [repmat({'Asintomático'}, length(SDNNAsintNoche), 1); repmat({'Sintomático'}, length(SDNNSintNoche), 1); repmat({'Control'}, length(SDNNContNoche), 1)]; 
boxplot(SDNNNoche, grupo)
title('SDNN Noche Asint. vs Sint. vs Control')

