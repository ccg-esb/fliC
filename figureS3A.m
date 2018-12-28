clc
clear all


run('lib/addpath_recurse');
addpath_recurse('src/');
addpath_recurse('lib/');

%% LOAD TIME-SERIES DATA

load('data/fliC.mat')
numCells=length(data);
frame2minutes=5;
maxGFP = max([data{:,3}]);
minGFP = min([data{:,3}]);
meanGFP = mean([data{:,3}]);
T=data{1,2}(end);
time=data{1,2}*frame2minutes;

%% QUANTIZE TIME-SERIES
ns=1:10;  %Number of states
n_errors=zeros(1,length(ns));
for in=1:length(ns)
    n=ns(in);

    % FIND OPTIMAL STATE VALUES
    sig=[];
    for num=1:numCells    
        times=(data{num,2}-1)*frame2minutes;
        gfps=(minGFP+data{num, 3});
        T = times(end);	

        [X, f, y, y2] = fftf(times, gfps, [], max(ns));
        ff_gfps=X.*maxGFP;

        sig=[sig ff_gfps];
    end    

    %Now quantize based on the combined statistics
    states=[minGFP, defineStates(sig, n)];

    % QUANTIZE TIME SERIES    
    fliCseq={};
    sum_error=0;
    for num=1:numCells
        times=(data{num,2}-1)*frame2minutes;
        gfps=data{num, 3};  
        [ff_gfps, f, y, y2] = fftf(times, gfps, [], 20);
        ff_gfps=ff_gfps.*max(gfps);
        qgfps=quantizeTimeSeries(gfps, ff_gfps, states);

        this_error=norm(qgfps-gfps');
        sum_error=sum_error+this_error;
        
        if n==6 %Plot and export 
            plotQuantizedGFP(times, gfps, ff_gfps, qgfps, states, data{num,1});
            fileName=['figures/timeseries_quantized/',num2str(length(states)),'states_cell',num2str(num),'.pdf'];
            eval(['export_fig ',fileName]);
        end
    end
    n_errors(in)=sum_error/numCells;
    disp(['Total error (',num2str(length(states)),' states)=',num2str(sum_error)]);
    disp(' ');
end

%% 
if length(ns)>1

    figure();
    clf('reset');  set(gcf,'color','white'); set(gcf,'DefaultLineLineWidth',1)
    plot(ns+1, n_errors,'ko','MarkerFaceColor','k','MarkerSize',10,'LineWidth',2);hold on
    plot(ns+1, n_errors,'k:','LineWidth',2);
    xlabel('Number of states','FontSize',18);
    ylabel('Mean Residual','FontSize',18);
    set(gca,'fontsize',14);
    fileNameResidual='figures/timeseries_quantized/residuals.pdf';
    eval(['export_fig ',fileNameResidual]);
    
end
