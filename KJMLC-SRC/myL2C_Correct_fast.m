function [dist] = myL2C_Correct_fast(K_YY,K_XuXu,K_XuY,B1, B21, B24, B41, B44,lambda1,lambda2,rho1,tr,tt)


K_XuY = tr.K_XuY;
K_YXu = K_XuY';
K_XiY = tr.K_XiY;
K_YXi = K_XiY';
K_UiY = tr.K_UiY;
K_YUi = K_UiY';


gamma = ones(size(K_YY,2),1)/size(K_YY,2);
g1     = K_XuY*gamma;
e1 = ones( size(K_XuXu,2),1);
eta = myCompute_eta( K_YY, K_XuXu, K_XuY, lambda1, rho1, tr, gamma, e1, g1 );
g2 = K_YXu*eta;
e2 = ones(size(K_YY,2),1);
energy0 = objective(K_YY, gamma, K_XuXu, eta, K_XuY) + lambda1*norm(eta,1) + lambda2*norm(gamma,1);


for loop = 1:5
    gamma = myCompute_gamma( K_YY, K_XuXu, K_XuY, lambda2, rho1, tt, eta, e2, g2 );
    g1     = K_XuY*gamma;
    eta = myCompute_eta( K_YY, K_XuXu, K_XuY, lambda1, rho1, tr, gamma, e1, g1 );
    g2 = K_YXu*eta;
    energy1 =  objective(K_YY, gamma, K_XuXu, eta, K_XuY) + lambda1*norm(eta,1) + lambda2*norm(gamma,1);
    
    if (abs(energy1-energy0) < 1e-4)
        break;
    end
    energy0 = energy1;
end


neta = length(eta);
alpha1 = eta(1);
beta1 = eta(3:neta/2+1);
alpha2 = eta(2);
beta2 = eta(neta/2+2:end);

D1 = gamma'*K_YY*gamma;
D2 = gamma'*mean(K_YXi,2)*alpha1; 
n_sample = size(K_XiY,1);
D3 = gamma'*( K_YXi - repmat(mean(K_YXi,2), 1, n_sample) )*beta1;
D4 = D2';  D5 = alpha1'*B1(1,1)*alpha1;
D6 = alpha1'*B21*beta1;  D7 = D3';   D8 = D6';
D9 = beta1'*B41*beta1;
dr = D1-D2-D3-D4+D5+D6-D7+D8+D9;
dist1 = dr/norm([alpha1; beta1], 2)^2;

E1 = D1;  E2 = gamma'*mean(K_YUi,2)*alpha2;
E3 = gamma'*( K_YUi - repmat( mean(K_YUi, 2), 1, n_sample) )*beta2;
E4 = E2';  E5 = alpha2'*B1(2,2)*alpha2;   E6 = alpha2'*B24*beta2;
E7 = E3';  E8 = E6';   E9 = beta2'*B44*beta2;
du = E1 - E2 - E3 - E4 + E5 + E6 - E7 + E8 + E9;
dist2 = du / norm([alpha2; beta2], 2)^2;

dist = dist1/dist2;




end


