
function out = fwapper(y,params)

    AZ=y(1);
    rAZ=y(2);
    V=y(3);
    rV=y(4);
    DC=y(5);
    rDC=y(6);
    
    
    %mRNAs:
    drAZ=params.m0+params.maz*hillA(DC, params.thetaDC, params.nh) - params.gammaAZ*rAZ;
    drV=params.m0+params.mv*hillI(AZ, params.thetaAZ, params.nh) - params.gammaV*rV;
    drDC=params.m0+params.mdc-params.gammaDC*rDC;
    
    %Proteins:
    dAZ=params.kAZ*rAZ - params.deltaAZ*AZ;
    dV=params.kV*rV - params.deltaV*V;
    dDC=params.kDC*rDC - DC*(params.deltaDC - params.alphaAZ*AZ + params.alphaV*V);
    
    out = [dAZ; drAZ; dV; drV; dDC; drDC];
   
end

function ret=hillA(p, theta, n)
    ret=(p^n)/(p^n + theta^n);
end
function ret=hillI(p, theta, n)
    ret=(theta^n)/(p^n + theta^n);
end
