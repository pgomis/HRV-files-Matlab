function marques = detecrc(senyal, fs)
% Función para detectar picos de la señal de entrada 
%
% [marques]=detecrc(x,fs)
%
% x: señal vectro columna
% fs: frecuencia de muestreo; default: fs = 250
% 
% DEFINICIONS
if nargin < 2, fs = []; end
if isempty(fs), fs = 250; end  % fs = 250
derSenyal  = diff(senyal);
numMostres = length(derSenyal);
offset     = round(fs/10); % orig 50
N=round(fs*10);     % 10 segundos de señal
llindar    = .5*max(derSenyal(1:N)); %umbral empieza detección 0.5
comptador  = 0;
mostra     = round(fs*1.6); % original 1.6 sec (fs*1.6)
                                         
% BUCLE PRINCIPAL DE CERCA
continuar = true;
while continuar
  if derSenyal(mostra) > llindar
    buscar = true;
    while buscar
      if derSenyal(mostra) < 0
        comptador = comptador + 1;
        marques(comptador, 1) = mostra;
        buscar = false;
        llindar = mean([llindar .5*max(derSenyal(mostra+offset:min([mostra+N numMostres])))]); %original 0.5
        mostra = mostra + offset;
        if mostra >= numMostres
          continuar = false;
        end
      else
        mostra = mostra + 1;
        if mostra >= numMostres
          continuar = false;
        end
      end
    end
  else
    mostra = mostra + 1;
    if mostra >= numMostres
      continuar = false;
    end
  end
end

% DIBUIXEM ELS RESULTATS
t = (1/fs:1/fs:numMostres/fs)';
figure; box on; hold on;
plot(t, senyal(1:numMostres));
plot(t, derSenyal, 'r');
axis tight;
plot([marques marques]'/fs, repmat(get(gca, 'Ylim')', size(marques')), 'k--');
title('ECG')
xlabel('temps (s)')
hold off;
xlim([2 8]);
pan xon;