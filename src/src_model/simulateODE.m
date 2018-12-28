function [time solution sold]=simulateODE(params, T)

        sold = ode15s(@(t,x)fZ(t,x,params),[0 T],params.inState);
        time=sold.x';
        solution=sold.y';
    
end