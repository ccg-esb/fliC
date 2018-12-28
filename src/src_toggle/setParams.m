function parameters = setParams()
    
    parameters.ic = [1.01 ; 0];
    parameters.dissipation = 1;
    parameters.T = 600;
    parameters.sig = 0.5;    
    parameters.N = 2^13;
    parameters.nProcs = min(12,feature('numCores')*2);
    
    parameters.a = 0.1;
    parameters.b = 0.1;
    parameters.h = 1;
    
end