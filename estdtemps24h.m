function [estad]=estdtemps24h(data)
% % Standard time TASK FORCE indices. 
% 
%  estad = estdtemps24h(data)
%
% data: 2 column input [time values], values= filtered RR intervals 
% Returns a Column vector with the time indices. (units ms):
%(1)   RR mean value
%(2)   SDNN
%(3)   RMSSD Kaplan
%(4)   SDANN
%(5)   SDNN_5min  
%(6)   SDSD
%(7)   NN50
%(8)   pNN50 (en %)
%(9)   MIRR ( PhD Tesis Garcia MA )
%
% Exemple:
%    c=estdtemps(fRRp042b);
%
% Pedro Gomis, Albert Ferrer, 2004

%Calculem aspectes generals
N=length(data);
mitjana=mean(data(:,2));
%calculem SDNN (desviacio tipus dades)
SDNN=std(data(:,2));
% Compute SDANN and SDNN_5min
nmin = 5;
nseg=round(60*nmin);
t_end = data(end,1);
nsegment = floor(t_end/(5*60));
NN5min = zeros(nsegment,1);
SD5min = zeros(nsegment,1);
for ii=0:nsegment-1
    index = find(data(:,1)> nseg*ii & data(:,1) <= nseg*ii+nseg);
    NN5min(ii+1)=mean(data(index,2));
    SD5min(ii+1)=std(data(index,2));
end
SDANN = std(NN5min);
SDNN_5min = mean(SD5min);
%Calculem RMSSD, SDSD, NN50 i pNN50
j=1;
NN50=0;
valid(1)=1;
for i=2:1:N
    valid(i)=round(data(i-1,1)+data(i,2)/1000-data(i,1))==0; % comprovem que siguin efectivament adjacents
    if valid(i)==1
        seriediff(j)=data(i,2)-data(i-1,2);
        if (abs(seriediff(j))>50)
            NN50=NN50+1;
        end
        j=j+1;
    end
end
SDSD=std(seriediff);
pNN50=(NN50/(j-1))*100; % NN50 nomes te en compte intervals consecutius, (j-1) son tots els consecutius (Task Force)

%calcul RMSSD
RMSSDKaplan=sqrt((sum(seriediff.^2))/(length(seriediff)));
%RMSSDfin=sqrt((sum((seriediff-mean(seriediff)).^2))/(length(seriediff)));
%tret de la Tesi doctoral, calculem l'index proposat MIRR = Q3-Q1, es a
%dir, el rang interquartilic de la sequencia RR.
taulaord=data(:,2);
taulaord=sort(taulaord);
Z=mod(N,2);
if Z==0
    Q1=taulaord(round(N/4));
    Q3=taulaord(round(3*N/4));
end
if Z==1
    Q1=taulaord(round((N+1)/4));
    Q3=taulaord(round((3*N+1)/4));
end
MIRR=Q3-Q1;

%Posem tots els estadistics en un vector columna per tal de poder-los
%treure tots alhora
estad(1)=mitjana;
estad(2)=SDNN;
estad(3)=RMSSDKaplan;
estad(4)=SDANN;
estad(5)=SDNN_5min;
estad(6)=SDSD;
estad(7)=NN50;
estad(8)=pNN50;
estad(9)=MIRR;
estad=estad';