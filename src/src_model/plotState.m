function plotState(time, y, show_leg)
    params=defineParams();
    for n=1:length(params.nodes)
        if n==params.gfp_node
            plot(time, (y(:,n)), '-k','LineWidth',3); hold on;
        else
            plot(time, (y(:,n)), params.styles{n},'LineWidth',2); hold on;
        end
    end
    plot(time, (y(:,params.gfp_node)), '-k','LineWidth',3); hold on;
    axis([time(1) time(end) 0 22]);
    set(gca,'fontsize',14);
    if nargin<3 || show_leg
        legend(params.name_nodes,'Location','NorthEastOutside','FontSize',16);
    end
    xlabel('Time','FontSize',18);
    ylabel('State','FontSize',18);