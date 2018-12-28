clc
clear all
close all

run('lib/addpath_recurse');
addpath_recurse('src/');
addpath_recurse('lib/');

%% PARAMETERS
global params
params=defineParams();
%params.tau=65; %Delay
params.T=120;

%% Figure S4

dirName=['/Users/ESB/Desktop/fliC_local/model_delay/_runIC_',datestr(now,'ddmmyyyy_HHMMSS'),'/'];
%dirName=['figures/model_delay/'];
if ~exist(dirName,'dir')
    mkdir(dirName);
end

T=20;
delays=[0,50,100];


    params.inState(:)=[6.93, 0.39, 15.60, 8.14,0.3,14.96];
        
    figure(); clf('reset'); set(gca,'fontsize',14); set(gcf,'DefaultLineLineWidth',2); set(gcf, 'color', 'white'); 
    set(gcf,'Units','normalized','Position',[0.2    0.1000    0.5    0.25])
    for d=1:length(delays)
        params.tau=delays(d);
        params.T=T+params.tau;

        [time, y]=simulateDelay(params);
        time=time-params.tau; 

        % PLOT TIMESERIES
        subaxis(1,length(delays),d,'pb',.1)
        plotState(time, y, 0);
        axis([0 time(end) 0 20]);
        title(['Delay=',num2str(params.tau)]);
        %ret=strParams(params);
        %text(1.04*time(end), yl(2),ret)
        if d==length(delays)
            ret=sprintf('y(0)=\n%3.2f\n%3.2f\n%3.2f\n%3.2f\n%3.2f\n%3.2f\n',params.inState);
            yl=get(gca,'ylim');
            text(1.04*time(end), .3*yl(2),ret)
            %export_fig([dirName,'_simdelay_n',num2str(n),'.pdf']);
            close;
        end
    end


