%% COMPARA MODELOS MULTICLASE (3 CLASES) CON CARACTERÍSTICAS DÍA/NOCHE
% Clases: 0 = Asintomático, 1 = Sintomático, 2 = Control

%% 1. Cargar datos
datos = load('indexes_HRV_30minT2.mat');
nombres = fieldnames(datos);

%% 2 y 3. Filtrado de biomarcadores y construcción de X
X = [];

for i = 1:length(nombres)
    matriz = datos.(nombres{i}); 
    nombre_var = nombres{i};
    
    % Filtrar biomarcadores no informativos o redundantes según p-valores
    if contains(nombre_var, 'RRmean') || contains(nombre_var, 'LFnorm') || ...
       contains(nombre_var, 'Ratio')  || (contains(nombre_var, 'DFA') && ~contains(nombre_var, 'SD'))
        continue; % Salta el marcador
    end
    
    % --- Imputación de NaNs ---
    % Col 4 a 45 (Segmentos de 30 min)
    X_48segs = matriz(:, 4:45);
    X_48segs = fillmissing(X_48segs, 'movmean', 5, 2);
    X_48segs = fillmissing(X_48segs, 'nearest', 2);
    
    % Col 52 (Día) y Col 53 (Noche)
    X_dia   = fillmissing(matriz(:, 52), 'nearest', 1);
    X_noche = fillmissing(matriz(:, 53), 'nearest', 1);
    
    % --- Extracción de Características Relevantes ---
    media_24h = mean(X_48segs, 2);
    sd_24h    = std(X_48segs, 0, 2); % Importante para SD_HR
    
    % Concatenar: [Media_24h, SD_24h, Valor_Dia, Valor_Noche]
    X = [X, media_24h, sd_24h, X_dia, X_noche]; 
end

% Limpieza final de respaldo
X = fillmissing(X, 'constant', 0);

%% 4. Extraer etiquetas (0 = Asintomático, 1 = Sintomático, 2 = Control)
Y = datos.(nombres{1})(:, 2); 

%% 5. Normalización Z-score
X = normalize(X);

%% =========================================================================
%% CLASIFICACIÓN SUPERVISADA MULTICLASE (10-FOLD CROSS-VALIDATION)
%% =========================================================================
fprintf('\n--- EJECUTANDO CLASIFICACIÓN CON VALIDACIÓN CRUZADA (10-FOLD) ---\n');

% Fijar semilla aleatoria para resultados reproducibles
rng(42); 

numFolds = 10;
% cv = cvpartition(Y, 'HoldOut', 0.20, 'Stratify', true); %antigua
cv = cvpartition(Y, 'KFold', numFolds, 'Stratify', true);

% Matriz de Coste para penalizar el doble las confusiones sobre la clase Sintomático (menor N)
coste = [0 1 1; 
         2 0 1; 
         1 1 0]; 

modelos = {
    % struct('nombre', 'Random Forest', ...
    %        'modelo', @(Xtr, Ytr) fitcensemble(Xtr, Ytr, 'Method', 'Bag', 'NumLearningCycles', 150)), ...
% Random Forest Optimizado (mayor número de árboles y min leaf size)
    struct('nombre', 'Random Forest Optimizado', ...
           'modelo', @(Xtr, Ytr) fitcensemble(Xtr, Ytr, 'Method', 'Bag', ...
           'NumLearningCycles', 300, 'Learners', templateTree('MinLeafSize', 3))), ...

    struct('nombre', 'SVM RBF (Cost-Sensitive)', ...
           'modelo', @(Xtr, Ytr) fitcecoc(Xtr, Ytr, 'Learners', templateSVM('KernelFunction', 'rbf', 'Standardize', true), 'Cost', coste)), ...
           
    struct('nombre', 'SVM Lineal', ...
           'modelo', @(Xtr, Ytr) fitcecoc(Xtr, Ytr, 'Learners', templateSVM('KernelFunction', 'linear', 'Standardize', true))), ...
           
    struct('nombre', 'KNN (k=5 Ponderado)', ...
           'modelo', @(Xtr, Ytr) fitcknn(Xtr, Ytr, 'NumNeighbors', 5, 'DistanceWeight', 'SquaredInverse', 'Standardize', true)), ...
           
    struct('nombre', 'Red Neuronal Patternnet', ...
           'modelo', @(Xtr, Ytr) fitcnet(Xtr, Ytr, 'LayerSizes', [12 6]))
};

clases_val = [0 1 2];
clases_nom = {'Asintomático', 'Sintomático', 'Control'};
resultados = {};

% Bucle de evaluación de modelos
for m = 1:length(modelos)
    nombre = modelos{m}.nombre;
    crearModelo = modelos{m}.modelo;
    Ypred_total = zeros(size(Y));
    
    % Bucle de 10 pliegues
    for k = 1:numFolds
        idxTrain = training(cv, k);
        idxTest  = test(cv, k);
        
        mdl = crearModelo(X(idxTrain, :), Y(idxTrain));
        Ypred_total(idxTest) = predict(mdl, X(idxTest, :));
    end
    
    % Matriz de Confusión Acumulada
    C = confusionmat(Y, Ypred_total, 'Order', clases_val);
    
    % Métricas
    accuracy = sum(diag(C)) / sum(C(:)) * 100;
    sens_por_clase = diag(C) ./ sum(C, 2); 
    sens_macro = mean(sens_por_clase, 'omitnan') * 100;
    
    resultados = [resultados; {nombre, accuracy, sens_macro}];
    
    % Representación visual estable con heatmap
    figure('Name', ['Matriz Confusión 10-Fold - ', nombre]);
    h = heatmap(clases_nom, clases_nom, C);
    h.Title = sprintf('%s (10-Fold CV) - Accuracy: %.1f%%', nombre, accuracy);
    h.XLabel = 'Clase Predicha';
    h.YLabel = 'Clase Real';
    h.Colormap = parula;
end

%% Tabla Resumen de Resultados
tabla_resultados = cell2table(resultados, ...
    'VariableNames', {'Modelo', 'Exactitud_Global_Pct', 'Sensibilidad_Macro_Pct'});

disp('--- RESULTADOS CON COLUMNAS DÍA/NOCHE Y 10-FOLD CV ---');
disp(tabla_resultados);