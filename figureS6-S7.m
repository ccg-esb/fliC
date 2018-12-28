
clc
clear all
close all

run('lib/addpath_recurse');
addpath_recurse('src/src_toggle/');
addpath_recurse('lib/');

%%

figure(1)
set(1,'color','white')
set(1,'position',[62         752        1713         227])

figure(2)
set(2,'color','white')
set(2,'position',[62         752        1713         227])

parameters = setParams();
simulations = 20;
temperatures = [0.1 0.5 0.6 0.7 1.2 1.5];
N = length(temperatures);

for j = 1:N
    parameters.sig = temperatures(j);    
    [time,trajectories{j}] = ManyTrajectorys(parameters,simulations);
end

%%

for j = 1:N
    figure(1)
    subplot(1,N,j);
    allPos = trajectories{j}(1,:,:);
    H = drawLocationHistogram(allPos);
    ylim([0 0.8])
    if j > 1
        ylabel('');
        ylim([0 0.25])
    end
    legend(H(1),['temp proxy ',num2str(temperatures(j))])
    
    s = (j-1)/(N-1);
    colr = [s 0.25 1-s];
    set(H(1),'FaceColor',colr);
    xlabel('state')
    
    figure(2)
	subplot(1,N,j);
    for k = 1:simulations
        plot(trajectories{j}(1,:,k),'-','linewidth',0.5);
        ylim([-2 2])
        xlim([0 1000])
        xlabel('time')
        if j == 1
            ylabel('state (x(t))')
        end
        hold on
    end
	title(['temp proxy ',num2str(temperatures(j))])

end

figure(1)
set(gcf,'position',[62         752        1713         227])
figure(2)
set(gcf,'position',[62         752        1713         227])

%%

figure(1)
export_fig('figures/FigureS6.pdf')
figure(2)
export_fig('figures/FigureS7.pdf')
