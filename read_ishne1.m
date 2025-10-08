% Read ISHNE ecgSig file : 
%  function mat=read_ishne(fileName, startOffset, length);    
% Input--------------------------------------------------------       
%  fileName : the ishne filename including the path
%  startOffset: the start offset to read ecgSig
%  length:      length of ecgSig to read
% Ouput--------------------------------------------------------
%  ecgSig : ECG signal
% Adapted from
%  http://thew-project.org/THEWFileFormat.htm
% http://thew-project.org/document/read_ishne.m.txt
% by Pedro Gomis (2018)
% Contains some additional information in the header, including the 
% "real" samples recorded
function [ishneHeader, ecgSig]=read_ishne1(fileName, startOffset, length)
fid=fopen(fileName,'r');
if ne(fid,-1)
    
    %Magic number
    magicNumber = fread(fid, 8, 'char');
   
    % get checksum
	checksum = fread(fid, 1, 'uint16');
	
	%read header
    Var_length_block_size = fread(fid, 1, 'long');
    ishneHeader.Sample_Size_ECG = fread(fid, 1, 'long');	
    ishneHeader.Offset_var_lenght_block = fread(fid, 1, 'long');
    Offset_ECG_block = fread(fid, 1, 'long');
    ishneHeader.Offset_ECG_block=Offset_ECG_block;
    File_Version = fread(fid, 1, 'short');
    ishneHeader.First_Name = fread(fid, 40, 'char');  									        								
    ishneHeader.Last_Name = fread(fid, 40, 'char');  									        								
    ID = fread(fid, 20, 'char');  									        								
    Sex = fread(fid, 1, 'short');
    Race = fread(fid, 1, 'short');
    Birth_Date = fread(fid, 3, 'short');	
    Record_Date = fread(fid, 3, 'short');	
    File_Date = fread(fid, 3, 'short');	
    Start_Time = fread(fid, 3, 'short');	
    ishneHeader.nbLeads = fread(fid, 1, 'short');
    ishneHeader.Lead_Spec = fread(fid, 12, 'short');	
    ishneHeader.Lead_Qual = fread(fid, 12, 'short');	
    ishneHeader.Resolution = fread(fid, 12, 'short');	
    Pacemaker = fread(fid, 1, 'short');	
    ishneHeader.Recorder = fread(fid, 40, 'char');
    ishneHeader.Sampling_Rate = fread(fid, 1, 'short');	
    ishneHeader.Proprietary = fread(fid, 80, 'char');
    Copyright = fread(fid, 80, 'char');
    Reserved = fread(fid, 88, 'char');
    
    % read variable_length block
    varblock = fread(fid, Var_length_block_size, 'char');
    % Miramos la integridad header vs contenido real grabado
    fseek(fid, 0, 'eof');
    bytes_totales = ftell(fid);
    samples_recorded = round((bytes_totales - Offset_ECG_block)/2/ishneHeader.nbLeads);
    if abs(ishneHeader.Sample_Size_ECG-samples_recorded > 584)
        ishneHeader.samples_recorded=samples_recorded;
    end
    % get data at start
    offset = startOffset*ishneHeader.Sampling_Rate*ishneHeader.nbLeads*2; % each data has 2 bytes
    fseek(fid, Offset_ECG_block+offset, 'bof');
    
   
    % read ecgSig signal
    numSample = length*ishneHeader.Sampling_Rate;
    ecgSig = fread(fid, [ishneHeader.nbLeads, numSample], 'int16')';
     
    fclose(fid);
 else
     ihsneHeader = [];
     ecgSig=[];
 end
