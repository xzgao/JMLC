function [ z ] = myCompute_gamma( Y,X,lambda2,rho1,tt,eta,e2,g2 )


% Y: Testing data
% X: Training data
% rho1 here corresponds to rho in the paper

t_start = tic;

QUIET    = 0;
MAX_ITER = 1000;
ABSTOL   = 1e-4;
RELTOL   = 1e-2;

% Data preprocessing
[m, n] = size(Y);


% ADMM solver
%eta = zeros(n,1);
z = zeros(n,1);
u3 = 0;
u4 = zeros(n,1);

for i1 = 1:MAX_ITER
    
    % gamma-update
    gamma = tt.P*( 2*Y'*g2 + rho1*e2 + rho1*z - u3*e2 - u4 );
    
    % z-update with relaxation
    z_old = z;
    z = shrinkage(gamma + u4/rho1, lambda2/rho1);
    
    u3 = u3 + rho1*(e2'*gamma - 1);
    u4 = u4 + rho1*(gamma - z);
    
    % diagnostics, reporting, termination checks
    history.objval(i1)  = objective(Y,gamma,X,eta,z,lambda2);
    
    %history.lsqr_iters(k) = iters;
    history.r_norm(i1)  = norm(gamma - z);
    history.s_norm(i1)  = norm(-rho1*(z - z_old));
    
    history.eps_pri(i1) = sqrt(n)*ABSTOL + RELTOL*max(norm(gamma), norm(-z));
    history.eps_dual(i1)= sqrt(n)*ABSTOL + RELTOL*norm(rho1*u4);
    
    %disp([i1, history.objval(i1)]);
    
    if(i1==1)
        obj_old = 0;
    else
        obj_old = history.objval(i1-1);
    end
    obj_new = history.objval(i1);
    if (abs(obj_new-obj_old) < ABSTOL)
        break;
    end
    
end




end



