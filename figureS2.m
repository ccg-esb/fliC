clc
clear all

run('lib/addpath_recurse');
addpath_recurse('src/');
addpath_recurse('lib/');

%%
setColors;


dirName='data/flow_cytometer/20120216_txt';

thres=0.15;
N=75;

controlNames={'m556_1.txt','m556_2.txt','m556_3.txt'};

%CONTROL
[indx1_control, node]=selectCytometerData([dirName,'/',controlNames{1}]);
disp([controlNames{1},': ',num2str(length(indx1_control)),' cells']);
[e1_control, n1_control]=binCytometerData([dirName,'/',controlNames{1}], indx1_control, N);

indx2_control=selectCytometerData([dirName,'/',controlNames{2}]);
disp([controlNames{2},': ',num2str(length(indx2_control)),' cells']);
[e2_control, n2_control]=binCytometerData([dirName,'/',controlNames{2}], indx2_control, N);

indx3_control=selectCytometerData([dirName,'/',controlNames{3}]);
disp([controlNames{3},': ',num2str(length(indx3_control)),' cells']);
[e3_control, n3_control]=binCytometerData([dirName,'/',controlNames{3}], indx3_control, N);

e_control{1}=[e1_control; e2_control; e3_control];
n_control{1}=[n1_control'; n2_control'; n3_control'];
indx_control{1}=[indx1_control; indx2_control; indx3_control];


    
r=1;
    fileName1='flic_26C_1.txt';
    indx1_temp=selectCytometerData([dirName,'/',fileName1]);
    disp([fileName1,': ',num2str(length(indx1_temp)),' cells']);
    [e1_temp, n1_temp]=binCytometerData([dirName,'/',fileName1], indx1_temp, N);
    
    fileName2='flic_26C_2.txt';
    indx2_temp=selectCytometerData([dirName,'/',fileName2]);
    disp([fileName2,': ',num2str(length(indx2_temp)),' cells']);
    [e2_temp, n2_temp]=binCytometerData([dirName,'/',fileName2], indx2_temp, N);
    
    fileName3='flic_26C_3.txt';
    indx3_temp=selectCytometerData([dirName,'/',fileName3]);
    disp([fileName3,': ',num2str(length(indx3_temp)),' cells']);
    [e3_temp, n3_temp]=binCytometerData([dirName,'/',fileName3], indx3_temp, N);
    
    e_temp{r}=[e1_temp; e2_temp; e3_temp];
    n_temp{r}=[n1_temp'; n2_temp'; n3_temp'];
    indx_temp{r}=[indx1_temp; indx2_temp; indx3_temp];

    %save('CytometerData/26C.mat','e_temp','n_temp','indx_temp','e_control','n_control','indx_control');

%% NOW PLOT
N=100;
%load(['CytometerData/temp_',num2str(N),'.mat']);

indx=[];
figure(1); clf('reset'); set(1,'color','white');  set(gcf,'DefaultLineLineWidth',1)
r=1;
    s_control=smooth(n_control{1}(3,:));    
    
    area(e_temp{r}(1,:), smooth(n_temp{r}(1,:)), 'FaceColor',light_green); hold on; 
    area(e_temp{r}(2,:), smooth(n_temp{r}(2,:)), 'FaceColor',light_green); hold on; 
    area(e_temp{r}(3,:), smooth(n_temp{r}(3,:)), 'FaceColor',light_green); hold on; 
    
    
    plot(e_temp{r}(1,:), smooth(n_temp{r}(1,:)), 'Color',dark_green,'LineStyle','-','LineWidth',2); hold on;
    plot(e_temp{r}(2,:), smooth(n_temp{r}(2,:)), 'Color',dark_green,'LineStyle','-','LineWidth',2); hold on;
    plot(e_temp{r}(3,:), smooth(n_temp{r}(3,:)), 'Color',dark_green,'LineStyle','-','LineWidth',2); hold on;
    
    
    plot(e_control{1}(1,:), mean(n_control{1}(:,:)), 'Color','k','LineStyle','-','LineWidth',4); hold on;
 
    set(gca,'fontsize',14);
    xlabel('Fluorescence Intensity (a.u.)','FontSize',18);
    axis([0.5e3 0.4e4 0 1])
    set(gca,'XTick',1e3:1e3:4e3,'FontSize',14)
    
    if r>1
       set(gca,'YTick',[]) ;
    else
        ylabel('Frequency','FontSize',16);
    end
%eval(['export_fig figures/figureS2.pdf']);
