function [dfa2]=dfa_2(data,n1,n2)
% Computes HRV DFA (alpha_2) index from R-R intervals.
%
% alfa_2 = dfa_2(data)
% alfa_2 = dfa_2(data,n1,n2)
%
% Input: data= 2 column input [time values], values= filtered RR intervals
%  Default values n1 = 12 to n2 = 20
%
%  Values used by Peng, 1995: n1=16, n2=64
%  Values used by Huikuri, 2000: n1>11; (segments of 8000 RR)
%  Values used by Stein, 2010:  n1=12, n2=20
%  Values recomended by Peña, 2009:  n2 < length(data)/10
%   
%
% P. Gomis 2006, 2011

if nargin < 3, n2 = []; end
if isempty(n2), n2=20; end
if nargin < 2, n1=[]; end
if isempty(n1), n1=12; end
N1 =length(data);
RR1=data(:,2)/1000; % RR in sec
RRave=mean(RR1); % average RR
Yk = cumsum(RR1-RRave); %integration
i=1;
n=zeros(n2-n1+1,1);
F=zeros(n2-n1+1,1);
while n1<=n2
    n(i)=n1;
    m=n1; %limit superior de l'interval
    ind=1; %limit inferior de l'interval
    while m<=N1
        yn=polyfit((ind:m)',Yk(ind:m),1); %coeficients de la recta
        ynk=polyval(yn,ind:m); %avaluacio dels coeficients a cada valor de l'eix x que tenim
        Yl(ind:m)=Yk(ind:m)-ynk';
        ind=ind+n1;
        m=m+n1;
    end
    %calculem F per a aquesta amplada n1:
    F(i)=sqrt(sum(Yl.^2)/length(Yl));
    n1=n1+1;
    i=i+1;
end
regressioF=polyfit(log10(n),log10(F),1); %coeficients de la recta
dfa2=regressioF(1,1);
% rectaF=polyval(regressioF,eixx);

