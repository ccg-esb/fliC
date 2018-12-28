function [t, A]=simulateHasty(params, T, tau, omega)
    A0=params.inState;
    
    
    
    k=1/omega;

    
    % Gillespie SSA
    % =============
    % (a) generate two randon numbers r1 and r2 uniformly distributed in (0,1)
    % (b) Compute w0 = \sum_{i=1}^numReactions w_i(t),
    %     where w_i(t) = propensity function of i-th reaction
    % (c) The next reaction take place at time t+tstar, where
    %     tstar = 1/w0 * log(1/r1)   ... natural logrithm
    % (d) Determine which reaction occurs. Find j such that
    %     r2 >= 1/w0 \sum_{i=1}^{j-1} w_i(t)
    %     r2 <  1/w0 \sum_{i=1}^j     w_i(t)
    %     Update the number of reactants and products of the j-th reaction
    
    %       If is a delayed reaction, place in stack to take place in
    %       t=tstar+tau
    
    % DESCRIBE EXTRA-STEPS HERE!!
    
    % GO TO (a) with t = t + tstar
    
    numNodes = size(A0,1);
    numSteps = 1000;
    A = zeros(numNodes,numSteps); 
    t = zeros(1,numSteps);

    %Stack of delayed equations:
    istack=[];
    tstack=[];
    
    % set the initial values
    m = 1;
    A(:,1) = A0;
    t(1) = 0;
    

    % Gillespie SSA
    
%    h=waitbar(0,'Waiting for stochastic simulation...');%
    while (t(m) <= T)
      %  waitbar(t(m)/T)
      %******* (a)

      r = rand(1,2); % 1-by-2 vector of two random numbers
      %******* (b)
      
      %A(A(:,m)<0,:)=0;  %!!!!?
      
      [w, M, D]=fGillespie(params, A(:,m), omega);
      w0 = sum(w);

      w0_1 = 1/w0;

      %******* (c)
      tstar = w0_1 * log(1/r(1));

      %******(d)
      i = 1;
      sumw = w0_1*w(1);  % == 1/w0 \sum_{i=1}^{j} w_i(t)
      while (r(2) >= sumw)
        i = i + 1;
        sumw = sumw + w0_1*w(i);
      end % while

      
      %disp(['Reaction ',num2str(i), ' (t=',num2str(t(m)+tstar),')']);
      
      %If not delayed equation:
      if ~isempty(find(D==i, 1))==0
      
          [d_i, t_i, istack, tstack]=getDelayedReaction(istack, tstack, t(m)+tstar);
          
          %if there are no reactions meant to happen
          if isempty(d_i)
              % i-th reaction occurs (only if post-history)
              
              if t(m)>tau
                A(:,m+1) = A(:,m) + k*M(i,:)';
                t(m+1) = t(m) + tstar;
              else
                A(:,m+1) = A(:,m);
                t(m+1) = t(m) + tstar;  
              end
              
              %disp([' > Updating Reaction ',num2str(i), ' (t=',num2str(t(m)+tstar),')']);

              %fprintf(' t(m+1)=%f A(m+1)=%d  w=[%g,%g,%g,%g]\n',t(m+1),A(1,m+1),w(1),w(2),w(3),w(4));

              m = m + 1;
              
          elseif t(m)>tau  %If post-history
              
              % di-th reaction occurs (the delayed one)
              A(:,m+1) = A(:,m) + k*M(d_i,:)';
              %t(m+1) = t(m) + t_i;
              t(m+1)=t_i;
              m = m + 1;
              
              %disp([' * Delayed reaction: ',num2str(d_i),' (t=',num2str(t_i),')']);
              
              %Now ignore previous selection and go to a)
          end
          
      
      %If delayed reaction put in stack
      else
            istack(end+1)=i;
            tstack(end+1)=t(m)+tau+tstar;
            
            %disp([' > Postponing reaction ',num2str(i),' for t=',num2str(t(m)+tau+tstar),'']);
      end
      
      
      % memory management
      if (m >= numSteps)
        %disp(['Doubling memory for data. (Reallocation.)  t(',num2str(m),')=',num2str(t(m))]);
        %tic
        Aaux = zeros(numNodes,2*numSteps);
        tstarx = zeros(1,2*numSteps);
        Aaux(:,1:numSteps) = A;
        tstarx(1:numSteps) = t;
        A = Aaux;
        t = tstarx;
        clear Aaux tstarx;
        numSteps = 2*numSteps;
        %fprintf('  done. [%fsec]\n', toc);
      end
    end % while
%    close(h) % Close waitbar ***

    % cutting the zeros at the end of arrays
    A = A(:,1:m);
    t = t(1:m);

    % postprocessing
    if (t(m) > T)
      t(m) = T;
    end
    t=t-tau;
    for j=1:numNodes
      if (A(j,m) < 0)
        A(j,m) = 0;
      end
    end
    A=A';



