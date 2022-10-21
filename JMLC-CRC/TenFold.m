

%clear;
%close all;
%clc;

function [MeanAcc] = TenFold(f1, f2) 
param.nImgSet = 190;  % the total number of training image sets
param.nClass = 38;    % your class number
param.TrainNum = 1;   % your training number (i.e., in each class you have "param.TrainNum" image sets.
param.lambda1 = f1;   % regularization parameter
param.lambda2 = f2;   % regularization parameter
param.UnRelatedType = 's5';   % this parameter can be 's1', 's2', 's3', 's4', 's5', 's6'.

%%%%---------------s3 and s5--------------------------
param.rho = 1;   % the parameter that will be used in sparse representation, i.e., in 's3' and 's5'
param.alpha = 1; % the parameter that will be used in sparse representation, i.e., in 's3' and 's5'
%%%%---------------s3-s5-end--------------------------
param.lambda = 0.001; % the parameter that will be used in 's6'

loop = 5;
AllAcc = zeros(loop,1); 
alltime = zeros(1,loop);

for i1 = 1:loop
    disp(['Extend Yale B Database: Setting',num2str(1),' -- Experiments ',num2str(i1),' Start!']);
    param.fix_j = i1;
    tic;
    [Acc] = mainJMLC_CRC(param,i1);
    time = toc;
    alltime(i1) = time;
    AllAcc(i1,:) = Acc;
end


MeanAcc = mean(100*AllAcc);
VarAcc = std(100*AllAcc);
disp(['n fold mean accuracy:  ' num2str(MeanAcc)]);
disp(['n fold vaariance:  ' num2str(VarAcc)]);

meantime = mean(alltime);
vartime = var(alltime);


