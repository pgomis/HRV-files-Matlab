function [n, horas, s] = segment30min2(numPat, hora)
% [n, horas, s] = segment30min(numPat)
% se carga el paciente 'pat', por ejemplo, RR24h_46.mat
%  [n, horas, s] = segment30min(46)
%
% P.Gomis, Nahia Soto, 2025, Sergio Guato, 2026
numPat_s=num2str(numPat);
if numPat<10
    numPat_s =['0' numPat_s];
end
v = ['RR24h_' numPat_s '.mat'];
load(v)
if nargin < 2,
    horas=ttotal(end)/3600;
    s = ttotal(end);
else
    horas = hora;
    s = hora*3600;
end
if horas >= 23.89
    horas = 24;
end
n = floor(horas*2); % n intervalos de 30 min (1800 s)
for i = 1:n
    ind = find(ttotal>= (i-1)*1800 & ttotal < i*1800);
    t = ttotal(ind);
    RR = RRTotalff(ind);
    ns=num2str(i);
    v =genvarname(['RRdata' ns]);
    eval([v '= [t RR];']);
    % plot(t/3600,RR)  % prueba para visualizar cada segmento RR
    % plot(t/3600, 1./RR*60000)  % prueba visualiza HR (frecuencia cardiaca)
    % hold on
end
% hold off
v2 = genvarname(['RR_' numPat_s]);
clear numPat numPat_s ind RR t ns RRTotalf RRTotalff ttotal ttotal2 v i
% eval(['save ' v2])
save(v2)
%buscamos el índice del segundo final s. Como ese valor exacto es imporbable que
% esté a menos que sea el último, lo buscamos en un intervalo de 1.4 s
% i_fin = find(ttotal >= s & ttotal<= s +1.4); %buscamos el índice del segundo s
% i_fin = i(1); %escogemos uno de varios posibles
% % seg = ttotal(end);
