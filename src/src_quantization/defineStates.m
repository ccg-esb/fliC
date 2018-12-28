function states=defineStates(gfps, n)


    %pks=gfps;
    pks=[findpeaks(gfps) -1*findpeaks(-1*gfps)];
    

    %Histogram
    dist=3;
    e=0.9*min(pks):dist:1.1*max(pks);
    figure(7); 
    clf('reset');
    set(7,'color','white'); set(gca,'fontsize',12); set(gcf,'DefaultLineLineWidth',1)

    [n1, xout1] = histc(pks, e);
    mn1=max(n1);
    n1=n1./mn1; %FREQUENCIES
    plot(e,n1,'ko'); hold on;
    xlabel('GFP fluorescence');
    ylabel('Frequency');
    title('Local maxima/minima');
    axis([0.9*e(1) 1.1*e(end) 0 1.1*max(n1)]);
    %}
    %Filter distribution

    [X, f, y, y2] = fftf(e, n1, [], 18);
    %X=n1;

    %plot peaks
    plot(e,X,'k--','LineWidth',1);
    [mpks, xpks]=findpeaks(X);
    
    n=min([n length(xpks)]);
    
    states=e(xpks);
    
    [mmpks impks]=sort(mpks,'descend');
    states=e(xpks(impks));
    states=states(1:n);
    for s=1:n
        plot([e(xpks(impks(s))) e(xpks(impks(s)))], [0 mpks(impks(s))], 'LineWidth',2,'Color','k');
    end
    states=sort(states);
    disp(['states: ',num2str(states)])
    

