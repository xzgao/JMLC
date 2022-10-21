function p = objective(Y,gamma,X,eta,z,lambda)
p = sum((X*eta - Y*gamma).^2) + lambda*norm(z,1); % + rho1/2*sum((e1'*eta-1+u1/rho1).^2) + rho1/2*sum((eta-z+u2/rho1).^2);
end


