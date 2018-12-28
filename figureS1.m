clc
clear all
close all;

run('lib/addpath_recurse');
addpath_recurse('src/');
addpath_recurse('lib/');


T=500;



%% Deterministic - fliC-ON

params=defineParams();
params.inState(3)=8;  %V0

[time, solution, ~]=simulateODE(params, T);

figure(); clf('reset'); set(gca,'fontsize',14); set(gcf,'DefaultLineLineWidth',2); set(gcf, 'color', 'white'); 
plotState(time, solution);
%eval(['export_fig figures/figureS1E.pdf']);


%% Deterministic - fliC-OFF

params=defineParams();
params.inState(3)=11;  %V0

[time, solution, ~]=simulateODE(params, T);

figure(); clf('reset'); set(gca,'fontsize',14); set(gcf,'DefaultLineLineWidth',2); set(gcf, 'color', 'white'); 
plotState(time, solution);
%eval(['export_fig figures/figureS1B.pdf']);

%% Gillespie - fliC-ON

omega=50;
params=defineParams();
params.inState(3)=8.;  %V0
nT=1e4;

[this_time, this_y]=simulateGillespie(params, nT,omega);
this_time=T*this_time/nT;

figure(); clf('reset'); set(gca,'fontsize',14); set(gcf,'DefaultLineLineWidth',2); set(gcf, 'color', 'white'); 
plotState(this_time, this_y);
%eval(['export_fig figures/figureS1F.pdf']);


%% Gillespie - fliC-OFF

omega=50;
params=defineParams();
params.inState(3)=11;  %V0
nT=1e4;

[this_time, this_y]=simulateGillespie(params, nT,omega);
this_time=T*this_time/nT;

figure(); clf('reset'); set(gca,'fontsize',14); set(gcf,'DefaultLineLineWidth',2); set(gcf, 'color', 'white'); 
plotState(this_time, this_y);
%eval(['export_fig figures/figuresS1C.pdf']);