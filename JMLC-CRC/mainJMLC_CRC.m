function [ Acc ] = mainJMLC_CRC( param,loop )

% load parameters
lambda1 = param.lambda1;
lambda2 = param.lambda2;
TrainNum = param.TrainNum;
nClass = param.nClass;
nImgSet = param.nImgSet;
nTrain = TrainNum*nClass; % total number of training image sets
nTest = nImgSet - nTrain; % total number of testing image sets

[TrainData,TestData,TrainLabel,TestLabel] = DataProcess(param,loop); 

Pre = zeros(1,nTest); % the predicted set-level label.
for ii1 = 1:nTest
    
    %%%%---Precalculate the inverse of a matrix---------------------------------
    TestData_i = TestData{ii1}; % the ii1^{th} testing sample (image set)
    Y = TestData_i./( repmat(sqrt(sum(TestData_i.*TestData_i)), [size(TestData_i,1),1]) ); % normalization
    Ypv = Y; 
    temD = [Ypv;ones(1,size(Ypv,2));zeros(1,size(Ypv,2))];  % \bar{Y} in Eq.(6)
    tt.P = inv(temD'*temD+lambda2*eye(size(temD,2)))*temD'; % P_eta
    tt.Y = Y;
    clear temD
    %%%%---end------------------------------------------------------
    
    %%%-------------------- constructing unrelated sets--------------------
    switch param.UnRelatedType
        case 's1'
            [UnRelatedSet] = ConstructUnrelatedSets1(TrainData,TrainLabel,TestData_i,param);
        case 's2'
            [UnRelatedSet] = ConstructUnrelatedSets2(TrainData,TrainLabel,TestData_i,param);
        case 's3'
            [UnRelatedSet] = ConstructUnrelatedSets3(TrainData,TrainLabel,TestData_i,param);
        case 's4'
            [UnRelatedSet] = ConstructUnrelatedSets4(TrainData,TrainLabel,TestData_i,param);
        case 's5'
            [UnRelatedSet] = ConstructUnrelatedSets5(TrainData,TrainLabel,TestData_i,param);
        case 's6'
            [UnRelatedSet] = ConstructUnrelatedSets6(TrainData,TrainLabel,TestData_i,param);
    end
    %%%-------------------- end--------------------
    
    Dis = zeros(1,nTrain);  % the distance between Y and each training image set
    %%%------------------------Construct new TrainData_i------------------%
    % new_TrainData_i = [TrainData_i,UnrelatedData_i]
    for ii2 = 1:nTrain
        XXi = TrainData{ii2};
        XXi1 = XXi./( repmat(sqrt(sum(XXi.*XXi)), [size(XXi,1),1]) );
        
        ximean = mean(XXi1,2);
        Xi_hat = XXi1 - repmat(ximean,1,size(XXi1,2));
        
        UUi = UnRelatedSet{ii2};
        UUi1 = UUi./( repmat(sqrt(sum(UUi.*UUi)), [size(UUi,1),1]) );
        uimean = mean(UUi1,2);
        Ui_hat = UUi1 - repmat(uimean,1,size(UUi1,2));
        
        P = [ximean,uimean];
        V = [Xi_hat,Ui_hat];
        new_TrainData_i = [P,V];
        Xi = new_TrainData_i;
        temD = [-Xi;zeros(1,size(Xi,2));ones(1,size(Xi,2))]; % \bar{X} in Eq.(6)
        ntr.P = inv(temD'*temD+lambda1*eye(size(temD,2)))*temD';
        ntr.Xi = XXi1;
        ntr.Ui = UUi1;
        dist = myL2C_Correct_fast(Ypv,Xi,lambda1,lambda2,ntr,tt);
        Dis(ii2) = dist;
    end
    %%%------------------------end----------------------------------------%
    
    [MinDis,Cla] = min(Dis);
    Pre(ii1) = Cla;
end


Acc = sum(Pre == TestLabel)/numel(TestLabel);
fprintf('The classification accuracy is:%f\n',100*Acc);

end

