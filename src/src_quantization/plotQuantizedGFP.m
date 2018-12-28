function plotQuantizedGFP(times, gfps, ff_gfps, qgfps, states, num)

    %setColors;
    cmap=flipud(colormap(hot));
    colormap(cmap)
    
    
    minGFP = min(states);

    maxGFP=max(states);

    figure(1);
    clf('reset');  set(1,'color','white'); set(gcf,'DefaultLineLineWidth',1)
    
    subaxis(12,1,1,1,1,11);
    
    
    title(['Cell ID:',num2str(num)],'FontSize',14);
    hsig=plot(times, gfps, '.k','LineWidth',1); hold on;
    ffsig=plot(times, ff_gfps, '--k','LineWidth',1);
    qsig=plot(times, qgfps, '-k','LineWidth',2);
    
    
    set(gca, 'Ytick',floor(states))
    
    for s=1:length(states)
        plot([0 times(end)],[states(s) states(s)],':','Color',[0.7 0.7 0.7]); hold on;
    end
    plot(times, qgfps, '-k','LineWidth',2);
     
    set(gca,'fontsize',14);
    
    axis([0 times(end) minGFP-5 maxGFP+5]);
    ylabel('Mean GFP','FontSize',18);
    
    
    set(gca, 'Xtick',[]);
    
    
    cmap=flipud(colormap(hot));
    colormap(cmap)
    hcb=colorbar;
     
    set(hcb,'YTick',(states-min(states))/(max(states)-min(states)))
    alphabet={'A','B','C','D','E','F','G','H','I','J'};
    set(hcb,'YTickLabel',{alphabet{1:length(states)}},'FontSize',14)
   
     legend([hsig, ffsig, qsig],' Data','Filtered signal',' Quantized signal');
    legend boxoff 
    
    
    title(['Cell ID:',num2str(num)])

    
    %% BOXES IN BOTTOM
    w=5; %frame2min
    h=5;
    y=h;
    
    subaxis(12,1,1,12,1,1,'MR',0.192,'SpacingVert',0);
    
    %setColors;
    cmap=flipud(colormap(hot));
    colormap(cmap)
    
    
    for t=1:length(times)
        
        s=find(states==qgfps(t));
        this_color=cmap(floor((s-1)*(length(cmap)-1)/(length(states)-1))+1, :);
        area([times(t) times(t)+w], [y+h y+h],'FaceColor',this_color, 'EdgeColor',this_color); hold on;
       
    end
    
    set(gca,'fontsize',14);
    
    
    rectangle('Position',[0,y,times(end),h],'LineWidth', 1,'EdgeColor','k'); hold on;
    text(-60, 0.5*h, 'State','FontSize',14)
    axis([times(1) times(end) 0 h]);
   
    xlabel('Time (minutes)','FontSize',18);
    set(gca, 'Ytick',[]);
    
    
    %