function [colours,gold,greyBlue,mixingColours,colourOrder] = myColours()

    colours = {[1 0.25 0.25],[0.5 0.75 1],[51, 82, 178]/255,[0.5 0 0]};
    gold = [254 216 93]/255;
    mixingColours = {[0 0.75 0],[0.75 0 0],0.0*[1 1 1]};
    
    colourOrder = [];
    for j = 1:length(colours)
        colourOrder = [colourOrder ; colours{j}] ; 
    end
    greyBlue = [160, 200, 230]/255;
    
end