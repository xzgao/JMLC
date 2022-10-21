

JMLC-CRC on EYaleB (subset)


% You should modify parameters in "TenFold.m"

%   param.nImgSet: the total number of training image sets \
%   param.nClass: your class number \
%   param.TrainNum: your training number (i.e., in each class you have "param.TrainNum" image sets) \
%   param.nClass:   the class number \
%   param.UnRelatedType = 's5';  % this parameter can be 's1', 's2', 's3', 's4', 's5', 's6'.

%---------------s3 and s5 ------------------------------ \
%   param.rho = 1;   % the parameter that will be used in sparse representation, i.e., in 's3' and 's5' \
%   param.alpha = 1; % the parameter that will be used in sparse representation, i.e., in 's3' and 's5' \
%---------------s6-------------------------------------- \
%   param.lambda = 0.001; % the parameter that will be used in 's6'

% Here is an example on EYaleB dataset with 'subset' scenario \
%   let param.lambda1 = 1e-3; param.lambda2 = 1e-4; and use the 's5' strategy

    [MeanAcc] = TenFold(1e-3,1e-4);  % you will see average accuracy: 89.87


