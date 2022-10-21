function [dist] = myL2C_Correct_fast(K_YY, K_XuXu, B1, B21, B24, B41, B44, lambda1, lambda2,tr,tt)


%X1 testing sample, gamma  K_YY
%X2 trainging, eta  K_XuXu
K_XuY = tr.K_XuY;
K_YXu = K_XuY';
K_XiY = tr.K_XiY;
K_YXi = K_XiY';
K_UiY = tr.K_UiY;
K_YUi = K_UiY';
n_test = size(K_YY,2);
n_train = size(K_XuXu,2);

gamma = ones(n_test,1)/n_test;
e_eta = ones(n_train,1);
z2 = K_XuY*gamma;
eta = tr.P*(e_eta + z2);
z1 = K_YXu*eta;
energy0 = eta'*K_XuXu*eta - 2*eta'*z2 + gamma'*K_YY*gamma + lambda2*norm(gamma,2)^2 + lambda1*norm(eta,2)^2;

e_gamma = ones(n_test,1);
energy = ones(51,1);
energy(1) = energy0;
for loop = 1:5 %100
    gamma = tt.P*(e_gamma + z1);
    z2 = K_XuY*gamma;
    eta = tr.P*(e_eta + z2);
    z1 = K_YXu*eta;
    energy1 = eta'*K_XuXu*eta - 2*eta'*z2 + gamma'*K_YY*gamma + lambda2*norm(gamma,2)^2 + lambda1*norm(eta,2)^2;  %Ä¿±êº¯Êý
    energy(loop+1) = energy1;
    if (abs(energy1-energy0) < 1e-6)
        break;
    end
    energy0 = energy1;
end
%fprintf('The total iteration number is: %d\n',loop); 

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


