function plotEscapeTimeDist(return_times, return_omegas, N, tau, T, params)
    ureturn_omegas=sort(unique(return_omegas),'descend');
    this_omega=ureturn_omegas(1);
    iomega=find(return_omegas==this_omega);
    dk=return_times(iomega);

    enum=20;
    emin=0;

    %emax=20;
    emax=max(dk);

    dkplot=dk(dk<=emax);
    dkpost=dk(dk>emax);


    close all; figure(); clf('reset');  set(gcf,'DefaultLineLineWidth',2); set(gcf, 'color', 'white');
    setColors;

    e=linspace(emin, emax, enum);
    [nelements,centers] = hist(dkplot,e);
    nelements = nelements/sum(nelements);
    nelements_post=length(dkpost)/length(dk);

    %plot(centers,nelements,'ko');hold on;
    %b=plot(centers(end)+(centers(end)-centers(end-1)),nelements_post,'ro');


    b = bar([centers, centers(end)+(centers(end)-centers(end-1))],[nelements, nelements_post]);
    set(b,'facecolor',blue);
    set(b,'EdgeColor',blue);
    set(gca,'fontsize',14);
    xlabel('Escape time','FontSize',18)
    ylabel('Frequency','FontSize',18)

