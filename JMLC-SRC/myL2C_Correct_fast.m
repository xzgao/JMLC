function [dist] = myL2C_Correct_fast(X1,X2,lambda1,lambda2,rho1,tr,tt)


% X1 testing sample
% X2 trainging sample

gamma = ones(size(X1,2),1)/size(X1,2);
g1     = X1*gamma;
e1 = ones( size(X2,2),1);
eta = myCompute_eta( X1,X2,lambda1,rho1,tr,gamma,e1,g1 );
g2 = X2*eta;
e2 = ones(size(X1,2),1);
energy0 = sum((g2 - g1).^2) + lambda1*norm(eta,1) + lambda2*norm(gamma,1);


for loop = 1:5
    gamma = myCompute_gamma( X1,X2,lambda2,rho1,tt,eta,e2,g2 );
    g1     = X1*gamma;
    eta = myCompute_eta( X1,X2,lambda1,rho1,tr,gamma,e1,g1 );
    g2 = X2*eta;
    energy1 =  sum((g2 - g1).^2) + lambda1*norm(eta,1) + lambda2*norm(gamma,1);
    if (abs(energy1-energy0) < 1e-4)
        break;
    end
    energy0 = energy1;
end
%fprintf('the total number of iteration is:%d\n',loop); 

neta = length(eta);
ximean = X2(:,1);
Train_i = X2(:,3:neta/2+1);
uimean = X2(:,2);
UnRelated_i = X2(:,neta/2+2:end);
alpha1 = eta(1);
alpha2 = eta(2);
beta1 = eta(3:neta/2+1);
beta2 = eta(neta/2+2:end);

%delta1 = eta;
%delta1(2) = 0;

%delta2 = eta;
%delta2(1) = 0;

dist1 = norm(X1*gamma - [ximean, Train_i]*[alpha1; beta1], 2)^2 /norm([alpha1; beta1], 2)^2;%*(tt.nuclear_norm+tr.nuclear_norm_Xi);
dist2 = norm(X1*gamma - [uimean, UnRelated_i]*[alpha2; beta2], 2)^2 / norm([alpha2; beta2], 2)^2;%*(tt.nuclear_norm+tr.nuclear_norm_Ui);


dist = dist1/dist2;


end


