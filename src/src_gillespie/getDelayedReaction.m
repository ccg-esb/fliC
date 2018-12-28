function [d_i, t_i, istack, tstack]=getDelayedReaction(istack, tstack, tstar)

    [tstack, I]=sort(tstack);
    istack=istack(I);

    d_i=[];
    t_i=[];
    for s=1:length(istack)
    
        if tstack(s)<=tstar
            d_i=istack(s);
            t_i=tstack(s);
            
            if s<length(istack)
                istack=istack(s+1:end);
                tstack=tstack(s+1:end);
            else
                istack=[];
                tstack=[];
            end
            
        end
        break;
    end

    