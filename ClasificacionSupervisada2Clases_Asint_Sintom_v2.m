%% COMPARA MODELOS MULTICLASE (2 CLASES) CON CARACTERÍSTICAS DÍA/NOCHE
% Clase: 0 = Asintomático 1 = Sintomático, 2 = Control

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
%% CLASIFICACIÓN JERÁRQUICA - ETAPA 2: ASINTOMÁTICOS (0) VS SINTOMÁTICOS (1)
%% =========================================================================
fprintf('\n--- EJECUTANDO ETAPA 2: ESTRATIFICACIÓN DE RIESGO BRUGADA (10-FOLD CV) ---\n');

% 1. Filtrar solo pacientes con Brugada (Excluir Controles, Y == 2)
idx_brs = (Y == 0 | Y == 1);
X_etapa2 = X(idx_brs, :);
Y_etapa2 = Y(idx_brs); % 0 = Asintomático (N=87), 1 = Sintomático (N=35)

% 2. Configurar Validación Cruzada 10-Fold
rng(42); 
numFolds = 10;
cv2 = cvpartition(Y_etapa2, 'KFold', numFolds, 'Stratify', true);

% 3. Ponderación por desbalance de clases (87 Asintomáticos vs 35 Sintomáticos)
% Peso inverso a la frecuencia de clase (~ 2.5 : 1)
pesos_clase = [1, 87/35]; 

modelos_e2 = {
    struct('nombre', 'Random Forest (Balanceado)', ...
           'modelo', @(Xtr, Ytr) fitcensemble(Xtr, Ytr, 'Method', 'Bag', ...
           'NumLearningCycles', 200, 'Learners', templateTree('MinLeafSize', 2))), ...
           
    % struct('nombre', 'SVM RBF (Kernel Gaussiano)', ...
    %        'modelo', @(Xtr, Ytr) fitcecoc(Xtr, Ytr, ...
    %        'Learners', templateSVM('KernelFunction', 'rbf', 'Standardize', true))), ...
    struct('nombre', 'SVM lineal', ...
           'modelo', @(Xtr, Ytr) fitcecoc(Xtr, Ytr, ...
           'Learners', templateSVM('KernelFunction', 'linear', 'Standardize', true))), ...
           
    struct('nombre', 'KNN (k=3 Ponderado)', ...
           'modelo', @(Xtr, Ytr) fitcknn(Xtr, Ytr, 'NumNeighbors', 3, ...
           'DistanceWeight', 'SquaredInverse', 'Standardize', true)), ...
           
    struct('nombre', 'Regresión Logística', ...
           'modelo', @(Xtr, Ytr) fitglm(Xtr, Ytr, 'Distribution', 'binomial'))
};

clases_val_e2 = [0 1];
clases_nom_e2 = {'Asintomático', 'Sintomático'};
resultados_e2 = {};

% 4. Bucle de evaluación de la Etapa 2
for m = 1:length(modelos_e2)
    nombre = modelos_e2{m}.nombre;
    crearModelo = modelos_e2{m}.modelo;
    Ypred_total = zeros(size(Y_etapa2));
    
    for k = 1:numFolds
        idxTrain = training(cv2, k);
        idxTest  = test(cv2, k);
        
        Xtr = X_etapa2(idxTrain, :);
        Ytr = Y_etapa2(idxTrain);
        Xte = X_etapa2(idxTest, :);
        
        if contains(nombre, 'Regresión Logística')
            % Manejo especial para fitglm
            mdl = crearModelo(Xtr, Ytr);
            prob = predict(mdl, Xte);
            Ypred_total(idxTest) = double(prob >= 0.5);
        else
            mdl = crearModelo(Xtr, Ytr);
            Ypred_total(idxTest) = predict(mdl, Xte);
        end
    end
    
    % Matriz de Confusión Binaria (2x2)
    C = confusionmat(Y_etapa2, Ypred_total, 'Order', clases_val_e2);
    
    % Métricas
    accuracy = sum(diag(C)) / sum(C(:)) * 100;
    sens_asint = C(1,1) / sum(C(1,:)) * 100; % Asintomáticos bien clasificados
    sens_sint  = C(2,2) / sum(C(2,:)) * 100; % Sintomáticos bien clasificados (Recall clínico)
    sens_macro = (sens_asint + sens_sint) / 2;
    
    resultados_e2 = [resultados_e2; {nombre, accuracy, sens_sint, sens_asint, sens_macro}];
    
    % Visualización
    figure('Name', ['Etapa 2 - Matriz Confusión: ', nombre]);
    h = heatmap(clases_nom_e2, clases_nom_e2, C);
    h.Title = sprintf('Etapa 2: %s - Accuracy: %.1f%%', nombre, accuracy);
    h.XLabel = 'Predicho';
    h.YLabel = 'Real';
    h.Colormap = parula;
end

