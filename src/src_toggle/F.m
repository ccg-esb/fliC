function [Wp,W] = F(X,parameters)
    a = parameters.a;
    b = parameters.b;
    h = parameters.h;
    
	Wp = -4*(h - X.^2).*X + 2*a*(X+b);
    if nargout > 1
        W = (h - X.^2).^2 + a*(X+b).^2;
    end

end