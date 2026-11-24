%% COMPARA MODELOS MULTICLASE (2 CLASES) CON CARACTERÍSTICAS DÍA/NOCHE
% Clase: 1 = BrS (Asintomático + Sintomático), 0 = Control

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
       contains(nombre_var, 'Ratio') 
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
%% CLASIFICACIÓN JERÁRQUICA - ETAPA 1: CONTROLES (0) VS BRUGADA (1)
%% =========================================================================
fprintf('\n--- EJECUTANDO ETAPA 1: CONTROLES VS PACIENTES BRUGADA (10-FOLD CV) ---\n');

% 1. Recodificar etiquetas para Etapa 1: 0 = Control, 1 = Brugada (Sint + Asint)
% Y original: 0=Asint, 1=Sint, 2=Control
Y_etapa1 = zeros(size(Y));
Y_etapa1(Y == 0 | Y == 1) = 1; % Brugada (Asintomáticos + Sintomáticos)
Y_etapa1(Y == 2)          = 0; % Control

% 2. Configurar Validación Cruzada 10-Fold
rng(42); 
numFolds = 10;
cv1 = cvpartition(Y_etapa1, 'KFold', numFolds, 'Stratify', true);

% 3. Modelos para la Etapa 1
modelos_e1 = {
    struct('nombre', 'Random Forest', ...
           'modelo', @(Xtr, Ytr) fitcensemble(Xtr, Ytr, 'Method', 'Bag', 'NumLearningCycles', 150)), ...
           
    struct('nombre', 'SVM RBF', ...
           'modelo', @(Xtr, Ytr) fitcecoc(Xtr, Ytr, 'Learners', templateSVM('KernelFunction', 'rbf', 'Standardize', true))), ...
           
    struct('nombre', 'SVM Lineal', ...
           'modelo', @(Xtr, Ytr) fitcecoc(Xtr, Ytr, 'Learners', templateSVM('KernelFunction', 'linear', 'Standardize', true))), ...
           
    struct('nombre', 'KNN (k=5 Ponderado)', ...
           'modelo', @(Xtr, Ytr) fitcknn(Xtr, Ytr, 'NumNeighbors', 5, 'DistanceWeight', 'SquaredInverse', 'Standardize', true)), ...
           
    struct('nombre', 'Red Neuronal Patternnet', ...
           'modelo', @(Xtr, Ytr) fitcnet(Xtr, Ytr, 'LayerSizes', [10 5]))
};

clases_val_e1 = [0 1];
clases_nom_e1 = {'Control', 'Brugada'};
resultados_e1 = {};

% 4. Bucle de evaluación de la Etapa 1
for m = 1:length(modelos_e1)
    nombre = modelos_e1{m}.nombre;
    crearModelo = modelos_e1{m}.modelo;
    Ypred_total = zeros(size(Y_etapa1));
    score_total = zeros(size(Y_etapa1));
    for k = 1:numFolds
        idxTrain = training(cv1, k);
        idxTest  = test(cv1, k);
        
        mdl = crearModelo(X(idxTrain, :), Y_etapa1(idxTrain));
        % Ypred_total(idxTest) = predict(mdl, X(idxTest, :));
        [Ypred, score] = predict(mdl, X(idxTest,:));

        Ypred_total(idxTest) = Ypred;

        % Probabilidad de pertenecer a Brugada
        score_total(idxTest) = score(:,2);
    end
    
    % Matriz de Confusión Binaria (2x2)
    C = confusionmat(Y_etapa1, Ypred_total, 'Order', clases_val_e1);
    
    % Métricas binarias
    accuracy = sum(diag(C)) / sum(C(:)) * 100;
    
    % Especificidad (Control): TN / (TN + FP)
    especificidad = C(1,1) / sum(C(1,:)) * 100;
    
    % Sensibilidad (Brugada): TP / (TP + FN)
    sensibilidad = C(2,2) / sum(C(2,:)) * 100;
    
    % Sensibilidad Macro (Promedio balanceado de ambas clases)
    sens_macro = (especificidad + sensibilidad) / 2;
    
    
 %% GENERACIÓN DE CURVA ROC Y CÁLCULO DE AUC PARA LA ETAPA 1
    [Xroc, Yroc, T, AUC] = perfcurve(Y_etapa1, score_total,1); % 1 = clase positiva (Brugada)
    figure('Name',['ROC - ', nombre]);
    plot(Xroc,Yroc,'b-','LineWidth',2);
    hold on;
    plot([0 1],[0 1],'k--');
    xlabel('1 - Especificidad');
    ylabel('Sensibilidad');

    title(sprintf('%s (AUC = %.3f)', nombre, AUC));
    resultados_e1 = [resultados_e1; {nombre, accuracy, sensibilidad, especificidad, sens_macro, AUC}];
    % Visualización de Matriz de Confusión
    figure('Name', ['Etapa 1 - Matriz Confusión: ', nombre]);
    h = heatmap(clases_nom_e1, clases_nom_e1, C);
    h.Title = sprintf('Etapa 1: %s - Accuracy: %.1f%%', nombre, accuracy);
    h.XLabel = 'Predicho';
    h.YLabel = 'Real';
    h.Colormap = parula;
end

%% 5. Mostrar Tabla Resumen de Etapa 1
% tabla_etapa1 = cell2table(resultados_e1, ...
%     'VariableNames', {'Modelo', 'Exactitud_Global_Pct', 'Sensibilidad_Brugada_Pct', 'Especificidad_Control_Pct', 'Sensibilidad_Macro_Pct'});
tabla_etapa1 = cell2table(resultados_e1,...
'VariableNames',...
{'Modelo',...
'Exactitud_Global_Pct',...
'Sensibilidad_Brugada_Pct',...
'Especificidad_Control_Pct',...
'Sensibilidad_Macro_Pct',...
'AUC'});

disp('--- RESULTADOS ETAPA 1: CONTROLES VS BRUGADA (10-FOLD CV) ---');
disp(tabla_etapa1);