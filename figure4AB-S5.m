%SCRIPT THAT ESTIMATES THE DISTRIBUTION OF RETURN TIMES (ON->OFF->ON)
%FOR DIFFERENT VALUES OF NOISE AND A GIVEN DELAY

clc
clear all

run('lib/addpath_recurse');
addpath_recurse('src/');
addpath_recurse('lib/');

%%

cutoff=10;

N=100;  %Replicates
T=5e3; %5e3; %Length of experiment
tau=1e3; %1e3; %Delay
%omegas=10:10:50;  %Noise intensity

omegas=20;

%%
SAVE_DATA=0;
SAVE_RUNS=0;
SAVE_PLOTS=0;

if (SAVE_RUNS==1 || SAVE_DATA==1 || SAVE_PLOTS) && ~exist('dirName','var')
    dirName=['gillespie_return/_gillespie_return_tau',num2str(tau),'_omegas_',datestr(now,'yyyymmdd_HHMMSS'),'/'];
    if ~exist(dirName,'dir')
        mkdir(dirName);
    end
    disp(['mkdir ',dirName]);
end

if SAVE_DATA==1 && ~exist('dirName_data','var')
    dirName_data=[dirName,'data/'];
    if ~exist(dirName_data,'dir')
        mkdir(dirName_data);
    end
    disp(['mkdir ',dirName_data]);
end
  
if SAVE_RUNS==1 && ~exist('dirName_runs','var')
    dirName_runs=[dirName,'runs/'];
    if ~exist(dirName_runs,'dir')
        mkdir(dirName_runs);
    end
    disp(['mkdir ',dirName_runs]);
end



%%

return_times=[];
return_omegas=[];

escape_times=[];
escape_omegas=[];

gfp_all=[];


for iomega=1:length(omegas)
    omega=omegas(iomega);
    
    params=defineParams();
    
    for n=1:N
        
        dataFile=['data_tau',num2str(tau),'_omega',num2str(omega),'_N',num2str(n),'.mat'];
        if SAVE_DATA && exist([dirName_data,dataFile], 'file')
            load([dirName_data,dataFile]);
            if exist('time', 'var')
                t=time;
                clear time;
            end
        else
                if tau>0
                    [t, y]=simulateHasty(params, T+tau, tau, omega);
                else
                    [t, y]=simulateGillespie(params, T, omega);
                end
                
                gfp_all=[y(:,params.gfp_node)];
                
                %Compute return time
                thres_cutoff=1000;
                y_binary=zeros(1,length(y(:,params.gfp_node)));
                y_binary(y(:,params.gfp_node)>cutoff)=1;
                switches=find(diff(y_binary)==1);
                
                filtered_switches=switches;
                
                prev_switch=1;
                val_switches=[];
                for j=1:length(filtered_switches)
                    
                    this_switch=t(filtered_switches(j));
                    mean_y=mean(y(prev_switch:filtered_switches(j),params.gfp_node));
                    if mean_y>cutoff  %down
                        val_switches=[val_switches, 1];
                    else
                        val_switches=[val_switches, 0];
                    end
                    prev_switch=filtered_switches(j);
                end
                
        end
        
        for j=1:length(filtered_switches)-1
            if length(filtered_switches)>1
                return_times=[return_times (t(filtered_switches(j+1))-t(filtered_switches(j)))];
                return_omegas=[return_omegas, omega];
                %disp(['n:',num2str(n),'(',num2str(j),')     tau:',num2str(tau),'         omega:',num2str(omega),'     return_time:',num2str(return_times(end))])
            end
        end
        
        %FIND ESCAPE TIMES 
        escape_from_off=find(y(:,params.gfp_node)>cutoff);
        if ~isempty(escape_from_off)
            this_escape_time=(t(escape_from_off(1)));
            escape_times=[escape_times, this_escape_time];
            escape_omegas=[escape_omegas, omega];
            %disp([num2str(n),': this_escape_time=',num2str(this_escape_time)]);
         end
        
        if SAVE_RUNS==1
            hfig=figure(); clf('reset');  set(gcf,'DefaultLineLineWidth',2); set(gcf, 'color', 'white');
            plotState(t, y); hold on
            xlim([0,t(end)])
            for j=1:length(filtered_switches)-1
                if length(filtered_switches)>1
                    plot([t(filtered_switches(j)) t(filtered_switches(j))], [21 22],'r-'); hold on;
                    %plot([t(filtered_switches(j)), t(filtered_switches(j+1))], [cutoff, cutoff],'-','LineWidth',10,'Color',[rand rand rand]);
                else
                    plot([t(filtered_switches) t(filtered_switches)], [21 22],'r-'); hold on;
                end
            end
            set(gcf,'units','normalized');
            window_size=get(gcf, 'position');
            set(gcf,'Position',[0.2    0.1000    2.5*window_size(3), window_size(4)])
            eval(['export_fig ',dirName_runs,'run',num2str(n),'_tau',num2str(tau),'_omega',num2str(omega),'.pdf']);
            close();
        end
        
    end
    
    if SAVE_DATA==1
        dataFileEscape=[dirName_data,'return_times_omega',num2str(omega),'.mat'];
        save(dataFileEscape,'return_times','return_omegas','N','tau','T','params');
    end
    
    ureturn_omegas=sort(unique(return_omegas),'descend');
    this_omega=ureturn_omegas(1);
    iomega=find(return_omegas==this_omega);
    
    %PLOT Return time distributions and perform Anderson-Darling test
    if ~isempty(return_omegas)
        plotReturnTimeDist(return_times(iomega));
        if SAVE_PLOTS==1
            eval(['export_fig ',dirName,'dist_return_tau',num2str(tau),'_omega',num2str(omega),'.pdf']);
        end
    end
    
    if ~isempty(escape_omegas)  % Figure 4B
        plotEscapeTimeDist(return_times(iomega));
        if SAVE_PLOTS==1
            eval(['export_fig ',dirName,'dist_escape_tau',num2str(tau),'_omega',num2str(omega),'.pdf']);
        end
    end
    
