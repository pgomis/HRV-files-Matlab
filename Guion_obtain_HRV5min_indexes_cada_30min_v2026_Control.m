%% Script computes HRV time, frequency and DFA (alpha) values
%  
%  uses calc_HRVshort
% P Gomis, 2021, Nahia Soto, 2025, Sergio Guato, 2026
patients=[1,2,5:9, 11:12, 15:17, 19, 22:24, 26:27, 30:32, 35:37, 39,...
    45, 47:50, 52:53, 56, 60, 62, 77, 81, 93]; % Controles (38)
% Se crea Results30minC con valores NaN de filas = Num de personas Control (38) 
% y columnas = 48 segmentos * 10 HRV indices + 1 columna (# del paciente)
Result30minC=NaN(length(patients),481);  %48 segment * 10 biomarcador + 1 (# paciente)
Result30minC(:,1)=patients'+500; % num Control + 500 para diferenciarlo de BrS
for i=1:length(patients)
    % n = segment30min2(patients(i)); % se puede omitir si ya se han
    % ejecutado y obtenido los RRxx.mat segmentados
    numPat=num2str(patients(i));
    if patients(i)<10
        numPat =['0' numPat];
    end
    v =genvarname(['RR_c' numPat]);
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
        Result30minC(i,position:(position+9))=[P(3:7)' E(1:3)' HR(1:1) a(1:1)];
        %save indixesHRV_segments5min.mat
        clear a data P E HR num* P t*
    end
end
%% Adaptado a n segementos de 30 min c/u

% Definimos control (2), BrS sintomático (1) y BrS no sintomatico (0)
sintomatico = 2*ones(length(patients),1); 

% Definimos quién es mujer (1) y quién hombre (0) (por ahora todos hombres)
mujer = zeros(length(patients),1); 
mujer(ismember(patients, [2 7 11 19 23 24 26 27 30 31 35 36 37 ... 
    45 49 50 52 60 62 77 81])) = 1;

Res_freqLF30minC = Result30minC(:,[1 2:10:end]);
Res_freqLFnorm30minC = Result30minC(:,[1 3:10:end]);
Res_freqHF30minC = Result30minC(:,[1 4:10:end]);
Res_freqHFnorm30minC = Result30minC(:,[1 5:10:end]);
Res_freqRatio30minC = Result30minC(:,[1 6:10:end]);
Res_tempRRmean30minC = Result30minC(:,[1 7:10:end]);
Res_tempSDNN30minC = Result30minC(:,[1 8:10:end]);
Res_tempRMSSD30minC = Result30minC(:,[1 9:10:end]);
Res_HR30minC = Result30minC(:,[1 10:10:end]);
Res_DFA30minC = Result30minC(:,[1 11:10:end]);
lnRes_freqLF30minC = [Res_freqLF30minC(:,1) log(Res_freqLF30minC(:,2:end))]; 
lnRes_freqHF30minC = [Res_freqHF30minC(:,1) log(Res_freqHF30minC(:,2:end))];

% Creamos encabezados para los segmentos de media hora
nHoras = 24;
segmentos = cell(1, nHoras*2);

col = 1;
for h = 1:nHoras
    segmentos{col}   = ['segm.h' num2str(h) '_1']; % primera media hora
    segmentos{col+1} = ['segm.h' num2str(h) '_2']; % segunda media hora
    col = col + 2; % saltar a las siguientes 2 posiciones
end

% Definimos los segmentos de día
dia = NaN(length(patients),1);
dia(patients==1)   = 20;   % H2-1, seg=3 -> col=4
dia(patients==2)   = 20;   % H3-2
dia(patients==5)   = 7;  % H7-1
dia(patients==6)   = 6;  % H14-2
dia(patients==7)   = 26;  % H13-1
dia(patients==8)   = 15;  % H21-2
dia(patients==9)   = 12;  % H17-2
dia(patients==11)  = 11;  % H19-2
dia(patients==12)  = 34;  % H17-1
dia(patients==15)  = 2;  % H16-2
dia(patients==16)  = 3;  % H13-2
dia(patients==17)  = 15;  % H21-2
dia(patients==19)  = 8;  % H19-1
dia(patients==22)  = 15;  % H19-2
dia(patients==23)  = 7;  % H17-1
dia(patients==24)  = 33;  % H20-1
dia(patients==26)  = 34;  % H16-1
dia(patients==27)  = 34;  % H19-1
dia(patients==30)  = 37;  % H17-2
dia(patients==31)  = 5;  % H18-1
dia(patients==32)  = 6;  % H17-2
dia(patients==35)  = 17;  % H14-2
dia(patients==36)  = 16;  % H11-2
dia(patients==37)  = 8;  % H20-1
dia(patients==39)  = 32;  % H13-1
dia(patients==45)  = 30;  % H21-2
dia(patients==47)  = 7;  % H19-1
dia(patients==48)  = 3;  % H19-2
dia(patients==49)  = 22;  % H17-2
dia(patients==50)  = 20;  % H14-2
dia(patients==52)  = 40;  % H22-1
dia(patients==53)  = 12;  % H19-1
dia(patients==56)  = 19;  % H14-1
dia(patients==60)  = 20;  % H16-1
dia(patients==62)  = 27;  % H19-1
dia(patients==77)  = 18;  % H19-1
dia(patients==81)  = 18;  % H20-2
dia(patients==93)  = 26;  % H21-2

% Definimos los segmentos de noche
noche = NaN(length(patients),1);
noche(patients==1)   = 32;  % H18-2
noche(patients==2)   = 34;  % H15-2
noche(patients==5)   = 26;  % H16-2
noche(patients==6)   = 36;  % H14-2
noche(patients==7)   = 26;  % H13-1
noche(patients==8)   = 33;  % H21-2
noche(patients==9)   = 26;  % H17-2
noche(patients==11)  = 32;  % H19-2
noche(patients==12)  = 16;  % H17-1
noche(patients==15)  = 33;  % H16-2
noche(patients==16)  = 16;  % H13-2
noche(patients==17)  = 27;  % H21-2
noche(patients==19)  = 26;  % H19-1
noche(patients==22)  = 28;  % H19-2
noche(patients==23)  = 32;  % H17-1
noche(patients==24)  = 20;  % H20-1
noche(patients==26)  = 18;  % H16-1
noche(patients==27)  = 22;  % H19-1
noche(patients==30)  = 22;  % H17-2
noche(patients==31)  = 25;  % H18-1
noche(patients==32)  = 17;  % H17-2
noche(patients==35)  = 33;  % H14-2
noche(patients==36)  = 36;  % H11-2
noche(patients==37)  = 17;  % H20-1
noche(patients==39)  = 14;  % H13-1
noche(patients==45)  = 16;  % H21-2
noche(patients==47)  = 22;  % H19-1
noche(patients==48)  = 23;  % H19-2
noche(patients==49)  = 30;  % H17-2
noche(patients==50)  = 32;  % H14-2
noche(patients==52)  = 28;  % H22-1
noche(patients==53)  = 25;  % H19-1
noche(patients==56)  = 28;  % H14-1
noche(patients==60)  = 31;  % H16-1
noche(patients==62)  = 15;  % H19-1
noche(patients==77)  = 36;  % H19-1
noche(patients==81)  = 28;  % H20-2
noche(patients==93)  = 13;  % H21-2

biomarcadores = {'Res_freqLF30minC', 'Res_freqLFnorm30minC', 'Res_freqHF30minC', ...
    'Res_freqHFnorm30minC', 'Res_freqRatio30minC', 'Res_tempRRmean30minC',...
    'Res_tempSDNN30minC', 'Res_tempRMSSD30minC', 'Res_HR30minC', 'Res_DFA30minC',...
    'lnRes_freqLF30minC','lnRes_freqHF30minC'};
% Recorremos todos los biomarcadores
for b = 1:length(biomarcadores)
    nombreBiomarcador = biomarcadores{b};

    % Cargamos la matriz correspondiente del biomarcador
    M = eval(nombreBiomarcador);
    
    % Columna 50 -> Día, Columna 51 -> Noche
    M(:,50) = NaN;
    M(:,51) = NaN;
    
    % Recorremos todos los pacientes para asignar los valores correctos de día y de noche
    for i = 1:size(M,1)

        if ~isnan(dia(i))
            M(i,50) = M(i, dia(i)); 
        end
        
        if ~isnan(noche(i))
            M(i,51) = M(i, noche(i)); 
        end
    end
    
    % Guardamos la matriz actualizada de vuelta en el workspace
    assignin('base', nombreBiomarcador, M);
end

Res_freqLF30minC = [Res_freqLF30minC(:,1), sintomatico, mujer, Res_freqLF30minC(:,2:end)];
Res_freqLFnorm30minC = [Res_freqLFnorm30minC(:,1), sintomatico, mujer, Res_freqLFnorm30minC(:,2:end)];
Res_freqHF30minC = [Res_freqHF30minC(:,1), sintomatico, mujer, Res_freqHF30minC(:,2:end)];
Res_freqHFnorm30minC = [Res_freqHFnorm30minC(:,1), sintomatico, mujer, Res_freqHFnorm30minC(:,2:end)];
Res_freqRatio30minC = [Res_freqRatio30minC(:,1), sintomatico, mujer, Res_freqRatio30minC(:,2:end)];
Res_tempRRmean30minC = [Res_tempRRmean30minC(:,1), sintomatico, mujer, Res_tempRRmean30minC(:,2:end)];
Res_tempSDNN30minC = [Res_tempSDNN30minC(:,1), sintomatico, mujer, Res_tempSDNN30minC(:,2:end)];
Res_tempRMSSD30minC = [Res_tempRMSSD30minC(:,1), sintomatico, mujer, Res_tempRMSSD30minC(:,2:end)];
Res_HR30minC = [Res_HR30minC(:,1), sintomatico, mujer, Res_HR30minC(:,2:end)];
Res_DFA30minC = [Res_DFA30minC(:,1), sintomatico, mujer, Res_DFA30minC(:,2:end)];
lnRes_freqLF30minC = [lnRes_freqLF30minC(:,1), sintomatico, mujer, lnRes_freqLF30minC(:,2:end)];
lnRes_freqHF30minC = [lnRes_freqHF30minC(:,1), sintomatico, mujer, lnRes_freqHF30minC(:,2:end)];
save indexes_HRV_30minC Result30minC Res_freqLF30minC Res_freqLFnorm30minC Res_freqHF30minC Res_freqHFnorm30minC Res_freqRatio30minC Res_tempRRmean30minC Res_tempSDNN30minC Res_tempRMSSD30minC Res_HR30minC Res_DFA30minC lnRes_freqLF30minC lnRes_freqHF30minC

header = ["Nº de paciente","Sintomático","Mujer", segmentos, "Dia", "Noche"];

writecell([cellstr(header); num2cell(Res_freqLF30minC)], 'Res_freqLF30minC.xls');
writecell([cellstr(header); num2cell(Res_freqLFnorm30minC)], 'Res_freqLFnorm30minC.xls');
writecell([cellstr(header); num2cell(Res_freqHF30minC)], 'Res_freqHF30minC.xls');
writecell([cellstr(header); num2cell(Res_freqHFnorm30minC)], 'Res_freqHFnorm30minC.xls');
writecell([cellstr(header); num2cell(Res_freqRatio30minC)], 'Res_freqRatio30minC.xls');
writecell([cellstr(header); num2cell(Res_tempRRmean30minC)], 'Res_tempRRmean30minC.xls');
writecell([cellstr(header); num2cell(Res_tempSDNN30minC)], 'Res_tempSDNN30minC.xls');
writecell([cellstr(header); num2cell(Res_tempRMSSD30minC)], 'Res_tempRMSSD30minC.xls');
writecell([cellstr(header); num2cell(Res_HR30minC)], 'Res_HR30minC.xls');
writecell([cellstr(header); num2cell(Res_DFA30minC)], 'Res_DFA30minC.xls');
writecell([cellstr(header); num2cell(lnRes_freqLF30minC)], 'lnRes_freqLF30minC.xls');
writecell([cellstr(header); num2cell(lnRes_freqHF30minC)], 'lnRes_freqHF30minC.xls');
