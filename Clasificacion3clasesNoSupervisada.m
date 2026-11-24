%% COMPARAR MODELOS SUPERVISADOS (3 CLASES) Y CLUSTERING NO SUPERVISADO
% Clases: 0 = Asintomático, 1 = Sintomático, 2 = Control

%% 1. Cargar todas las variables del archivo .mat
datos = load('indexes_HRV_30minT2.mat'); 
% datos = load('indexes_HRV_30minT3.mat'); % cargamos version 3 con 175 sujetos
%% 2. Inicializar matriz de características
X = [];

%% 3. Extraer y concatenar columnas 4 a 45 + columnas 52 a 53
nombres = fieldnames(datos);
for i = 1:length(nombres)
    matriz = datos.(nombres{i}); 
    Xtemp = matriz(:, 4:45); 
    
    % Imputación en dos fases: movmean y luego 'nearest' por si quedan NaNs al inicio
    Xtemp = fillmissing(Xtemp, 'movmean', 5, 2); 
    Xtemp = fillmissing(Xtemp, 'nearest', 2);
    
    % Columnas de día y noche
    Xdianoche = matriz(:, 52:53);
    Xdianoche = fillmissing(Xdianoche, 'nearest', 1);
    
    Xtemp = [Xtemp, Xdianoche]; 
    X = [X, Xtemp]; 
end

% Limpieza final por si alguna fila quedara incompleta tras concatenar
X = fillmissing(X, 'constant', 0);

%% 4. Extraer etiquetas (0: Asintomático, 1: Sintomático, 2: Control)
Y = datos.(nombres{1})(:, 2); 
sexo = datos.(nombres{1})(:, 3); % Opcional

%% 5. Normalización
X = normalize(X);

%% =========================================================================
%% PARTE I: CLUSTERING NO SUPERVISADO (PCA, K-Means, Jerárquico)
%% =========================================================================
fprintf('\n--- EJECUTANDO ANÁLISIS NO SUPERVISADO ---\n');

% A. Reducción de dimensionalidad con PCA
[coeff, score, latent, tsquared, explained] = pca(X);

% Gráfica de Varianza Explicada
figure('Name', 'PCA - Varianza Explicada');
pareto(explained);
xlabel('Componentes Principales');
ylabel('Porcentaje de Varianza Explicada');
title('Varianza acumulada por Componente (PCA)');

% Proyección 2D del PCA comparada con las etiquetas reales
figure('Name', 'Visualización PCA 2D');

% 1. Mapeo de colores y formas
colores = [0 0.4470 0.7410;   % Azul (Asintomático)
           0.8500 0.3250 0.0980; % Rojo (Sintomático)
           0.4660 0.6740 0.1880];% Verde (Control)
marcadores = {'o', '^', 's'};
clases_nom = {'Asintomático', 'Sintomático', 'Control'};
clases_val = [0, 1, 2];

% 2. Dibujar puntos
hold on;
for k = 1:length(clases_val)
    idx = (Y == clases_val(k));
    scatter(score(idx,1), score(idx,2), 50, colores(k,:), marcadores{k}, ...
        'filled', 'DisplayName', clases_nom{k});
end
hold off;

% 3. Formatear etiquetas de varianza de forma segura
var1 = double(explained(1));
var2 = double(explained(2));

xlabel(sprintf('PC1 (%.1f%% var)', var1));
ylabel(sprintf('PC2 (%.1f%% var)', var2));
title('Proyección de los Pacientes en Espacio PCA (Labels Reales)');

% 4. Ajustes finales de ejes y leyenda fija (sin 'best' para evitar el fallo de SceneNode)
grid on;
axis tight;
legend('Location', 'northeastoutside'); % 'northeast' o 'northeastoutside' evitan el fallo de cálculo

% B. Clustering K-Means (k = 3)
k = 3;
idx_kmeans = kmeans(X, k, 'Replicates', 10);

figure('Name', 'K-Means Clustering');

colores_km = [0.4940 0.1840 0.5560;  % Púrpura
              0.3010 0.7450 0.9330;  % Cian
              0.6350 0.0780 0.1840]; % Granate
marcadores_km = {'d', 'p', 'h'};
nom_clusters = {'Cluster 1', 'Cluster 2', 'Cluster 3'};

hold on;
for c = 1:k
    idx = (idx_kmeans == c);
    scatter(score(idx,1), score(idx,2), 50, colores_km(c,:), marcadores_km{c}, ...
        'filled', 'DisplayName', nom_clusters{c});
end
hold off;

var1 = double(explained(1));
var2 = double(explained(2));

xlabel(sprintf('PC1 (%.1f%% var)', var1));
ylabel(sprintf('PC2 (%.1f%% var)', var2));
title('Grupos detectados por K-Means (sin supervisión)');

grid on;
axis tight;
legend('Location', 'northeastoutside');

% C. Clustering Jerárquico
% matriz_dist = pdist(X, 'euclidean');
% arbol = linkage(matriz_dist, 'ward');
% 
% figure('Name', 'Dendrograma - Clustering Jerárquico');
% dendrogram(arbol, 0);
% title('Dendrograma de Agrupamiento Jerárquico (Ward)');
% xlabel('Índice del Paciente');
% ylabel('Distancia');
