%% Script computes HRV time, frequency and DFA (alpha) values
%  
%  uses calc_HRVshort
% P Gomis, 2021, Nahia Soto, 2025, Sergio Guato, 2026
patients=[1:8, 10:20, 22:40, 42:50, 77:78, 81, 86, 88, 90:111,...
    113:116, 119:123, 126:129, 131, 133:134, 136:139, 142:150, 154, 156, ...
    157:158, 160, 165, 167:169, 171, 173:176, 181, 183, 186, 188:189]; % Pacientes (122)
% Se crea Results30min con valores NaN de filas = Num de pacientes (122) 
% y columnas = 48 segmentos * 10 HRV indices + 1 columna (# del paciente)
Result30min=NaN(length(patients),481);  %48 segment * 10 biomarcador + 1 (# paciente)
Result30min(:,1)=patients';
for i=1:length(patients)
    % n = segment30min2(patients(i)); % se puede omitir si ya se han
    % ejecutado y obtenido los RRxx.mat segmentados
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
%% Adaptado a n segementos de 30 min c/u
%lnFREQ=log(Result5min(:,[2:5 7]));

% Definimos quién es sintomático (1) y quién no (0)
sintomatico = zeros(length(patients),1); 
sintomatico(ismember(patients, [3 11 15 16 23 24 29 33 38 42 44 46 81 ... 
    94 98 99 101 106 111 120 122 123 126 131 139 145 148 156 157 158 169 ...  
    171 173 174 183])) = 1;

% Definimos quién es mujer (1) y quién hombre (0)
mujer = zeros(length(patients),1); 
mujer(ismember(patients, [1 2 6 12 15 23 24 26 29 47 48 49 50 78 88 ... 
    91 94 95 96 107 109 115 116 119 122 133 134 137 144 145 147 150 ...
    154 158 165 168 173 174 175 176])) = 1;

Res_freqLF30min = Result30min(:,[1 2:10:end]);
% Res_freqLF30min = [Res_freqLF30min(:,1), sintomatico, mujer, Res_freqLF30min(:,2:end)];
Res_freqLFnorm30min = Result30min(:,[1 3:10:end]);
% Res_freqLFnorm30min = [Res_freqLFnorm30min(:,1), sintomatico, mujer, Res_freqLFnorm30min(:,2:end)];
Res_freqHF30min = Result30min(:,[1 4:10:end]);
% Res_freqHF30min = [Res_freqHF30min(:,1), sintomatico, mujer, Res_freqHF30min(:,2:end)];
Res_freqHFnorm30min = Result30min(:,[1 5:10:end]);
% Res_freqHFnorm30min = [Res_freqHFnorm30min(:,1), sintomatico, mujer, Res_freqHFnorm30min(:,2:end)];
Res_freqRatio30min = Result30min(:,[1 6:10:end]);
% Res_freqRatio30min = [Res_freqRatio30min(:,1), sintomatico, mujer, Res_freqRatio30min(:,2:end)];
Res_tempRRmean30min = Result30min(:,[1 7:10:end]);
% Res_tempRRmean30min = [Res_tempRRmean30min(:,1), sintomatico, mujer, Res_tempRRmean30min(:,2:end)];
Res_tempSDNN30min = Result30min(:,[1 8:10:end]);
% Res_tempSDNN30min = [Res_tempSDNN30min(:,1), sintomatico, mujer, Res_tempSDNN30min(:,2:end)];
Res_tempRMSSD30min = Result30min(:,[1 9:10:end]);
% Res_tempRMSSD30min = [Res_tempRMSSD30min(:,1), sintomatico, mujer, Res_tempRMSSD30min(:,2:end)];
Res_HR30min = Result30min(:,[1 10:10:end]);
% Res_HR30min = [Res_HR30min(:,1), sintomatico, mujer, Res_HR30min(:,2:end)];
Res_DFA30min = Result30min(:,[1 11:10:end]);
% Res_DFA30min = [Res_DFA30min(:,1), sintomatico, mujer, Res_DFA30min(:,2:end)];
lnRes_freqLF30min = [Res_freqLF30min(:,1) log(Res_freqLF30min(:,2:end))]; 
lnRes_freqHF30min = [Res_freqHF30min(:,1) log(Res_freqHF30min(:,2:end))];

% Res_freqLF= Result30min(:,[1 2:10:end]);
% Res_freqLFnorm= Result30min(:,[1 3:10:end]);
% % Res_DFA5min = Result30min(:,[1 11:10:51]);
%xlswrite('res_freq5min.xls', Res_freq5min);  % formato antiguo para salvar
% writematrix(Res_freq5min, 'res_freq5min.xls')

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
dia(patients==1)   = 4;   % H2-1, seg=3 -> col=4
dia(patients==2)   = 7;   % H3-2
dia(patients==3)   = 14;  % H7-1
dia(patients==4)   = 2;   % H1-1
dia(patients==5)   = 3;   % H1-2 
dia(patients==6)   = 13;  % H6-2 
dia(patients==7)   = 18;  % H9-1 
dia(patients==8)   = 8;   % H4-1 
dia(patients==10)  = 14;  % H7-1
dia(patients==11)  = 21;  % H10-2 
dia(patients==12)  = 13;  % H6-2
dia(patients==13)  = 4;   % H2-1
dia(patients==14)  = 14;  % H7-1
dia(patients==15)  = 24;  % H12-1 
dia(patients==16)  = 14;  % H7-1
dia(patients==17)  = 4;   % H2-1
dia(patients==18)  = 7;   % H3-2
dia(patients==19)  = 5;   % H2-2 
dia(patients==20)  = 13;  % H6-2
dia(patients==22)  = 21;  % H10-2
dia(patients==23)  = 21;  % H10-2
dia(patients==24)  = 11;  % H5-2
dia(patients==25)  = 7;   % H3-2
dia(patients==26)  = 6;   % H3-1 
dia(patients==27)  = 3;   % H1-2
dia(patients==28)  = 9;   % H4-2 
dia(patients==29)  = 12;  % H6-1 
dia(patients==30)  = 6;   % H3-1
dia(patients==31)  = 14;  % H7-1
dia(patients==32)  = 15;  % H7-2 
dia(patients==33)  = 18;  % H9-1
dia(patients==34)  = 12;  % H6-1
dia(patients==35)  = 8;   % H4-1
dia(patients==36)  = 7;   % H3-2
dia(patients==37)  = 10;  % H5-1
dia(patients==38)  = 10;  % H5-1 
dia(patients==39)  = 11;  % H5-2
dia(patients==40)  = 12;  % H6-1
dia(patients==42)  = 12;  % H6-1
dia(patients==43)  = 10;  % H5-1
dia(patients==44)  = 18;  % H9-1
dia(patients==45)  = 10;  % H5-1
dia(patients==46)  = 17;  % H8-2 
dia(patients==47)  = 15;  % H7-2
dia(patients==48)  = 17;  % H8-2
dia(patients==49)  = 5;   % H2-2
dia(patients==50)  = 8;   % H4-1
dia(patients==77)  = 31;  % H15-2 
dia(patients==78)  = 16;  % H8-1 
dia(patients==81)  = 18;  % H9-1
dia(patients==86)  = 7;   % H3-2
dia(patients==88)  = 10;  % H5-1
dia(patients==90)  = 21;  % H10-2
dia(patients==91)  = 17;  % H8-2
dia(patients==92)  = 18;  % H9-1
dia(patients==93)  = 5;   % H2-2
dia(patients==94)  = 20;  % H10-1 
dia(patients==95)  = 20;  % H10-1
dia(patients==96)  = 37;  % H18-2
dia(patients==97)  = 6;   % H3-1
dia(patients==98)  = 6;   % H3-1
dia(patients==99)  = 4;   % H2-1
dia(patients==100) = 13;  % H6-2
dia(patients==101) = 25;  % H12-2 
dia(patients==102) = 16;  % H8-1
dia(patients==103) = 4;   % H2-1
dia(patients==104) = 14;  % H7-1
dia(patients==105) = 15;  % H7-2
dia(patients==106) = 14;  % H7-1
dia(patients==107) = 7;   % H3-2
dia(patients==108) = 11;  % H5-2
dia(patients==109) = 2;   % H1-1
dia(patients==110) = 4;   % H2-1
dia(patients==111) = 6;   % H3-1
dia(patients==113) = 8;   % H4-1
dia(patients==114) = 13;  % H6-2
dia(patients==115) = 9;   % H4-2
dia(patients==116) = 3;   % H1-2
dia(patients==117) = 9;   % H4-2
dia(patients==119) = 22;  % H11-1 
dia(patients==120) = 13;  % H6-2
dia(patients==121) = 7;  % H3-2
dia(patients==122) = 6;  % H3-1
dia(patients==123) = 5;  % H2-2
dia(patients==126) = 40;  % 20-1
dia(patients==127) = 10;  % H5-1
dia(patients==128) = 10;  % H5-1
dia(patients==129) = 21;  % H10-2
dia(patients==131) = 16;  % H8-1
dia(patients==132) = 7;  % H8-1
dia(patients==133) = 17;  % H8-1
dia(patients==134) = 14;
dia(patients==135) = 18;  
dia(patients==136) = 12;  
dia(patients==137) = 16;  
dia(patients==138) = 10;
dia(patients==139) = 2; 
dia(patients==142) = 6; 
dia(patients==143) = 6; 
dia(patients==144) = 7; 
dia(patients==145) = 12; 
dia(patients==146) = 4; 
dia(patients==147) = 11; 
dia(patients==148) = 8; 
dia(patients==149) = 18; 
dia(patients==150) = 7; 
dia(patients==154) = 7;
dia(patients==156) = 8;
dia(patients==157) = 20;
dia(patients==158) = 6;  % H3-1
dia(patients==160) = 10; 
dia(patients==161) = 6; 
dia(patients==165) = 3; 
dia(patients==167) = 2; 
dia(patients==168) = 3; 
dia(patients==169) = 17;  % H8-2
dia(patients==171) = 8;  % H4-1
dia(patients==172) = 6;  % H4-1
dia(patients==173) = 6;  % H3-1
dia(patients==174) = 9; 
dia(patients==175) = 11;  % H3-1
dia(patients==176) = 12;  % H3-1
dia(patients==181) = 18;  % H3-1
dia(patients==182) = 3;  % H3-1
dia(patients==183) = 10;
dia(patients==186) = 10;
dia(patients==188) = 16;
dia(patients==189) = 16;
dia(patients==197) = 8;
dia(patients==202) = 12;
dia(patients==205) = 14;
dia(patients==206) = 4;
dia(patients==208) = 13;
dia(patients==225) = 15;
dia(patients==237) = 16;
dia(patients==263) = 10;
dia(patients==282) = 10;

% Definimos los segmentos de noche
noche = NaN(length(patients),1);
noche(patients==1)   = 37;  % H18-2
noche(patients==2)   = 31;  % H15-2
noche(patients==3)   = 33;  % H16-2
noche(patients==4)   = 29;  % H14-2
noche(patients==5)   = 26;  % H13-1
noche(patients==6)   = 43;  % H21-2
noche(patients==7)   = 35;  % H17-2
noche(patients==8)   = 39;  % H19-2
noche(patients==10)  = 34;  % H17-1
noche(patients==11)  = 33;  % H16-2
noche(patients==12)  = 27;  % H13-2
noche(patients==13)  = 43;  % H21-2
noche(patients==14)  = 38;  % H19-1
noche(patients==15)  = 39;  % H19-2
noche(patients==16)  = 34;  % H17-1
noche(patients==17)  = 40;  % H20-1
noche(patients==18)  = 32;  % H16-1
noche(patients==19)  = 38;  % H19-1
noche(patients==20)  = 35;  % H17-2
noche(patients==22)  = 36;  % H18-1
noche(patients==23)  = 35;  % H17-2
noche(patients==24)  = 29;  % H14-2
noche(patients==25)  = 23;  % H11-2
noche(patients==26)  = 41;  % H20-1
noche(patients==27)  = 26;  % H13-1
noche(patients==28)  = 43;  % H21-2
noche(patients==29)  = 38;  % H19-1
noche(patients==30)  = 39;  % H19-2
noche(patients==31)  = 35;  % H17-2
noche(patients==32)  = 29;  % H14-2
noche(patients==33)  = 44;  % H22-1
noche(patients==34)  = 38;  % H19-1
noche(patients==35)  = 28;  % H14-1
noche(patients==36)  = 32;  % H16-1
noche(patients==37)  = 38;  % H19-1
noche(patients==38)  = 31;  % H19-1
noche(patients==39)  = 41;  % H20-2
noche(patients==40)  = 43;  % H21-2
noche(patients==42)  = 28;  % H14-1
noche(patients==43)  = 38;  % H19-1
noche(patients==44)  = 31;  % H15-2
noche(patients==45)  = 34;  % H17-1
noche(patients==46)  = 34;  % H17-1
noche(patients==47)  = 44;  % H22-1
noche(patients==48)  = 48;  % H24-1
noche(patients==49)  = 41;  % H20-2
noche(patients==50)  = 27;  % H13-2
noche(patients==77)  = 8;   % H4-1
noche(patients==78)  = 27;  % H13-2
noche(patients==81)  = 45;  % H22-2
noche(patients==86)  = 34;  % H17-1
noche(patients==88)  = 32;  % H16-1
noche(patients==90)  = 37;  % H18-2
noche(patients==91)  = 26;  % H13-1
noche(patients==92)  = 46;  % H23-1
noche(patients==93)  = 33;  % H16-2
noche(patients==94)  = 33;  % H16-2
noche(patients==95)  = 42;  % H21-1
noche(patients==96)  = 23;  % H11-2
noche(patients==97)  = 21;  % H10-2
noche(patients==98)  = 22;  % H11-1
noche(patients==99)  = 30;  % H15-1
noche(patients==100) = 37;  % H18-2
noche(patients==101) = 38;  % H19-1
noche(patients==102) = 43;  % H21-2
noche(patients==103) = 36;  % H18-1
noche(patients==104) = 43;  % H21-2
noche(patients==105) = 38;  % H19-1
noche(patients==106) = 36;  % H18-2
noche(patients==107) = 37;  % H18-2
noche(patients==108) = 33;  % H16-2
noche(patients==109) = 30;  % H15-1
noche(patients==110) = 28;  % H14-1
noche(patients==111) = 21;  % H10-2
noche(patients==113) = 31;  % H15-2
noche(patients==114) = 41;  % H20-2
noche(patients==115) = 40;  % H20-1
noche(patients==116) = 40;  % H20-1
noche(patients==117) = 13;  % H20-1
noche(patients==119) = 43;  % H21-1
noche(patients==120) = 35;  % H17-2
noche(patients==121) = 36;  % H18-1
noche(patients==122) = 29;  % H14-2
noche(patients==123) = 19;  % H9-2
noche(patients==126) = 25;  % H12-2
noche(patients==127) = 25;  % H12-2
noche(patients==128) = 22;  % H11-1
noche(patients==129) = 31;  % H15-2
noche(patients==131) = 29;  % H14-2
noche(patients==132) = 32;  % H14-2
noche(patients==133) = 31;  % H14-2
noche(patients==134) = 34;  % H14-2
noche(patients==135) = 40;  % H14-2
noche(patients==136) = 32;  % H14-2
noche(patients==137) = 34;  
noche(patients==138) = 34; 
noche(patients==139) = 27; 
noche(patients==142) = 30; 
noche(patients==143) = 34;
noche(patients==144) = 24;
noche(patients==145) = 26;
noche(patients==146) = 36;
noche(patients==147) = 26;
noche(patients==148) = 26;
noche(patients==149) = 30;
noche(patients==150) = 22;
noche(patients==154) = 31;
noche(patients==156) = 37;
noche(patients==157) = 40;
noche(patients==158) = 26;  % H13-1
noche(patients==160) = 34; 
noche(patients==161) = 28; 
noche(patients==165) = 26; 
noche(patients==167) = 31; 
noche(patients==168) = 30; 
noche(patients==169) = 32;  % H16-1
noche(patients==171) = 28;  % H14-1
noche(patients==172) = 30;  % H14-1
noche(patients==173) = 29; 
noche(patients==174) = 32; 
noche(patients==175) = 36; 
noche(patients==176) = 28; 
noche(patients==181) = 34; 
noche(patients==182) = 28; 
noche(patients==183) = 32; 
noche(patients==186) = 30; 
noche(patients==188) = 30; 
noche(patients==189) = 32; 
noche(patients==197) = 34; 
noche(patients==202) = 36; 
noche(patients==205) = 32;
noche(patients==206) = 24;
noche(patients==208) = 28;
noche(patients==225) = 38;
noche(patients==237) = 30;
noche(patients==263) = 26;
noche(patients==282) = 26;

biomarcadores = {'Res_freqLF30min', 'Res_freqLFnorm30min', 'Res_freqHF30min', ...
    'Res_freqHFnorm30min', 'Res_freqRatio30min', 'Res_tempRRmean30min',...
    'Res_tempSDNN30min', 'Res_tempRMSSD30min', 'Res_HR30min', 'Res_DFA30min',...
    'lnRes_freqLF30min','lnRes_freqHF30min'};
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

Res_freqLF30min = [Res_freqLF30min(:,1), sintomatico, mujer, Res_freqLF30min(:,2:end)];
Res_freqLFnorm30min = [Res_freqLFnorm30min(:,1), sintomatico, mujer, Res_freqLFnorm30min(:,2:end)];
Res_freqHF30min = [Res_freqHF30min(:,1), sintomatico, mujer, Res_freqHF30min(:,2:end)];
Res_freqHFnorm30min = [Res_freqHFnorm30min(:,1), sintomatico, mujer, Res_freqHFnorm30min(:,2:end)];
Res_freqRatio30min = [Res_freqRatio30min(:,1), sintomatico, mujer, Res_freqRatio30min(:,2:end)];
Res_tempRRmean30min = [Res_tempRRmean30min(:,1), sintomatico, mujer, Res_tempRRmean30min(:,2:end)];
Res_tempSDNN30min = [Res_tempSDNN30min(:,1), sintomatico, mujer, Res_tempSDNN30min(:,2:end)];
Res_tempRMSSD30min = [Res_tempRMSSD30min(:,1), sintomatico, mujer, Res_tempRMSSD30min(:,2:end)];
Res_HR30min = [Res_HR30min(:,1), sintomatico, mujer, Res_HR30min(:,2:end)];
Res_DFA30min = [Res_DFA30min(:,1), sintomatico, mujer, Res_DFA30min(:,2:end)];
lnRes_freqLF30min = [lnRes_freqLF30min(:,1), sintomatico, mujer, lnRes_freqLF30min(:,2:end)];
lnRes_freqHF30min = [lnRes_freqHF30min(:,1), sintomatico, mujer, lnRes_freqHF30min(:,2:end)];
save indexes_HRV_30min Result30min Res_freqLF30min Res_freqLFnorm30min Res_freqHF30min Res_freqHFnorm30min Res_freqRatio30min Res_tempRRmean30min Res_tempSDNN30min Res_tempRMSSD30min Res_HR30min Res_DFA30min lnRes_freqLF30min lnRes_freqHF30min

header = ["Nº de paciente","Sintomático","Mujer", segmentos, "Dia", "Noche"];

writecell([cellstr(header); num2cell(Res_freqLF30min)], 'res_freqLF30min.xls');
writecell([cellstr(header); num2cell(Res_freqLFnorm30min)], 'res_freqLFnorm30min.xls');
writecell([cellstr(header); num2cell(Res_freqHF30min)], 'res_freqHF30min.xls');
writecell([cellstr(header); num2cell(Res_freqHFnorm30min)], 'res_freqHFnorm30min.xls');
writecell([cellstr(header); num2cell(Res_freqRatio30min)], 'res_freqRatio30min.xls');
writecell([cellstr(header); num2cell(Res_tempRRmean30min)], 'res_tempRRmean30min.xls');
writecell([cellstr(header); num2cell(Res_tempSDNN30min)], 'res_tempSDNN30min.xls');
writecell([cellstr(header); num2cell(Res_tempRMSSD30min)], 'res_tempRMSSD30min.xls');
writecell([cellstr(header); num2cell(Res_HR30min)], 'res_HR30min.xls');
writecell([cellstr(header); num2cell(Res_DFA30min)], 'res_DFA30min.xls');
writecell([cellstr(header); num2cell(lnRes_freqLF30min)], 'lnres_freqLF30min.xls');
writecell([cellstr(header); num2cell(lnRes_freqHF30min)], 'lnres_freqHF30min.xls');
% writematrix(Res_freqLF30min, 'res_freqLF30min.xls')
% writematrix(Res_freqLFnorm30min, 'res_freqLFnorm30min.xls')
% writematrix(Res_freqHF30min, 'res_freqHF30min.xls')
% writematrix(Res_freqHFnorm30min, 'res_freqHFnorm30min.xls')
% writematrix(Res_freqRatio30min, 'res_freqRatio30min.xls')
% writematrix(Res_tempRRmean30min, 'res_tempRRmean30min.xls')
% writematrix(Res_tempSDNN30min, 'res_tempSDNN30min.xls')
% writematrix(Res_tempRMSSD30min, 'res_tempRMSSD30min.xls')
% writematrix(Res_HR30min, 'res_HR30min.xls')
% writematrix(Res_DFA30min, 'res_DFA30min.xls')
% A menudo se suele guardar los valores de HF y LF en escala logarítmica.
% Los valores de LF y HF suelen tener una distribución sesgada (no normal)
% y se realizan transformaciones con logaritmo natural (ln) para estos 
% índices espectrales de potencia. Sería:
