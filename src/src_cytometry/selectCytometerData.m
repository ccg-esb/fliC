function [indx, node]=selectCytometerData(fileName)



    
    M=importdata(fileName);
    FSC=M.data(:,1);
    SSC=M.data(:,2);
    FL1=M.data(:,3);
    FL3=M.data(:,4);
    FL4=M.data(:,5);
    indx=1:length(FSC);
    
    %{
    %USER-SELECTED
        figure(3); clf('reset'); set(3,'color','white'); set(gca,'fontsize',12); set(gcf,'DefaultLineLineWidth',1)
    
        %scatter(FSC, SSC,1,'k'); hold on;
    
    
        xlabel('FSC');
        ylabel('SSC');
        axis tight
        
        p=[FSC SSC];
        scatter(p(:,1),p(:,2),1,'k'); hold on;
        
        numPoints=4;
        [x,y] = ginput(numPoints);
        node=[x y];
        n      = size(node,1);
        cnect  = [(1:n-1)' (2:n)'; n 1];
        %in = inpolygon(FSC,SSC,node(:,1),node(:,2));
        
        in = inpoly(p,node,cnect); 

        scatter(p(in,1),p(in,2),1,'r'), 
        title('Inside points (blue) & outside points (red)')

        % Plot geometry
        %patch('faces',cnect,'vertices',node,'facecolor','none','edgecolor','k'), axis equal


    end
    %}
    

    %{
    %USING THE CONTOUR
    data(:,1)=FSC;
    data(:,2)=SSC;
    
    figure(3); clf('reset'); set(3,'color','white'); set(gca,'fontsize',12); set(gcf,'DefaultLineLineWidth',1)
    scatter(data(:,1),data(:,2),1,'k'); hold on;
    
    if nargin<2
        thres=0.9;
        ex=linspace(min(FSC),max(FSC),100);
        ey=linspace(min(SSC),max(SSC),100);
        count=hist2d(data,ex,ey);
        count=count/max(max(count));
        node=contourc(ex(1:end-1),ey(1:end-1),count,[thres thres]);
        contour(ex(2:end),ey(2:end),count,'r');
    end
    
    n= size(node',1);
    cnect  = [(1:n-1)' (2:n)'; n 1];
    in = inpoly(data,node',cnect); 
    indx=find(in>0);
    
    numCells=length(indx);
    scatter(data(in,1),data(in,2),1,'y');
    
    str_file=fileName(strfind(fileName,'/')+1:strfind(fileName,'.txt')-1);
    str_file = strrep(str_file, '_', '-');
    title([str_file,' (',num2str(numCells),' cells)']);
    xlabel('FSC');
    ylabel('SSC')
    eval(['export_fig Figures/FSC_SSC_',str_file,'.png']);
    
    %}
    
    
    %AROUND A POINT
    
    node=[];
    
    thres=2250;
    numCells=2500;
    b=thres.*ones(size([FSC SSC]));
    dist=sqrt((FSC(:)-b(:,1)).^2+(SSC(:)-b(:,2)).^2);
    [X i]=sort(dist);
    indx=(i(1:numCells));
    
    %{
    figure(3); clf('reset'); set(3,'color','white'); set(gca,'fontsize',12); set(gcf,'DefaultLineLineWidth',1)
    scatter(FSC,SSC,1,'k'); hold on;
    str_file=fileName(strfind(fileName,'/')+1:strfind(fileName,'.txt')-1);
    str_file = strrep(str_file, '_', '-');
    title([str_file,' (',num2str(numCells),' cells)']);
    scatter(FSC(indx),SSC(indx),1,'y');
    xlabel('FSC');
    ylabel('SSC')
    eval(['export_fig Figures/_FSC_SSC_',str_file,'.png']);
    
    figure(1)
    %}
   
    
   
    