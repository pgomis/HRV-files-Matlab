%% guión concatenar Marcadores BrS y Controles
load indexes_HRV_30min.mat
load indexes_HRV_30minC.mat
% Concatena Matriz de resultados totales: [numPat 480marcadores] 481 colum
Result30minT = [Result30min; Result30minC];
% Concatena cada marcador. Tienen columnas 2 y 3: tipo y sexo, columnas 52
% y 53 día y noche: [NumPat tipo sexo 480 marcad (10*48segm) dia noche]
% Concatena marcadores frecuenciales
lnRes_freqHF30minT = [lnRes_freqHF30min; lnRes_freqHF30minC];
lnRes_freqLF30minT = [lnRes_freqLF30min; lnRes_freqLF30minC];
Res_freqHFnorm30minT = [Res_freqHFnorm30min; Res_freqHFnorm30minC];
Res_freqLFnorm30minT = [Res_freqLFnorm30min; Res_freqLFnorm30minC];
Res_freqRatio30minT = [Res_freqRatio30min; Res_freqRatio30minC];
% Concatena marcadores temporales y fractales
Res_HR30minT = [Res_HR30min; Res_HR30minC];
Res_tempRRmean30minT = [Res_tempRRmean30min; Res_tempRRmean30minC];
Res_tempSDNN30minT = [Res_tempSDNN30min; Res_tempSDNN30minC];
Res_tempRMSSD30minT = [Res_tempRMSSD30min; Res_tempRMSSD30minC];
Res_DFA30minT = [Res_DFA30min; Res_DFA30minC];
% Borrar los marcadores de BrS y Control separados
clear lnRes_freqHF30min lnRes_freqHF30minC lnRes_freqLF30min lnRes_freqLF30minC
clear Res_DFA30min Res_DFA30minC Res_freqHF30min Res_freqHF30minC 
clear Res_freqHFnorm30min Res_freqHFnorm30minC Res_freqLF30min Res_freqLF30minC
clear Res_freqLFnorm30min Res_freqLFnorm30minC Res_freqRatio30min Res_freqRatio30minC
clear Res_HR30min Res_HR30minC Res_tempRMSSD30min Res_tempRMSSD30minC
clear Res_tempRRmean30min Res_tempRRmean30minC Res_tempSDNN30min Res_tempSDNN30minC
clear Result30min Result30minC
save indexes_HRV_30minT