% 5. Mostrar Tabla Resumen de Etapa 2
tabla_etapa2 = cell2table(resultados_e2, ...
    'VariableNames', {'Modelo', 'Exactitud_Global_Pct', 'Sensibilidad_Sintomatico_Pct', 'Especificidad_Asintomatico_Pct', 'Sensibilidad_Macro_Pct'});

disp('--- RESULTADOS ETAPA 2: ASINTOMÁTICOS VS SINTOMÁTICOS (10-FOLD CV) ---');
disp(tabla_etapa2);

%% =========================================================================
%% ETAPA 2 OPTIMIZADA: RANDOM FOREST CON PESOS Y UMBRAL AJUSTADO
%% =========================================================================
fprintf('\n--- EJECUTANDO ETAPA 2 OPTIMIZADA (RANDOM FOREST) ---\n');

% 1. Asignar pesos por clase para compensar el desbalance (87/35)
pesos = zeros(size(Y_etapa2));
pesos(Y_etapa2 == 0) = 1.0;            % Asintomáticos
pesos(Y_etapa2 == 1) = 87 / 35;        % Sintomáticos (mayor peso)

rng(42);
numFolds = 10;
cv2 = cvpartition(Y_etapa2, 'KFold', numFolds, 'Stratify', true);

% Guardar probabilidades en lugar de clases directas
prob_sintomatico = zeros(size(Y_etapa2));

for k = 1:numFolds
    idxTrain = training(cv2, k);
    idxTest  = test(cv2, k);
    
    Xtr = X_etapa2(idxTrain, :);
    Ytr = Y_etapa2(idxTrain);
    Wtr = pesos(idxTrain);
    
    Xte = X_etapa2(idxTest, :);
    
    % Entrenar Random Forest Ponderado
    mdl = fitcensemble(Xtr, Ytr, 'Method', 'Bag', ...
                       'NumLearningCycles', 300, ...
                       'Weights', Wtr, ...
                       'Learners', templateTree('MinLeafSize', 1));
                   
    % Obtener probabilidades a posteriori
    [~, scores] = predict(mdl, Xte);
    prob_sintomatico(idxTest) = scores(:, 2); % Probabilidad de ser Sintomático (Clase 1)
end

% 2. Evaluar diferentes umbrales de decisión (Thresholds)
umbrales = [0.50, 0.40, 0.35, 0.30];
resultados_th = {};

for t = umbrales
    Ypred_th = double(prob_sintomatico >= t);
    
    C = confusionmat(Y_etapa2, Ypred_th, 'Order', [0 1]);
    
    acc = sum(diag(C)) / sum(C(:)) * 100;
    sens_sint = C(2,2) / sum(C(2,:)) * 100;  % Sensibilidad (Sintomáticos)
    espec_asint = C(1,1) / sum(C(1,:)) * 100; % Especificidad (Asintomáticos)
    sens_macro = (sens_sint + espec_asint) / 2;
    
    resultados_th = [resultados_th; {sprintf('RF (Umbral %.2f)', t), acc, sens_sint, espec_asint, sens_macro}];
end

tabla_umbrales = cell2table(resultados_th, ...
    'VariableNames', {'Configuracion', 'Exactitud_Global_Pct', 'Sensibilidad_Sintomatico_Pct', 'Especificidad_Asintomatico_Pct', 'Sensibilidad_Macro_Pct'});

disp('--- EFECTO DEL UMBRAL EN LA DETECCIÓN DE SINTOMÁTICOS ---');
disp(tabla_umbrales);

%% =========================================================================
%% PIPELINE COMPLETO DE CLASIFICACIÓN JERÁRQUICA (CORREGIDO)
%% =========================================================================
fprintf('\n=========================================================\n');
fprintf('   RESUMEN FINAL: CLASIFICACIÓN JERÁRQUICA EN 2 ETAPAS   \n');
fprintf('=========================================================\n');

umbral_optimo = 0.5; % propuesto 0.35 (35% sintomáticos) o 0.5

rng(42);
numFolds = 10;
cv = cvpartition(Y, 'KFold', numFolds, 'Stratify', true);

Ypred_jerarquico = zeros(size(Y)); 

