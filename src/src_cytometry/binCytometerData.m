function [e nFL1]=binCytometerData(fileName,icells, N)

    M=importdata(fileName);
    FSC=M.data(:,1);
    SSC=M.data(:,2);
    FL1=M.data(:,3);
    FL3=M.data(:,4);
    FL4=M.data(:,5);
    
    
    FL1=FL1(icells);
    
    
    
    %maxC=1e4;
    maxC=max(FL1);
    %e=min(FL1):(max(FL1)-min(FL1))/N:max(FL1)
    e=1:maxC/N:maxC;
    nFL1= histc(FL1, e);
    
  
    nFL1=nFL1./max(nFL1);