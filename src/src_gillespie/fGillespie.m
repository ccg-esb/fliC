function [w, M, D]=fGillespie(params, y, omega)

    %omega=1;

    AZ=y(1);
    rAZ=y(2);
    V=y(3);
    rV=y(4);
    DC=y(5);
    rDC=y(6);
    
    params.nh=2;
   
    %Propensities of each reaction
    w(1)=params.maz*hillA(DC, params.thetaDC, params.nh,omega);
    w(2)=params.mv*hillI(AZ, params.thetaAZ, params.nh,omega);
    w(3)=params.mdc;
    w(4)=params.gammaAZ*rAZ;
    w(5)=params.gammaV*rV;
    w(6)=params.gammaDC*rDC;
    w(7)=params.kAZ*rAZ;
    w(8)=params.kV*rV;
    w(9)=params.kDC*rDC;
    w(10)=params.deltaAZ*AZ;
    w(11)=params.deltaV*V;
    w(12)=params.deltaDC*DC;
    w(13)=params.alphaAZ*AZ*DC;
    w(14)=params.alphaV*V*DC;
    
    %w=w./omega;
    
    %Matrix of stoichiometries (Nreactions x Nspecies).
    %Each row gives the stoichiometry of a reaction.
    %       Z   rZ  V   rV  DC  rDC
    M = [   0   1   0   0   0   0 ;  %1
            0   0   0   1   0   0 ;  %2
            0   0   0   0   0   1 ;  %3
            0   -1  0   0   0   0 ;  %4
            0   0   0   -1  0   0 ;  %5
            0   0   0   0   0   -1;  %6
            1   0   0   0   0   0 ;  %7
            0   0   1   0   0   0 ;  %8
            0   0   0   0   1   0 ;  %9
            -1  0   0   0   0   0 ;  %10
            0   0   -1  0   0   0 ;  %11
            0   0   0   0   -1  0 ;  %12
            0   0   0   0   1   0 ;  %13
            0   0   0   0   -1  0 ]; %14
    
    D=[1 2];  %Delayed reactions
    
end

function ret=hillA(p, theta, n,omega)
    ret=(p^n)/(p^n + theta^n);
end
function ret=hillI(p, theta, n,omega)
    ret=(theta^n)/(p^n + theta^n);
end

    