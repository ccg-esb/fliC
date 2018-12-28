function [t, A]=simulateGillespie(params, T, omega)

    A0=params.inState;


    % Gillespie SSA
    % =============
    % (a) generate two randon numbers r1 and r2 uniformly distributed in (0,1)
    % (b) Compute w0 = \sum_{i=1}^numReactions w_i(t),
    %     where w_i(t) = propensity function of i-th reaction
    % (c) The next reaction take place at time t+tau, where
    %     tau = 1/w0 * log(1/r1)   ... natural logrithm
    % (d) Determine which reaction occurs. Find j such that
    %     r2 >= 1/w0 \sum_{i=1}^{j-1} w_i(t)
    %     r2 <  1/w0 \sum_{i=1}^j     w_i(t)
    %     Update the number of reactants and products of the j-th reaction
    % GO TO (a) with t = t + tau
    
    numNodes = size(A0,1);

    
    k=1/omega;
    
    numSteps = 1000;
    A = zeros(numNodes,numSteps);
    t = zeros(1,numSteps);
    

    % set the initial values
    m = 1;
    A(:,1) = A0;
    t(1) = 0;

    % Gillespie SSA
    h=waitbar(0,'Waiting for stochastic simulation...');%
    while (t(m) <= T)
        waitbar(t(m)/T)
        
      %******* (a)

      r = rand(1,2); % 1-by-2 vector of two random numbers
      %******* (b)

      [w, M]=fGillespie(params, A(:,m), omega);
      w0 = sum(w);

      w0_1 = 1/w0;

      %******* (c)
      tau = w0_1 * log(1/r(1));

      %******(d)
      i = 1;
      sumw = w0_1*w(1);  % == 1/w0 \sum_{i=1}^{j} w_i(t)
      while (r(2) >= sumw)
        i = i + 1;
        sumw = sumw + w0_1*w(i);
      end % while
%{
    if i==5
        M(i,:)
        A(:,m-1)
    end
%}
      % i-th reaction occurs
      %fprintf('m=%d A(m)=%d t(m)=%f i=%d\n',m,A(1,m),t(m),i);
      %disp(['Reaction ',num2str(i),' t=',num2str(t(m)) ]);
      %A(:,m)
      %M(i,:)
      A(:,m+1) = A(:,m) + k*M(i,:)';
      %A(:,m+1)
      t(m+1) = t(m) + tau;

      %fprintf(' t(m+1)=%f A(m+1)=%d  w=[%g,%g,%g,%g]\n',t(m+1),A(1,m+1),w(1),w(2),w(3),w(4));


      m = m + 1;

      % memory management
      if (m >= numSteps)
        %disp(['Doubling memory for data. (Reallocation.)  t(',num2str(m),')=',num2str(t(m))]);
        %tic
        Aaux = zeros(numNodes,2*numSteps);
        taux = zeros(1,2*numSteps);
        Aaux(:,1:numSteps) = A;
        taux(1:numSteps) = t;
        A = Aaux;
        t = taux;
        clear Aaux taux;
        numSteps = 2*numSteps;
        %fprintf('  done. [%fsec]\n', toc);
      end
    end % while

    close(h) % Close waitbar ***
    
    % cutting the zeros at the end of arrays
    A = A(:,1:m);
    t = t(1:m);

    % postprocessing
    if (t(m) > T)
      t(m) = T;
    end
    for j=1:numNodes
      if (A(j,m) < 0)
        A(j,m) = 0;
      end
    end
    A=A';



