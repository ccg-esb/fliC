function cells=loadDataTemperatures(temperature)

    dirData='data/temperature/';
    fileName=[dirData,'results_',num2str(temperature),'C_all.txt'];

    M = dlmread(fileName,',',1,0);
    pos=M(:,2);
    all_ids=M(:,4);
    all_frames=M(:,5);
    all_intensity=M(:,8);
    all_diameter=M(:,10);
    all_division=M(:,11);
    
    upos=unique(pos);
    
    cells={};
    for p=1:length(upos)
        ipos=find(pos==upos(p));
        pos_ids=all_ids(ipos);
        pos_frames=all_frames(ipos);
        pos_intensity=all_intensity(ipos);
        pos_diameter=all_diameter(ipos);
        pos_division=all_division(ipos);
        
        ucells=unique(pos_ids);
        for c=1:length(ucells)
           icells=find(pos_ids==ucells(c)); 
           
           cell_ids=pos_ids(icells);
           cell_frames=pos_frames(icells);
           cell_intensity=pos_intensity(icells);
           cell_diameter=pos_diameter(icells);
           cell_division=pos_division(icells);
           
           cell.temperature=temperature;
           cell.pos=upos(p);
           cell.id=unique(cell_ids);
           cell.frames=cell_frames;
           cell.GFP=cell_intensity;
           cell.diameter=cell_diameter;
           cell.division=cell_division;
           
           cells{length(cells)+1}=cell;
           
        end
        
    end
    