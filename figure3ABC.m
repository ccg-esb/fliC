
clc
clear all
close all

run('lib/addpath_recurse');
addpath_recurse('src/');
addpath_recurse('lib/');

%% LOAD SINGLE-CELL DATA

load('data/fliC.mat')
numCells=length(data);
frame2min=5;
maxGFP = max([data{:,3}]);
minGFP = min([data{:,3}]);
meanGFP = mean([data{:,3}]);
T=data{1,2}(end);
time=data{1,2}*frame2min;


%Sort cells
mean_gfp=zeros(1,numCells);
for i = 1:numCells
    this_gfps=data{i,3};
    mean_gfp(i)=mean(this_gfps);
end
[~,iorder] = sort(mean_gfp);

num_colors=100;
[this_map,~, ~] = brewermap(num_colors,'*PuOr');
%% FIGURE 2A [HEAT MAP]

figure(1);
set(gcf,'DefaultLineLineWidth',1); set(gcf, 'color', 'white');
set(gcf,'units','normalized','Pos',[0    0    0.2    0.9])
set(gca,'fontsize',14);
   

selected_gfps=[];
for j = 1:numCells
    
    index=iorder(j);
    
    numFrames=size(data{index,2},2);
    this_gfps=smooth(data{index, 3});
    for frame=1:numFrames
        %c=cmap(floor((length(colormap)/2)+ (this_gfps(frame)-minGFP)/(maxGFP-minGFP)*(length(colormap)/2)),:);
        
        if this_gfps(frame)>meanGFP
            icolor=ceil(num_colors/2*((this_gfps(frame)-meanGFP)/(maxGFP-meanGFP))+num_colors/2);
        else
            icolor=ceil(num_colors/2*((this_gfps(frame)-meanGFP)/(meanGFP-minGFP))+num_colors/2);
        end
        if icolor<1
           icolor=1; 
        end
        
        rectangle('Position',[frame2min*frame,j,frame2min,1], 'FaceColor', this_map(icolor,:), 'EdgeColor', 'k','LineStyle','none');  hold on;
    end
    
   
    
end

axis([1 570 1 numCells]);
set(gca,'YTickLabel',{});
xlabel('Time (minutes)','FontSize',18);
ylabel('Cells','FontSize',18);
set(gcf,'Pos',[0    0    0.2    0.9])

colormap(this_map)
hc=colorbar('location','northoutside','position',[0.5176    0.9429    0.3906    0.0157]);
set(hc,'xaxisloc','bottom');
set(hc,'XTick',[0,0.5,1])
set(hc,'XTickLabel',{'Min','Mean','Max'},'FontSize',14)
title(hc,'Normalised GFP Intensity','FontSize',18)

%export_fig 'figures/figure3A.png'

%%  FIGURE 2B [PLOT SELECTED CELLS]

selected_cells=iorder(1:9:numCells);

setColors;
figure(3);
set(gcf,'DefaultLineLineWidth',1); set(gcf, 'color', 'white');
set(gcf,'units','normalized','Pos',[0    0    0.2    0.9])
set(gca,'fontsize',14);

for i=1:length(selected_cells)
   subaxis(length(selected_cells),1,length(selected_cells)-i+1,'SpacingVert',0.01); 
   gfps=data{selected_cells(i),3}-meanGFP;
   time=frame2min*data{selected_cells(i),2};
   
    %area(time, gfps, 'FaceColor', light_green, 'EdgeColor', light_green); hold on;
    for j=1:length(time)-1
        if gfps(j)>0
            icolor=ceil(num_colors/2*(gfps(j)/(maxGFP-meanGFP))+num_colors/2);
        else
            icolor=ceil(num_colors/2*(gfps(j)/(meanGFP-minGFP))+num_colors/2);
        end
        
        this_color=this_map(icolor,:);
        area([time(j) time(j+1)], [gfps(j) gfps(j+1)], 'FaceColor', this_color, 'EdgeColor', this_color); hold on;
    end
    
    
    plot(time, gfps, '-','Color',dark_green,'LineWidth',0.5);
    plot([0 time(end)], [0 0], 'k:', 'LineWidth',1);
    axis([0 570 -25 maxGFP-meanGFP]);
    
    set(gca,'Ytick',-50:25:50,'FontSize',16)
    set(gca,'YAxisLocation','Right')
    if i==1
        xlabel('Time (minutes)','FontSize',18);
        set(gca,'Xtick',0:100:700,'FontSize',16)
    else
        set(gca,'XTick',[]);
    end
    if i==6
        
        ylabel('Deviation from mean GFP (a.u.)','FontSize',18);
    end
    box off
end


%export_fig 'figures/figure3B.pdf'


%% Figure 3C: Histogram 

gfps=[];
for num=1:numCells
    gfps=[gfps log10(data{num, 3})]; %log10
end
    
    
    
    N=40;
    e=linspace(log10(minGFP), log10(maxGFP), N);
    

    figure(4); 
    clf('reset');
    set(4,'color','white'); set(gcf,'DefaultLineLineWidth',1)
    setColors;
    [n1, ~] = histc(gfps, e);
    n1=n1./sum(n1); %FREQUENCIES
    bar(e,n1,'FaceColor',[0.96863     0.96863     0.96863],'LineStyle','-','LineWidth',1.5, 'BarWidth', 1); hold on;
    %{
    de=e(2)-e(1);
    ecolor=ceil((num_colors-1)*(e - e(1))/((e(end)-e(1))))+1;
    for i=1:length(n1)
        %this_color=this_map(ecolor(i),:);
        this_color='light_green';
        bar(e(i),n1(i),'FaceColor',this_color,'LineStyle','none', 'BarWidth', 0.9*de); hold on;
    end
    %}
    xlabel('GFP intensity (log10 scale)','FontSize',12);
    set(gca,'fontsize',12); 
    ylabel('Frequency','FontSize',12);
    axis([1.15 2 0.9*min(n1) 1.1*max(n1)]);

   % export_fig 'figures/figure3C.pdf'
        

