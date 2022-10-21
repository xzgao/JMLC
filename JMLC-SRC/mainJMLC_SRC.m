function [ Acc ] = mainJMLC_SRC( param,loop )


% load parameters
lambda1 = param.lambda1;
lambda2 = param.lambda2;
rho1 = param.rho1;
TrainNum = param.TrainNum;
nClass = param.nClass;
nImgSet = param.nImgSet;
nTrain = TrainNum*nClass; % total number of training image sets
nTest = nImgSet - nTrain; % total number of testing image sets

[TrainData,TestData,TrainLabel,TestLabel] = DataProcess(param,loop);

Pre = zeros(1,nTest); % the predicted set-level label.
for ii1 = 1:nTest
    
    %%%%---Precalculate the inverse of a matrix---------------------------------
    TestData_i = TestData{ii1}; 
    Y = TestData_i./( repmat(sqrt(sum(TestData_i.*TestData_i)), [size(TestData_i,1),1]) );

    er = ones(size(Y,2),1);
    tt.P = inv(2*(Y'*Y)+rho1*(er*er')+rho1*eye(size(Y,2)) );
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
    
    Dis = zeros(1,nTrain); % % the distance between Y and each training image set
    %%%------------------------Construct new TrainData_i------------------%
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
        XU = new_TrainData_i;
        en = ones(size(XU,2),1);
        ntr.P = inv(2*(XU'*XU)+rho1*(en*en')+rho1*eye(size(XU,2)) );
        ntr.Xi = XXi1;
        ntr.Ui = UUi1;
        dist = myL2C_Correct_fast(Y,XU,lambda1,lambda2,rho1,ntr,tt);
        Dis(ii2) = dist;
    end
    %%%------------------------end----------------------------------------%
    
    [MinDis,Cla] = min(Dis);
    Pre(ii1) = Cla;
end


Acc = sum(Pre == TestLabel)/numel(TestLabel);
fprintf('The classification accuracy is:%f\n',100*Acc);

end

