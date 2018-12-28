
function plotHistogram(gfps, numPlot, minGFP, maxGFP)

    if(nargin==2)
       minGFP=min(gfps);
       maxGFP=max(gfps);
    end
    if(nargin==1)
       numPlot=5;
    end
    
    %e=minGFP:0.02:maxGFP;
    
    N=40;
    e=linspace(minGFP, maxGFP, N);

    figure(numPlot); 
    clf('reset');
    set(numPlot,'color','white'); set(gcf,'DefaultLineLineWidth',1)
    setColors;
    [n1, ~] = histc(gfps, e);
    n1=n1./sum(n1); %FREQUENCIES
    b1=bar(e,n1,'FaceColor',light_green,'LineStyle','none', 'BarWidth', 0.9); hold on;
    xlabel('FliAZ','FontSize',18);
    set(gca,'fontsize',18); 
    ylabel('Frequency','FontSize',18);
    axis([0.7*minGFP 1.1*maxGFP 0.9*min(n1) 1.1*max(n1)]);