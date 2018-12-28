
function [centers, nelements, ylognorm, yexp]=fitReturnTime(sigma, cells, meanGFP)

warning('off','all')
setColors;

frame2min=5;

n= length(cells);

dk = [];
k = [];

for j = 1:n
    TimeSeries = cells{j}.GFP';
    
    TimeSeries=smoothn(TimeSeries);
    
    TimeSeries = TimeSeries - sigma*meanGFP;
    Z = (TimeSeries(1:end-1).*TimeSeries(2:end));
    newk = find(Z < 0);
    k = [k newk];
    thisdk = (diff(newk));
    dk = [dk thisdk];
end

dk=frame2min*dk;
[nelements,centers] = hist(dk,20);
wbar=(centers(2)-centers(1));
nelements = nelements/sum(nelements);
b = bar(centers-.5*wbar,nelements);
set(b,'facecolor',[0.96863     0.96863     0.96863]);
set(b,'EdgeColor','k');
set(b,'LineWidth',1);
xlabel('Return time (minutes)','FontSize',18)
ylabel('Frequency','FontSize',18)

hold on

%x_values = 0:0.001:2.5;
%x_values = 10.^x_values;
x_values=linspace(0,frame2min*200,2500);



set(gca,'FontSize',16);
yticks(0:0.1:1)
axis([-wbar/2 frame2min*120 0 0.45]);



    %Anderson-Darling test
    dkplot=dk;
    opt = statset('Display','final','maxiter',5000,'maxfunevals',5000);
    obj2 = gmdistribution.fit(dkplot(:),2,'options',opt);
    pd_exp = fitdist(dkplot(:),'exp');
    F_exp = pd_exp.pdf(x_values); F_exp = F_exp/max(F_exp);
    l2 = plot(x_values',F_exp*max(nelements),'k--');
    set(l2,'color','k','linewidth',2);
    yexp=F_exp*max(nelements);
    [h_exp,p_exp]=adtest(dkplot,'Distribution',pd_exp,'Alpha',0.0001);
    disp('-------------');
    if h_exp<1  %We can reject the null-hypothesis with 95%CI
        disp(['return times are exponentially distributed (Anderson-Darling, p=',num2str(p_exp),')']);
    else  %We cannot reject the null-hypothesis
        disp(['return times are not exponentially distributed (Anderson-Darling, p=',num2str(p_exp),')']);
    end

    pd_lognorm = fitdist(dkplot(:),'lognormal');
    F_lognorm = pd_lognorm.pdf(x_values); F_lognorm = F_lognorm/max(F_lognorm);
    l3 = plot(x_values',F_lognorm*max(nelements),'-');
    set(l3,'color','k','linewidth',4);
    ylognorm=F_lognorm*max(nelements);
    [h_lognorm,p_lognorm]=adtest(dkplot,'Distribution',pd_lognorm,'Alpha',0.0001);
    if h_lognorm<1  %We can reject the null-hypothesis with 95%CI
        disp(['return times are log-normally distributed (Anderson-Darling, p=',num2str(p_lognorm),')']);
    else  %We cannot reject the null-hypothesis
        disp(['return times are not log-normally distributed (Anderson-Darling, p=',num2str(p_lognorm),')']);
    end
    disp('-------------');

legend([b l2 l3],{'Experimental data','Exponential fit','Lognormal fit'},'FontSize',18);
legend('boxoff')
