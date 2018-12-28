

if ~exist('T','var')
    T=1;
    params=defineParams();
end

[time, solution, sold]=simulateODE(params, T);

figure(1); clf('reset'); set(gca,'fontsize',14); set(gcf,'DefaultLineLineWidth',2); set(gcf, 'color', 'white'); 
plotState(time, solution);
title('Deterministic (no delay)');


%%
%{
% PLOT PHASE PLANE
figure(4); clf('reset'); set(gca,'fontsize',14); set(gcf,'DefaultLineLineWidth',2); set(gcf, 'color', 'white'); 
plotPhase(solution);
%}
%%
%{
% PLOT PERIOD
figure(5); clf('reset'); set(gca,'fontsize',16); set(gcf,'DefaultLineLineWidth',2); set(gcf, 'color', 'white'); 
subplot(2,1,1)

[vpeaks, ipeaks]=findpeaks(solution(:,1));
period=time(ipeaks(2:end)-ipeaks(1:end-1));
plot(1:length(period), period, 'k.');
xlabel('# Cycle','fontsize',16);
ylabel('Period','fontsize',16);
axis([0 length(period) 0 1.1*max(period)]);

% PLOT AMPLITUDE
subplot(2,1,2)
plot(1:length(vpeaks), vpeaks, 'k.');
xlabel('# Cycle','fontsize',16);
ylabel('Amplitude','fontsize',16);
axis([0 length(vpeaks) 0 max(vpeaks)]);
%}

