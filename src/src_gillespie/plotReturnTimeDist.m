function plotReturnTimeDist(return_times)
    

    enum=100; %4e2;
    emin=0;

    %emax=10;
    emax=max(return_times);
    e=linspace(emin, emax, enum);

    %return_times=return_times(return_times<=emax);

    close all; figure(); clf('reset');  set(gcf,'DefaultLineLineWidth',2); set(gcf, 'color', 'white');
    setColors;

    [nelements,centers] = hist(return_times,e);
    nelements = nelements/sum(nelements);
    
    %plot(centers,nelements,'ko');hold on;
    %b=plot(centers(end)+(centers(end)-centers(end-1)),nelements_post,'ro');


    b = bar(centers, nelements); hold on;
    set(b,'facecolor',blue);
    set(b,'EdgeColor',blue);
    set(gca,'fontsize',14);
    xlabel('Return time','FontSize',18)
    ylabel('Frequency','FontSize',18)

    x_values=linspace(emin, emax, enum);

    %Anderson-Darling test
    opt = statset('Display','final','maxiter',5000,'maxfunevals',5000);
    obj2 = gmdistribution.fit(return_times(:),2,'options',opt);
    pd_exp = fitdist(return_times(:),'exp');
    F_exp = pd_exp.pdf(x_values); F_exp = F_exp/max(F_exp);
    l2 = plot(x_values',F_exp*max(nelements),'k--');
    set(l2,'color','k','linewidth',2);
    yexp=F_exp*max(nelements);
    [h_exp,p_exp]=adtest(return_times,'Distribution',pd_exp,'Alpha',0.0001);
    disp('-------------');
    if h_exp<1  %We can reject the null-hypothesis with 95%CI
        disp(['return times are exponentially distributed (Anderson-Darling, p=',num2str(p_exp),')']);
    else  %We cannot reject the null-hypothesis
        disp(['return times are not exponentially distributed (Anderson-Darling, p=',num2str(p_exp),')']);
    end

    pd_lognorm = fitdist(return_times(:),'lognormal');
    F_lognorm = pd_lognorm.pdf(x_values); F_lognorm = F_lognorm/max(F_lognorm);
    l3 = plot(x_values',F_lognorm*max(nelements),'-');
    set(l3,'color','k','linewidth',4);
    ylognorm=F_lognorm*max(nelements);
    [h_lognorm,p_lognorm]=adtest(return_times,'Distribution',pd_lognorm,'Alpha',0.0001);
    if h_lognorm<1  %We can reject the null-hypothesis with 95%CI
        disp(['return times are log-normally distributed (Anderson-Darling, p=',num2str(p_lognorm),')']);
    else  %We cannot reject the null-hypothesis
        disp(['return times are not log-normally distributed (Anderson-Darling, p=',num2str(p_lognorm),')']);
    end
    disp('-------------');

    legend([b l2 l3],{'Simulations','Exponential fit','Log-normal fit'});
    axis([-centers(2)/2 8 0 .3]);
    legend('boxoff')
    %title(['\tau=',num2str(tau),',  1/\omega=',num2str(this_omega)]);

    