for k = 1:numFolds
    idxTrain = training(cv, k);
    idxTest  = test(cv, k);
    
    Xtr = X(idxTrain, :);
    Ytr = Y(idxTrain);
    Xte = X(idxTest, :);
    
    % --- ETAPA 1: Control (0) vs Brugada (1) ---
    Ytr_e1 = double(Ytr == 0 | Ytr == 1);
    mdl_e1 = fitcecoc(Xtr, Ytr_e1, 'Learners', templateSVM('KernelFunction', 'linear', 'Standardize', true));
    pred_e1_test = predict(mdl_e1, Xte); % 0 = Control, 1 = Brugada
    
    % --- ETAPA 2: Solo entrenamos con Brugada reales del train set ---
    idx_brs_tr = (Ytr == 0 | Ytr == 1);
    Xtr_e2 = Xtr(idx_brs_tr, :);
    Ytr_e2 = Ytr(idx_brs_tr); % 0=Asint, 1=Sint
    
    pesos_e2 = zeros(size(Ytr_e2));
    pesos_e2(Ytr_e2 == 0) = 1.0;
    pesos_e2(Ytr_e2 == 1) = 87 / 35;
    
    mdl_e2 = fitcensemble(Xtr_e2, Ytr_e2, 'Method', 'Bag', ...
                          'NumLearningCycles', 300, ...
                          'Weights', pesos_e2, ...
                          'Learners', templateTree('MinLeafSize', 1));
                      
    % Predicción de Etapa 2 sobre TODO el test fold para mapeo directo
    [~, scores_e2] = predict(mdl_e2, Xte);
    pred_e2_test = double(scores_e2(:, 2) >= umbral_optimo); % 1=Sint, 0=Asint
    
    % --- COMBINACIÓN CONDICIONAL CORRECTA POR PACIENTE ---
    fold_preds = zeros(sum(idxTest), 1);
    
    for i = 1:length(fold_preds)
        if pred_e1_test(i) == 0
            fold_preds(i) = 2; % Predicho Control por Etapa 1
        else
            % Si la Etapa 1 predijo Brugada, la Etapa 2 decide si es Sint (1) o Asint (0)
            if pred_e2_test(i) == 1
                fold_preds(i) = 1; % Sintomático
            else
                fold_preds(i) = 0; % Asintomático
            end
        end
    end
    
    Ypred_jerarquico(idxTest) = fold_preds;
end

% Matriz de Confusión Global 3x3
clases_val = [0 1 2];
clases_nom = {'Asintomático', 'Sintomático', 'Control'};
C_jer = confusionmat(Y, Ypred_jerarquico, 'Order', clases_val);

acc_jer = sum(diag(C_jer)) / sum(C_jer(:)) * 100;

% Métricas por clase
sens_asint = C_jer(1,1)/sum(C_jer(1,:)) * 100;
sens_sint  = C_jer(2,2)/sum(C_jer(2,:)) * 100;
sens_ctrl  = C_jer(3,3)/sum(C_jer(3,:)) * 100;

fprintf('\nExactitud Global del Enfoque Jerárquico: %.2f%%\n', acc_jer);
fprintf('Detección Asintomáticos: %.1f%%\n', sens_asint);
fprintf('Detección Sintomáticos:  %.1f%%\n', sens_sint);
fprintf('Detección Controles:     %.1f%%\n', sens_ctrl);

figure('Name', 'Matriz de Confusión Final - Clasificación Jerárquica');
h = heatmap(clases_nom, clases_nom, C_jer);
h.Title = sprintf('Clasificación Jerárquica en 2 Etapas (10-Fold CV) - Accuracy: %.1f%%', acc_jer);
h.XLabel = 'Clase Predicha';
h.YLabel = 'Clase Real';
h.Colormap = parula;

%% =========================================================================
%% GENERACIÓN DE CURVA ROC Y CÁLCULO DE AUC PARA LA ETAPA 2
%% =========================================================================
fprintf('\n--- CALCULANDO CURVA ROC Y AUC DE LA ETAPA 2 ---\n');

% Extraer probabilidades acumuladas del Random Forest en Etapa 2
[Xroc, Yroc, T, AUC] = perfcurve(Y_etapa2, prob_sintomatico, 1);

figure('Name', 'Curva ROC - Estratificación de Riesgo (Etapa 2)');
plot(Xroc, Yroc, 'b-', 'LineWidth', 2); hold on;
plot([0 1], [0 1], 'k--', 'LineWidth', 1); % Línea aleatoria

% Marcar los puntos de los umbrales evaluados
[~, idx_050] = min(abs(T - 0.50));
[~, idx_035] = min(abs(T - 0.35));

plot(Xroc(idx_050), Yroc(idx_050), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
text(Xroc(idx_050)+0.03, Yroc(idx_050)-0.03, sprintf('Umbral 0.50 (Sens: %.1f%%, Espec: %.1f%%)', Yroc(idx_050)*100, (1-Xroc(idx_050))*100));

plot(Xroc(idx_035), Yroc(idx_035), 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g');
text(Xroc(idx_035)+0.03, Yroc(idx_035)-0.03, sprintf('Umbral 0.35 (Sens: %.1f%%, Espec: %.1f%%)', Yroc(idx_035)*100, (1-Xroc(idx_035))*100));

xlabel('1 - Especificidad (Falsos Positivos)');
ylabel('Sensibilidad (Verdaderos Positivos en Sintomáticos)');
title(sprintf('Curva ROC Etapa 2: Sintomáticos vs. Asintomáticos (AUC = %.3f)', AUC));
grid on;