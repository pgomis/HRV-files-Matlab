%% compara automáticamente varios modelos de clasificación supervisada y 
% calcula métricas clave como precisión, sensibilidad (recall) y especificidad.
% ayuda a concatenar las variables del los marcadores
%% CONFIGURACIÓN
% archivoMat = 'indexes_HRV_30min.mat'; % Cambia el nombre si es distinto
% metodoImputacion = 'previous'; % Opciones: 'mean', 'previous', 'none'

%% 1. Cargar todas las variables del archivo .mat
datos = load('indexes_HRV_30min.mat'); % 
%% 2. Inicializar matriz de características
X = [];

%% 3. Extraer y concatenar columnas 4 a 51 de cada marcador
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

%% 4. Extraer etiquetas y sexo (de la primera matriz)
Y = datos.(nombres{1})(:,2); % 0 = asintomático, 1 = sintomático
% (Opcional) Añadir sexo como variable adicional
sexo = datos.(nombres{1})(:,3); % 0 = hombre, 1 = mujer
% X = [X, sexo]; % Añadir sexo como variable

%% 5. Imputación de NaNs
% switch metodoImputacion
%     case 'mean'
%         X = fillmissing(X, 'mean');
%     case 'previous'
%         X = fillmissing(X, 'previous');
%     case 'none'
%         warning('No se ha imputado NaNs. El modelo puede fallar.');
% end

%% 6. Normalización
X = normalize(X);
% Opcional. Reducción de dimensionalidad: 
% X = pca(X);
%% 7. División en entrenamiento y prueba
cv = cvpartition(Y, 'HoldOut', 0.28);
Xtrain = X(training(cv), :);
Ytrain = Y(training(cv));
Xtest = X(test(cv), :);
Ytest = Y(test(cv));

%% 8. Definir modelos
modelos = {
    struct('nombre', 'SVM', 'modelo', @() fitcsvm(Xtrain, Ytrain, 'KernelFunction', 'linear')),
    struct('nombre', 'Random Forest', 'modelo', @() fitcensemble(Xtrain, Ytrain, 'Method', 'Bag', 'NumLearningCycles', 100)),
    struct('nombre', 'KNN', 'modelo', @() fitcknn(Xtrain, Ytrain, 'NumNeighbors', 5)),
    struct('nombre', 'Árbol de decisión', 'modelo', @() fitctree(Xtrain, Ytrain)),
    struct('nombre', 'Red neuronal', 'modelo', @() fitcnet(Xtrain, Ytrain))
};

%% 9. Evaluar cada modelo
for i = 1:length(modelos)
    nombre = modelos{i}.nombre;
    modelo = modelos{i}.modelo();
    Ypred = predict(modelo, Xtest);

    % Métricas
    TP = sum((Ytest == 1) & (Ypred == 1));
    TN = sum((Ytest == 0) & (Ypred == 0));
    FP = sum((Ytest == 0) & (Ypred == 1));
    FN = sum((Ytest == 1) & (Ypred == 0));

    precision = (TP + TN) / length(Ytest);
    sensibilidad = TP / (TP + FN);
    especificidad = TN / (TN + FP);

    fprintf('\nModelo: %s\n', nombre);
    fprintf('Precisión: %.2f%%\n', precision * 100);
    fprintf('Sensibilidad (Recall): %.2f%%\n', sensibilidad * 100);
    fprintf('Especificidad: %.2f%%\n', especificidad * 100);
end

%% 9.1 Evaluar cada modelo y guardar resultados
resultados = [];

for i = 1:length(modelos)
    nombre = modelos{i}.nombre;
    modelo = modelos{i}.modelo();
    Ypred = predict(modelo, Xtest);

    % Métricas
    TP = sum((Ytest == 1) & (Ypred == 1));
    TN = sum((Ytest == 0) & (Ypred == 0));
    FP = sum((Ytest == 0) & (Ypred == 1));
    FN = sum((Ytest == 1) & (Ypred == 0));

    precision = (TP + TN) / length(Ytest);
    sensibilidad = TP / (TP + FN);
    especificidad = TN / (TN + FP);

Ytest_labels = categorical(Ytest, [0 1], {'Asintomático', 'Sintomático'});
Ypred_labels = categorical(Ypred, [0 1], {'Asintomático', 'Sintomático'});

    resultados = [resultados; {nombre, precision*100, sensibilidad*100, especificidad*100}];
    % Mostrar tabla de confusión
    figure('Name', ['Confusion Matrix - ', nombre]);
    confusionchart(Ytest_labels, Ypred_labels);
    % confusionchart(Ytest, Ypred);
    % confusionchart(Ytest, Ypred, {'Asintomático', 'Sintomático'});
    title(['Matriz de Confusión - ', nombre]);
end

%% 10. Mostrar tabla resumen
tabla = cell2table(resultados, ...
    'VariableNames', {'Modelo', 'Precision_porcentaje', 'Sensibilidad_porcentaje', 'Especificidad_porcentaje'});

disp(tabla);