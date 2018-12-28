
%clc
clear all
%close all;

run('lib/addpath_recurse');
addpath_recurse('src/');
addpath_recurse('lib/');


T=50;

SAVE_PLOTS=0;

%%
figure(30);
clf('reset'); set(gca,'fontsize',14); set(gcf,'DefaultLineLineWidth',2); set(gcf, 'color', 'white'); 

alphaVs=linspace(16,18,1e2);
Xs=1e4;

xtol=1e-8;

for i=1:length(alphaVs)

    params=defineParams;
    x0=params.inState;

    for k=1:Xs
        xmax=40;
        x0=[xmax*rand,    xmax*rand,    xmax*rand,    xmax*rand,    xmax*rand,    xmax*rand];

        params.alphaV=alphaVs(i);
        params.inState=x0;
        [x,fval,exitflag] = fminsearch(@(x) f(x,params),x0,optimset('MaxFunEvals', 1e8, 'TolX',xtol,'Display','off'));
        if exitflag~=0 && fval<xtol
            disp(['x0(3)=',num2str(x0(3)),':  alphaV=',num2str(alphaVs(i)),' fliAZ=',num2str(x(1)),' ',num2str(fval),' ',num2str(exitflag)]);
        
            plot(alphaVs(i), x(1),'k.'); hold on;
            axis([0 25 -.5 18]);
            xlabel('\alpha_V');
            ylabel('FliAZ');
            drawnow
        end

    end

end
