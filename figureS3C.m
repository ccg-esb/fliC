clc
clear all
close all

%%

% Simulates a MC time-series from a transition probability matrix 
% generated using CSSR (with a 7-state quantization)

M=[  
0.977271, 0.0119329, 0.00511412, 0.00265177, 0.00227294, 0.000757648, 0	;
0.0329314, 0.917904, 0.0278293, 0.0162338, 0.00231911, 0.00185529, 0.000927644;	
0.0137665, 0.0407489, 0.90859, 0.0198238, 0.0115639, 0.00440529, 0.00110132;
0.0105356, 0.024583, 0.0403863, 0.904302, 0.0140474, 0.00526778, 0.000877963;	
0.0103397, 0.0103397, 0.0354505, 0.0295421,  0.899557, 0.0132939, 0.0014771;
0.00961538, 0.0160256, 0.0160256, 0.0160256, 0.0384615, 0.900641, 0.00320513;
0.0104167, 0, 0.0416667, 0, 0.0208333, 0, 0.927083 ];  %Transition Prob Matrix


N=1e7; %Number of iterations

setColors;
%%

chain=zeros(1,N);  %here we store time-series

chain(1)=1;  %Initial condition
for i=2:N
    
    r=rand();
    this_step_distribution =M(chain(i-1),:);
    cumulative_distribution = cumsum(this_step_distribution);
    chain(i) = find(cumulative_distribution>=r,1);
    
end


%%


figure();clf('reset');  set(gcf,'DefaultLineLineWidth',2); set(gcf, 'color', 'white');
set(gcf,'units','normalized','position',[.1 .1 .3 .4])

k = [];
return_times = [];

TimeSeries = chain - mean(chain);
Z = (TimeSeries(1:end-1).*TimeSeries(2:end));
newk = find(Z < 0);
k = [k newk];
return_times = [return_times diff(newk)];

enum=40;
emin=0;
emax=max(return_times);
x_values=linspace(emin, emax, enum);

%dkplot=dk(dk<=emax);
[nelements,centers] = hist(return_times,enum);
nelements = nelements/sum(nelements);
b = bar(centers-(centers(2)-centers(1))/2,nelements,1);
set(b,'facecolor',light_green);
set(b,'EdgeColor','w');

xlabel('Return time','FontSize',18)
ylabel('Frequency','FontSize',18)

hold on

%andersonDarling(dk', x_values);

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
    %if h_lognorm<1  %We can reject the null-hypothesis with 95%CI
    %    disp(['return times are log-normally distributed (Anderson-Darling, p=',num2str(p_lognorm),')']);
    %else  %We cannot reject the null-hypothesis
    %    disp(['return times are not log-normally distributed (Anderson-Darling, p=',num2str(p_lognorm),')']);
    end
    disp('-------------');

%axis([0 max(x_values) 0 0. 25])

%legend([b l2 l3],{'Simulated Data (CSSR)','Exponential fit','Lognormal fit'},'FontSize',18);
legend('boxoff')
set(gca,'FontSize',16);

%export_fig 'figures/S3C.pdf'