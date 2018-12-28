clc;
clear all;
close all;

run('lib/addpath_recurse');
addpath_recurse('src/');
addpath_recurse('lib/');

setColors;

%% LOAD DATA

temperatures=[29, 31, 33, 35, 37];
for c=1:length(temperatures)
    DATA{c}=loadDataTemperatures(temperatures(c));
end


%%
maxGFP=248.0;
minGFP=9.375;
meanGFP=51.43;  %From all cells

%% FIT RETURN TIME DISTRIBUTION OF ALL CELLS  


cells={};
for c=1:length(temperatures)
    
    this_cells=DATA{c};
    
    for i=1:length(this_cells)
        cells{length(cells)+1}=this_cells{i};
    end
end

   
figure();clf('reset');  set(gcf,'DefaultLineLineWidth',2); set(gcf, 'color', 'white');
set(gcf,'units','normalized','position',[.1 .1 .3 .4])
[centers, nelements, ylogn, yexp]=fitReturnTime(1,cells, meanGFP);
%export_fig(['figures/figure3D.pdf'])


