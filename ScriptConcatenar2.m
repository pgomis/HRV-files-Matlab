%% Script para construir X desde múltiples variables en un .mat
%% 1. Cargar todas las variables del archivo .mat
datos = load('indexes_HRV_30min.mat'); % Cambia el nombre si es distinto

%% 2. Inicializar matriz de características
X = [];

%% 3. Recorrer todas las variables del archivo
nombres = fieldnames(datos);
% tomaremos hasta la 2da media hora de la hora 21, que hay menos de  26%
% NaN, se refiere a la columna 45. Col 1: ident, col2: sintom, col3: sexo,
% col 4:51 las 48 medias horas
for i = 1:length(nombres)
    matriz = datos.(nombres{i}); % Accede a la variable por nombre
    % Extraer columnas 4 a 51 (las 48 medias horas)
    Xtemp = matriz(:,4:45); % tomamos hasta la hora 21 y media
    Xtemp = fillmissing(Xtemp,'movmean',5,2); % reemplaza NaN con la media de los 5 valores previos de la fila (2)
    Xtemp = [Xtemp matriz(:,52:53)]; %agregamos las columnas de dia y de noche
    X = [X, Xtemp]; % Concatenar horizontalmente
 end

%% 4. (Opcional) Añadir sexo como variable adicional
% Suponiendo que todas las matrices tienen la misma columna 3
sexo = datos.(nombres{1})(:,3); % Tomar de la primera matriz
X = [X, sexo];

%% 5. Imputación de NaNs si lo deseas
X = fillmissing(X, 'mean'); % O 'previous', según prefieras

%% 6. Normalización
X = normalize(X);


% Mostrar tabla de confusión
figure('Name', ['Confusion Matrix - ', nombre]);
confusionchart(Ytest, Ypred);
title(['Matriz de Confusión - ', nombre]);