end


%% ESCAPE TIME DISTRIBUTION (Figure S5)

uescape_omegas=sort(unique(escape_omegas),'descend');
noise_intensity=round(1000./uescape_omegas)/1000;
num_omegas=length(uescape_omegas);

if num_omegas>1
    wbar=.05;
    figure(); clf('reset');  set(gcf,'DefaultLineLineWidth',2); set(gcf, 'color', 'white');

    for r=1:num_omegas

        meanEscapeTmes=mean(escape_times(escape_omegas==uescape_omegas(r)));
        steEscapeTmes=std(escape_times(escape_omegas==uescape_omegas(r)));
        plot(r, meanEscapeTmes,'ok','MarkerFaceColor','k','MarkerSize',8); hold on;
        plot([r r], [meanEscapeTmes-steEscapeTmes,meanEscapeTmes+steEscapeTmes],'-k'); hold on;
        plot([r-wbar r+wbar], [meanEscapeTmes+steEscapeTmes,meanEscapeTmes+steEscapeTmes],'-k'); hold on;
        plot([r-wbar r+wbar], [meanEscapeTmes-steEscapeTmes,meanEscapeTmes-steEscapeTmes],'-k'); hold on;

    end
    xlim([0.5 length(uescape_omegas)+.5]);
    xticks(1:length(uescape_omegas));
    xticklabels(noise_intensity);
    set(gca,'fontsize',14);
    xlabel('Noise intensity (\Omega)','fontsize',18);

    ylabel('fliC-OFF escape time','fontsize',18);

    if SAVE_PLOTS==1
        eval(['export_fig ',dirName,'dist_escape_tau_vs_omega.pdf']);
    end
end

%% PLOT HISTOGRAM OF EXPRESSION

    minGFP=min(gfp_all);
    maxGFP=max(gfp_all);

    N=40;
    e=linspace(minGFP, maxGFP, N);

    figure(); clf('reset');  set(gcf,'DefaultLineLineWidth',2); set(gcf, 'color', 'white');

    setColors;
    [n1, ~] = histc(gfp_all, e);
    n1=n1./sum(n1); %FREQUENCIES
    b1=bar(e,n1,'FaceColor',blue,'LineStyle','none', 'BarWidth', 0.9); hold on;
    xlabel('FliAZ','FontSize',18);
    set(gca,'fontsize',14); 
    ylabel('Frequency','FontSize',18);
    axis([0.7*minGFP 1.1*maxGFP 0.9*min(n1) 1.1*max(n1)]);