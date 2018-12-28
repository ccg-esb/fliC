function [time,trajectorys] = ManyTrajectorys(parameters,sims)
%X(j) = X(j-1) + f(X(j-1))Dt + g(X(j-1))(W(j)-W(j-1))

    if nargin == 1
        sims = 100;
    end
    
    ic = parameters.ic;
    sig = parameters.sig;
    T = parameters.T;
    N = parameters.N;
    
    dt = T/N;
    dW = sqrt(dt)*randn(N,sims);
    %W = cumsum(dW);
    
    Xsolution = zeros(length(ic),N+1,sims);
    IC = repmat(ic,1,sims);
    Xtemp = IC;
    Xsolution(:,1,:) = IC;
    for j = 1:N
        Winc = dW(j,1:sims);
        [f,g] = fg(Xtemp,parameters);
        Xtemp = Xtemp + dt*f + sig*repmat(Winc,2,1).*g;
        Xsolution(:,j+1,1:sims) = Xtemp;
    end
    
    trajectorys = Xsolution;
    time = (0:dt:T);

    function [fout,gout] = fg(X,parameters)

        x = X(1,:);
        y = X(2,:);
        
        Wp = F(x,parameters);

        f1 = y;
        f2 = -parameters.dissipation*y-Wp;

        g1 = zeros(size(x));
        g2 = ones(size(x));

        gout = [g1 ; g2];
        fout = [f1 ; f2];
	end

    
end