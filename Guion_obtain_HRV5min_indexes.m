%% Script computes HRV time, frequency and DFA (alpha) values
%  
%  uses calc_HRVshort
% P Gomis, 2021
% patients=[1:8, 10:40, 42:46];
patients=[1:8];
%patients=[1,3:6,8:12,14:19,21,22,25,27:32,34,35,40,42,43,45,46];
Result5min=zeros(length(patients),51);
Result5min(:,1)=patients';
segments=(1:5);
for i=1:length(patients)
    numPat=num2str(patients(i));
    if patients(i)<10
        numPat =['0' numPat];
    end
    v =genvarname(['RR_' numPat]);
    eval([ 'load '  v])  %i.e. load RR_05
    
    for n=1:length(segments)
        %eval([ 'load '  v])
        numSeg=num2str(segments(n));
%         if segments(n)<10
%             numSeg =['0' numSeg];
%         end
        v1=genvarname(['RRdata' numSeg ]);
        eval(['RRf = ' v1 '(:,2);'])
        eval(['tt = ' v1 '(:,1);'])
        tt = tt-tt(1);
        data5min = [tt, RRf];
        %v1=genvarname(['RRf' numSeg ]);
        %v2=genvarname(['tt' numSeg ]);
        %eval(['data5min=([' v2 ' ' v1 ']);'])
        [P,E,HR,a]=calc_HRVshort(data5min);
        position = 2+((segments(n)-1)*10);
        Result5min(i,position:(position+9))=[P(3:7)' E(1:3)' HR(1:1) a(1:1)];
        %save indixesHRV_segments5min.mat
        clear a data P E HR num* P t*
    end
end

%lnFREQ=log(Result5min(:,[2:5 7]));
Res_freq5min= Result5min(:,[1 2:6 12:16 22:26 32:36 42:46]);
Res_DFA5min = Result5min(:,[1 11:10:51]);
Res_temp5min=Result5min(:,[1 7:10 17:20 27:30 37:40 47:50]);
save indexes_HRV_5min Result5min Res_freq5min Res_DFA5min Res_temp5min
% xlswrite('res24h3.xls', Result24);
xlswrite('res_freq5min.xls', Res_freq5min);
xlswrite('res_DFA5min.xls', Res_DFA5min);
xlswrite('res_temp5min.xls', Res_temp5min);

