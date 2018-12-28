function xq=quantizeTimeSeries(gfps,ff_gfps, thres)

    
    %Find peaks in signal
    [maxpks, imaxpks]=findpeaks(ff_gfps);
    [minpks, iminpks]=findpeaks(-1*ff_gfps);
    minpks=-1*minpks;
    
    %Include first and last point as min/max
    if minpks(1)>maxpks(1)
       maxpks=[gfps(1) maxpks]; 
       imaxpks=[1 imaxpks];
    else
       minpks=[gfps(1) minpks];
       iminpks=[1 iminpks];
    end
    
    if minpks(end)<maxpks(end)
       maxpks=[maxpks gfps(end)]; 
       imaxpks=[imaxpks length(gfps)];
    else
        minpks=[minpks gfps(end)];
        iminpks=[iminpks length(gfps)];
    end
    
    %find closest min and max
    xq=zeros(length(gfps),1);
    for i=1:length(gfps)
        [dist_min, this_imin]=min(abs(i-iminpks));
        [dist_max, this_imax]=min(abs(i-imaxpks));
        
        if(dist_min>dist_max)
            this_pk=maxpks(this_imax);
        else
            this_pk=minpks(this_imin);
        end
        
        %Assign state value
        [~,index]=min(abs(this_pk-thres));
        xq(i)=thres(index);
        
    end
    

    %Clean signal
    w=4;
    for i=w:length(xq)-w
        if xq(i)==xq(i+w)
            xq(i:i+w)=xq(i+w);
        end
    end
    
    
    

    