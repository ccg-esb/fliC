
function dydt = fZds(t,y,Z)

    global params

    AZlag = Z(1);
    rAZlag = Z(2);
    Vlag = Z(3);
    rVlag = Z(4);
    DClag = Z(5);
    rDClag = Z(6);
    
    AZ=y(1);
    rAZ=y(2);
    V=y(3);
    rV=y(4);
    DC=y(5);
    rDC=y(6);
    
    
    %mRNAs:
    drAZ=params.maz*hillA(DClag, params.thetaDC, params.nh) - params.gammaAZ*rAZ;
    drV=params.mv*hillI(AZlag, params.thetaAZ, params.nh) - params.gammaV*rV;
    drDC=params.mdc-params.gammaDC*rDC;
    
    %Proteins:
    dAZ=params.kAZ*rAZ - params.deltaAZ*AZ;
    dV=params.kV*rV - params.deltaV*V;
    dDC=params.kDC*rDC - DC*(params.deltaDC - params.alphaAZ*AZ + params.alphaV*V);
    
    dydt = params.tau*[dAZ 
            drAZ 
            dV  
            drV
            dDC
            drDC];
end

function ret=hillA(p, theta, n)
    ret=(p^n)/(p^n + theta^n);
end
function ret=hillI(p, theta, n)
    ret=(theta^n)/(p^n + theta^n);
end