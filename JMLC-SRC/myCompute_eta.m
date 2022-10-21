function [ z ] = myCompute_eta( Y,X,lambda1,rho1,tr,gamma,e1,g1 )

% Y: Testing data
% X: Training data
% rho1 here corresponds to rho in the paper

t_start = tic;

QUIET    = 0;
MAX_ITER = 1000;
ABSTOL   = 1e-4;
RELTOL   = 1e-2;

% Data preprocessing
[m, n] = size(X);


% ADMM solver
%eta = zeros(n,1);
z = zeros(n,1);
u1 = 0;
u2 = zeros(n,1);


for i1 = 1:MAX_ITER
    
    % eta-update
    eta = tr.P*( 2*X'*g1 + rho1*e1 + rho1*z - u1*e1 - u2 );
    
    % z-update with relaxation
    z_old = z;
    z = shrinkage(eta + u2/rho1, lambda1/rho1);
    
    u1 = u1 + rho1*(e1'*eta - 1);
    u2 = u2 + rho1*(eta - z);
    
    % diagnostics, reporting, termination checks
    history.objval(i1)  = objective(Y,gamma,X,eta,z,lambda1);
    
    %history.lsqr_iters(k) = iters;
    history.r_norm(i1)  = norm(eta - z);
    history.s_norm(i1)  = norm(-rho1*(z - z_old));
    
    history.eps_pri(i1) = sqrt(n)*ABSTOL + RELTOL*max(norm(eta), norm(-z));
    history.eps_dual(i1)= sqrt(n)*ABSTOL + RELTOL*norm(rho1*u2);
    
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



