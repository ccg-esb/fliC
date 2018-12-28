
function out = f(y,params)


%    T=.01;
%    sold = ode15s(@(t,x)fZ(t,x,params),[0 T],y);
%    solution=sold.y';
    
%    out=norm(solution(1,:)-solution(end,:));
 
out = fwapper(y,params);
out=norm(out,2);
   
end
