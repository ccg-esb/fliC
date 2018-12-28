clc
clear all


run('lib/addpath_recurse');
addpath_recurse('src/');
addpath_recurse('lib/');

%% LOAD DATA

this_movie='001';
this_cell=8;
fileName=['data/raw/001_cell',num2str(this_cell),'.txt'];

data=importDataTree(fileName);

[maxGFP,indexMaxGFP] = max([data{:,3}]);
[minGFP,indexMinGFP] = min([data{:,3}]);
numCells=size(data,1);
frame2min=5;
numFrames=140;

%ColorSet=varycolor(numCells);
%ColorSet=ColorSet(randperm(length(ColorSet)),:);
[ColorSet,~, ~] = brewermap(numCells,'Set2');

%% PLOT INTENSITIES


figure(1); clf('reset'); set(1,'color','white');  set(gcf,'DefaultLineLineWidth',2);
set(gcf,'Units','Pixels','Position',[1000 918 1800 420])

%Plot GFP expression time-series
for index = 1:numCells
    gfps=data{index, 3};
    times=(data{index, 2}-1);
    if index>1
        str_cell{index}=['Cell ',num2str(this_cell),'-',num2str(index-1)];
    else
        str_cell{index}=['Cell ',num2str(this_cell),' (mother)'];
    end
    if index==1
       this_color='k'; 
       this_lw=3;
    else
       this_color=ColorSet(index,:);
       this_lw=2;
    end
   plot(frame2min*times, gfps, '-', 'LineWidth', this_lw, 'Color', this_color,'MarkerFaceColor', this_color); hold on;
end

set(gca,'fontsize',16);
axis([0 frame2min*numFrames 0 maxGFP+30]);
xlabel('Time (minutes)','FontSize',18);
ylabel('Mean GFP (a.u.)','FontSize',18);

%columnlegend(7,str_cell,'South');


%Annotate division events
for index = 1:numCells
    gfps=data{index, 3};
    times=(data{index, 2}-1);
    index_mother=data{index,10};
    if index_mother>0
        gfps_mother=data{index_mother, 3};
        this_color=ColorSet(index,:);
        plot([frame2min*(times(1)-1)], [gfps_mother(times(1))],'o','LineWidth', this_lw, 'Color', this_color,'MarkerFaceColor', this_color,'MarkerSize',11); hold on;
        plot([frame2min*(times(1)-1) frame2min*times(1)], [gfps_mother(times(1)) gfps(1)],'-','LineWidth', this_lw, 'Color', this_color,'MarkerFaceColor', this_color,'MarkerSize',11);
    end        
end


%eval(['export_fig figures/figure2B.pdf']);




%% PLOT MOTHER-DAUGHTER CORRELATION INTENSITY

figure(2); clf('reset'); set(2,'color','white');  set(gcf,'DefaultLineLineWidth',2);

xi=[];
yi=[];
for index = 1:numCells
    gfps=data{index, 3};
    times=(data{index, 2}-1);
    plot([0 maxGFP], [0 maxGFP],':k','LineWidth',1);
    
    %Mother
    index_mother=data{index,10};
    if index_mother>0
        gfps_mother=data{index_mother, 3};
        xi=[xi gfps(1)];
        %times(1)+1
        yi=[yi gfps_mother(times(1)+1)];
        
        %plot([gfps(1) ], [gfps_mother(times(1)+1)],'o','LineWidth', 3, 'Color', 'k'); hold on;
    end        
    
end

p = polyfit(xi,yi,1); 
maxxi=max(xi);
minxi=min(xi);
ri = p(1) .* xi + p(2); % compute a new vector r that has matching datapoints in x
r = p(1) .* [minxi maxxi] + p(2); % compute a new vector r that has matching datapoints in x
plot([minxi maxxi],r,'k--','LineWidth',1); hold on;

for index=1:length(xi)
    this_color=ColorSet(index,:);
    plot(xi(index), yi(index), 'o','LineWidth',1,'MarkerFaceColor',this_color,'MarkerEdgeColor',this_color,'MarkerSize',10);
end
rho = corrcoef(yi, ri);

%plot([0 100],[0 100],'k:','LineWidth',1); hold on;
    
maxGFP=max([max(xi) max(yi)]);
minGFP=min([min(xi) min(yi)]);

%title('GFP intensities at division');
text(0.65*maxGFP, 1.07*maxGFP,['Correlation coefficient:',num2str(rho(2,1))],'FontSize',18)
axis([0.9*minGFP 1.1*maxGFP 0.9*minGFP 1.1*maxGFP]);
ylabel('GFP intensity of mother (a.u.)','FontSize',18);
xlabel('GFP intensity of daughter (a.u.)','FontSize',18);
set(gca,'fontsize',16);

%eval(['export_fig figures/figure2C.pdf']);

