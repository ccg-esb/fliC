function [time, solution]=simulateDelay(params)
    if params.tau>0
        lag=ones(1,6);
        
        %History
        sol = ode23(@(t,x)fhistory(t,x,params),[0 params.tau],params.inState);
        history = @(t) deval(sol, t);
   
        %Solve DDE
        options = ddeset('RelTol',1e-6);
        sold = dde23(@fZds,lag,history,[params.tau, params.T], options);
        time=sold.x';
        solution=sold.y';
    else
        [time, solution] = ode15s(@(t,x)fZ(t,x,params),[0 params.T],params.inState);
    end
    

end