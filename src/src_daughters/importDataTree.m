function data=importDataTree(fileName)
%What about batch import?

    m=1; %tmp: movie
    
    [i, id_cell, frame, level, parent, gfp, center, diameter, division] = textread(fileName,'%f %f %f %f %f %f %f %f %f','headerlines',1);
    
    cells=unique(id_cell);
    
    data={};

    %which_cells=length(unique(id_cell));
    numRows=length(i);
    
    numCells=1;
    for c=1:length(cells)
        cell_frames=[];
        cell_gfps=[];
        cell_diameters=[];
        cell_divisions=[];
        cell_levels=[];
        cell_centers=[];
        cell_parent=0;
        
        this_cell=cells(c);
        for r=1:numRows
            
            if id_cell(r)==this_cell
                cell_frames=[cell_frames frame(r)];
                cell_gfps=[cell_gfps gfp(r)];
                cell_diameters=[cell_diameters diameter(r)];
                cell_divisions=[cell_divisions division(r)];
                cell_centers=[cell_centers center(r)];
                cell_levels=[cell_levels level(r)];
                cell_parent=parent(r);

            end
        end
        
        if length(cell_frames)>0  %if found data
            data{numCells, 1}=numCells; 
            data{numCells, 2}=cell_frames;
            data{numCells, 3}=cell_gfps;
            data{numCells, 4}=cell_diameters;
            data{numCells, 5}=cell_divisions;
            data{numCells, 6}=m;  %movie
            data{numCells, 7}=this_cell;  %id_cell
            data{numCells, 8}=cell_centers;  %center
            data{numCells, 9}=cell_levels;  %level
            data{numCells, 10}=cell_parent;  %level
            numCells=numCells+1;
        end
        

    end

