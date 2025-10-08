function varargout = armaspectra(B,A,e,Nfft,fs)
%ARMASPECTRA Calcula la Densidad de potencia espectral, PSD
%   del modelo ARMA dado por A, B y la varianza e del error
%   A(q)y(n)=B(q)e(n) o AR si B(q)=1
%
%   armaspectra(B,A,e,Nfft,fs)
%
%   Grafica la PSD de la señal modelada
%
%   [Px,f]=armaspectra(B,A,e,Nfft,fs)
%
%   Px: PSD en funcion de f
%   fs: frecuencia de muestreo (valor por defecto = 1)
%   Se usa la funcion freqz con 'whole' (todo el circulo unitario en z)
%   Nfft: numero de puntos para hallar la resp frec(valor por defecto =512)
%   Nfft: puede ser un vector de los puntos de frecuencia a calcular
%         ejemplo si fs = 1000, Nfft=0:05:fs

% Pedro Gomis marzo, 2003

if nargin < 5, fs=1;, end
if nargin < 4, Nfft=[]; end
if isempty(Nfft), Nfft=512; end

[H,f]=freqz(B,A,Nfft,'whole',fs);
H=H(:);
f=f(:);
Px=e*(abs(H).^2)/fs;  % PSD (de ambos lados del espectro)
if length(Nfft)==1 %Nfft es un escalar
   Nfft=Nfft;
else
       Nfft=length(f);
end
if rem(Nfft,2), % se evalua la paridad de nfft
  select = (1:(Nfft+1)/2); % si Nfft es impar 
else
  select = (1:Nfft/2+1); % si Nfft es par
end

Px_unlado=Px(select);
Px_u=[Px_unlado(1); 2*Px_unlado(2:end-1);Px_unlado(end)];
fu=f(select);
if nargout==0,
   plot(fu,10*log10(Px_u))
   grid
   xlabel('frecuencia (Hz)')
   ylabel ('PSD (dB/Hz)')
   if (length(B)==1) & (B(1)==1)
       title('PSD con modelado AR')
   else
   title('PSD con modelado ARMA')
   end
else
   varargout{1} = Px_u;
   varargout{2} = fu;
end

