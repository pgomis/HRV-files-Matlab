%% Script computes HRV time, frequency and DFA (alpha) values
%  
%  uses calc_HRVshort
% P Gomis, 2021
% patients=[1:8, 10:40, 42:46];
patients=[1:8, 10:20, ];
%patients=[1,3:6,8:12,14:19,21,22,25,27:32,34,35,40,42,43,45,46];
% Result5min=zeros(length(patients),51);
% Result5min(:,1)=patients';
% segments=(1:5);
Result30min=NaN(length(patients),481);  %48 segment * 10 biomarcador + 1 (# paciente)
Result30min(:,1)=patients';
for i=1:length(patients)
    % n = segment30min(patients(i)); % se puede omitir si ya se han
    % ejecutado
    numPat=num2str(patients(i));
    if patients(i)<10
        numPat =['0' numPat];
    end
    v =genvarname(['RR_' numPat]);
    eval([ 'load '  v])  %i.e. load RR_05
    for ii=1:n
        %eval([ 'load '  v])
        numSeg=num2str(ii);
%         if segments(n)<10
%             numSeg =['0' numSeg];
%         end
        v1=genvarname(['RRdata' numSeg ]);
        eval(['RRf = ' v1 '(:,2);'])
        eval(['tt = ' v1 '(:,1);'])
        tt = tt-tt(1);
        data30min = [tt, RRf];
        %v1=genvarname(['RRf' numSeg ]);
        %v2=genvarname(['tt' numSeg ]);
        %eval(['data5min=([' v2 ' ' v1 ']);'])
        [P,E,HR,a]=calc_HRVshort(data30min);
        position = 2+((ii-1)*10);
        Result30min(i,position:(position+9))=[P(3:7)' E(1:3)' HR(1:1) a(1:1)];
        %save indixesHRV_segments5min.mat
        clear a data P E HR num* P t*
    end
end

%% Adaptado a segmentos a n segementos de 30 min c/u
%lnFREQ=log(Result5min(:,[2:5 7]));
Res_freqLF30min= Result30min(:,[1 2:10:end]);
Res_freqLFnorm30min= Result30min(:,[1 3:10:end]);
Res_freqHF30min= Result30min(:,[1 4:10:end]);
Res_freqHFnorm30min= Result30min(:,[1 5:10:end]);
Res_freqRatio30min= Result30min(:,[1 6:10:end]);
Res_tempRRmean30min=Result30min(:,[1 7:10:end]);
Res_tempSDNN30min=Result30min(:,[1 8:10:end]);
Res_tempRMSSD30min=Result30min(:,[1 9:10:end]);
Res_HR30min = Result30min(:,[1 10:10:end]);
Res_DFA30min = Result30min(:,[1 11:10:end]);
save indexes_HRV_30min Result30min Res_freqLF30min Res_freqLFnorm30min Res_freqHF30min Res_freqHFnorm30min Res_freqRatio30min Res_tempRRmean30min Res_tempSDNN30min Res_tempRMSSD30min Res_HR30min Res_DFA30min

% Res_freqLF= Result30min(:,[1 2:10:end]);
% Res_freqLFnorm= Result30min(:,[1 3:10:end]);
% % Res_DFA5min = Result30min(:,[1 11:10:51]);
%xlswrite('res_freq5min.xls', Res_freq5min);  % formato antiguo para salvar
% writematrix(Res_freq5min, 'res_freq5min.xls')
writematrix(Res_freqLF30min, 'res_freqLF30min.xls')
writematrix(Res_freqLFnorm30min, 'res_freqLFnorm30min.xls')
writematrix(Res_freqHF30min, 'res_freqHF30min.xls')
writematrix(Res_freqHFnorm30min, 'res_freqHFnorm30min.xls')
writematrix(Res_freqRatio30min, 'res_freqRatio30min.xls')
writematrix(Res_tempRRmean30min, 'res_tempRRmean30min.xls')
writematrix(Res_tempSDNN30min, 'res_tempSDNN30min.xls')
writematrix(Res_tempRMSSD30min, 'res_tempRMSSD30min.xls')
writematrix(Res_HR30min, 'res_HR30min.xls')
writematrix(Res_DFA30min, 'res_DFA30min.xls')
% A menudo se suele guardar los valores de HF y LF en escala logarítmica.
% Los valores de LF y HF suelen tener una distribución sesgada (no normal)
% y se realizan transformaciones con logaritmo natural (ln) para estos 
% índices espectrales de potencia. Sería:
lnRes_freqLF30min = [Res_freqLF30min(:,1) log(Res_freqLF30min(:,2:end))];
lnRes_freqHF30min = [Res_freqHF30min(:,1) log(Res_freqHF30min(:,2:end))];
writematrix(lnRes_freqLF30min, 'lnres_freqLF30min.xls')
writematrix(lnRes_freqHF30min, 'lnres_freqHF30min.xls')
save indexes_HRV_30min.mat lnRes_freqLF30min lnRes_freqHF30min -append