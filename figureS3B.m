clc
clear all
close all

numStates=7;  %num_states

%% LOAD DATA (from SCCP)

M=zeros([numStates,numStates]);

M(1,1)=0.9773;   
M(1,2)=0.01193;  
M(1,3)=0.005114;  
M(1,4)=0.002652;  
M(1,5)=0.002273;  
M(1,6)=0.0007576;  

M(2,1)=0.03293;  
M(2,2)=0.9179;   
M(2,3)=0.02783;  
M(2,4)=0.01623;  
M(2,5)=0.002319;  
M(2,6)=0.001855;  
M(2,7)=0.0009276;  

M(3,1)=0.01377;  
M(3,2)=0.04075;  
M(3,3)=0.9086;   
M(3,4)=0.01982;  
M(3,5)=0.01156;  
M(3,6)=0.004405;  
M(3,7)=0.001101;  

M(4,1)=0.01054;  
M(4,2)=0.02458;  
M(4,3)=0.04039;  
M(4,4)=0.9043;   
M(4,5)=0.01405;  
M(4,6)=0.005268;  
M(4,7)=0.000878;  

M(5,1)=0.01034;  
M(5,2)=0.01034;  
M(5,3)=0.03545; 
M(5,4)=0.02954;  
M(5,5)=0.8996;   
M(5,6)=0.01329;  
M(5,7)=0.001477;  

M(6,1)=0.009615;  
M(6,2)=0.01603;  
M(6,3)=0.01603;  
M(6,4)=0.01603;  
M(6,5)=0.03846;  
M(6,6)=0.9006;   
M(6,7)=0.003205;

M(7,1)=0.01042;  
M(7,3)=0.04167;  
M(7,5)=0.02083;  
M(7,7)=0.9271;

alphabet={'A','B','C','D','E','F','G'};

%% HEATMAP

figure();
clf('reset')
set(gca,'fontsize',12)   
set(gcf,'DefaultLineLineWidth',1)
set(gcf, 'color', 'white'); 


imagesc(rot90(log10(M)));
colormap(flipud(copper));
axis equal;
axis tight;
ylabel('State (t)','FontSize',18);
xlabel('State (t+1)','FontSize',18);
xticklabels(alphabet);
yticklabels(fliplr(alphabet));
colorbar
title('Transition probabilities (log10)','FontSize',18);
set(gca,'fontsize',16);
export_fig 'figures/markov/SCCP_heatmap.pdf' 


