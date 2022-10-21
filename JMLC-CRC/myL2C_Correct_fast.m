function [dist] = myL2C_Correct_fast(X1,X2,lambda1,lambda2,tr,tt)

% X1 testing sample
% X2 training sample

beta = ones(size(X1,2),1)/size(X1,2);
z     =  [zeros(size(X1,1),1);1;1]; % [zeros(size(X1,1),1);1;2]
tem1  = [X1*beta;sum(beta);0]; % Y_gang*beta
alpha = tr.P*(z-tem1);
tem2 = [-X2*alpha;0;sum(alpha)];
energy0 = norm(z-tem1-tem2,2)^2 + lambda2*norm(beta,2)^2 + lambda1*norm(alpha,2)^2; 


for loop = 1:5 %10
    beta = tt.P*(z-tem2);  
    tem1 = [X1*beta;sum(beta);0];
    alpha = tr.P*(z-tem1);
    tem2 = [-X2*alpha;0;sum(alpha)];
    energy1 = norm(z-tem1-tem2,2)^2 + lambda2*norm(beta,2)^2 + lambda1*norm(alpha,2)^2;  %Ä¿±êº¯Êý
    if (abs(energy1-energy0) < 1e-6)
        break;
    end
    energy0 = energy1;
end
%fprintf('the total number of iteration is:%d\n',loop); 

nalpha = length(alpha);
ximean = X2(:,1);
Train_i = X2(:,3:nalpha/2+1);
uimean = X2(:,2);
UnRelated_i = X2(:,nalpha/2+2:end);
alpha1 = alpha(1);
gamma1 = alpha(3:nalpha/2+1);
alpha2 = alpha(2);
gamma2 = alpha(nalpha/2+2:end); 

%delta1 = alpha;
%delta1(2) = 0;

%delta2 = alpha;
%delta2(1) = 0;

dist1 = norm(X1*beta - [ximean, Train_i]*[alpha1; gamma1], 2)^2 /norm([alpha1; gamma1], 2)^2;
dist2 = norm(X1*beta - [uimean, UnRelated_i]*[alpha2; gamma2], 2)^2 / norm([alpha2; gamma2], 2)^2;

dist = dist1/dist2;

end


