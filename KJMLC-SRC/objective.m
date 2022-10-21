function p = objective(K_YY, gamma, K_XuXu, eta, K_XuY)
% Kernel version

p = eta'*K_XuXu*eta + gamma'*K_YY*gamma - 2*eta'*K_XuY*gamma; 

end


