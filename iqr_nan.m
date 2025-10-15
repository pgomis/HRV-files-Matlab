function [iqr_val, q25, q75] = iqr_nan(data)
% Calcula el IQR, Q1 (p25) y Q3(p75) con valores NaN
% [iqr_val, q25, q75] = iqr_nan(data)
% data: vector de datos que pueden contener NaN
% P.Gomis, 2025
    dataN = data(~isnan(data));
    % Se calcula Q1 (p25) y Q3 (p75)
    q75 = prctile(dataN, 75);
    q25 = prctile(dataN, 25);
    iqr_val = q75 - q25;
end
