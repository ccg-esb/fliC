%
clc
clear all
close all;

run('lib/addpath_recurse');
addpath_recurse('src/');
addpath_recurse('lib/');

%% LOAD DATA  (Synthetic data generated with fliCv2017/runEscape)

load('data/escape/escape_times_omega50.mat')

%%

figure(3); clf('reset');  set(gcf,'DefaultLineLineWidth',2); set(gcf, 'color', 'white'); 
%plot(escape_omegas, escape_times,'ok');

uescape_omegas=sort(unique(escape_omegas),'descend');

noise_intensity=round(1000./uescape_omegas)/1000;

wbar=.05;
num_omegas=length(uescape_omegas);
for r=1:num_omegas
   
    meanEscapeTimes=mean(escape_times(escape_omegas==uescape_omegas(r)));
    steEscapeTimes=std(escape_times(escape_omegas==uescape_omegas(r)));
    plot(r, meanEscapeTimes,'ok','MarkerFaceColor','k','MarkerSize',8); hold on;
    plot([r r], [meanEscapeTimes-steEscapeTimes,meanEscapeTimes+steEscapeTimes],'-k'); hold on;
    plot([r-wbar r+wbar], [meanEscapeTimes+steEscapeTimes,meanEscapeTimes+steEscapeTimes],'-k'); hold on;
    plot([r-wbar r+wbar], [meanEscapeTimes-steEscapeTimes,meanEscapeTimes-steEscapeTimes],'-k'); hold on;
    
end
xlim([0.5 length(uescape_omegas)+.5]);
xticks(1:length(uescape_omegas));
xticklabels(noise_intensity);
set(gca,'fontsize',14);
xlabel('Noise intensity (\Omega)','fontsize',18);
ylabel('fliC-OFF escape time','fontsize',18);

%export_fig(['figures/escape/omega_v_escapeTimes.pdf']);