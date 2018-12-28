function thisdk=getRetTimes(gfps, meanGFP, minGFP, maxGFP, sigma)


    if(nargin<3)
       meanGFP=mean(gfps);
       minGFP=min(gfps);
       maxGFP=max(gfps);
       sigma=0.5;
    end

    
    gfps=gfps-sigma*meanGFP;
    gfps=smoothn(gfps);
    
    %find switches
    Z = (gfps(1:end-1).*gfps(2:end));
    switches = find(Z < 0);

    thisdk = (diff(switches));
    
    
     