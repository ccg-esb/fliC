%PARAMETERS VALUES USED IN SIMULATIONS
function params=defineParams

    params.tau=0;  %Delay

    %%%%%%%%%%
    
    AZ0=2.0;
    rAZ0=1.1;
    
    V0=11.0; %FliC-OFF
    %V0=8.0; %FliC-ON
    rV0=1.1;
    
    DC0=2.0;
    rDC0=1.1;
    
    
    params.inState = [AZ0; rAZ0; V0; rV0; DC0; rDC0];  %Initial condition
    
    %%%%%%%%%%%%%%%
    %params.nodes=[1,3,5];
    %params.name_nodes={'FliAZ','YdiV','FlhDC'};
    
    params.nodes=[1:6];
    params.name_nodes={'FliAZ','rFliAZ','YdiV','rYdiV','FlhDC','rFlhDC'};
    params.styles={'k-','k--','c-','c--','b-','b--'};
    
    params.gfp_node=1;
    
    %%%%%%%%%%
    
    params.m0=0;

	%Maximal transcription rate
    params.maz=81e-2;
    params.mv=80e-2;
    params.mdc=84e-2;
    
    %RNA degradation rates
    params.gammaAZ=1e-1;
    params.gammaV=3e-1;
    params.gammaDC=4e-1;
    
    %expresion threshold
    params.thetaDC=1.1e0;
    params.thetaAZ=1.2e0;
    
    %Protein degradation rates
    params.deltaAZ=6e-1;
    params.deltaV=3e-1;
    params.deltaDC=4e-1;
    
    params.kAZ=1.2;
    params.kV=0.9;
    params.kDC=1.4;
    
    params.alphaAZ=2e-2;
    params.alphaV=2.5e0;
    
    params.nh=2;
    