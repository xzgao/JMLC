function [ Acc ] = mainKJMLC_SRC( param )


lambda1 = param.lambda1;
lambda2 = param.lambda2;
rho1 = param.rho1;
TrainNum = param.TrainNum;
nClass = param.nClass;
nImgSet = param.nImgSet;
nTrain = TrainNum*nClass;
nTest = nImgSet - nTrain;

[TrainData,TestData,TrainLabel,TestLabel] = DataProcess(param, param.fix_j);

Pre = zeros(1,nTest); 
for ii1 = 1:nTest
    
    %%%%-----------------------------------------------------------
    TestData_i = TestData{ii1}; 
    Y = TestData_i./( repmat(sqrt(sum(TestData_i.*TestData_i)), [size(TestData_i,1),1]) );
    %Y = TestData_i;
    K_YY = kernelfun( Y, Y, param ); % phi(Y)'*phi(Y)
    er = ones(size(Y,2),1);
    tt.P = inv(2*K_YY+rho1*(er*er')+rho1*eye(size(Y,2)) );
    tt.Y = Y;
    clear temD
    %%%%---end------------------------------------------------------
    
    %%%-------------------- construct unrelated set
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
    %%%-------------------- end
    
    Dis = zeros(1,nTrain); % 
    %%%------------------------Construct new TrainData_i------------------%
    for ii2 = 1:nTrain
        XXi = TrainData{ii2}; % 
        XXi1 = XXi./( repmat(sqrt(sum(XXi.*XXi)), [size(XXi,1),1]) );
        
        UUi = UnRelatedSet{ii2};
        UUi1 = UUi./( repmat(sqrt(sum(UUi.*UUi)), [size(UUi,1),1]) );
        
        
        %%%-----------------kernel matrices--------------------------------
        K_XiY = kernelfun( XXi1, Y, param ); % phi(XXi1)'*phi(Y)
        K_YXi = K_XiY';
        K_UiY = kernelfun( UUi1, Y, param ); % phi(UUi1)'*phi(Y)
        K_YUi = K_UiY';
        K_XiXi = kernelfun( XXi1, XXi1, param );
        K_UiUi = kernelfun( UUi1, UUi1, param );
        K_XiUi = kernelfun( XXi1, UUi1, param );
        K_UiXi = K_XiUi';
        %%%-----------------end--------------------------------------------
        
        %----------------------compute K_XuY, K_XuXu---------------------
        %K_XuY = [A1; A2; A3; A4];
        n_XXi1_sam = size(XXi1,2); 
        ee = ones(1, n_XXi1_sam);
        One_matrix = ones(n_XXi1_sam,n_XXi1_sam);
        A1 = mean(K_XiY);
        A2 = mean(K_UiY);
        A3 = K_XiY - repmat(A1, n_XXi1_sam, 1);
        A4 = K_UiY - repmat(A2, n_XXi1_sam, 1);
        K_XuY = [A1; A2; A3; A4];
        K_YXu = K_XuY';
        
        %K_XuXu = [B1, B2; B3, B4];
        K_ximean_ximean = mean(K_XiXi(:));
        K_ximean_uimean = mean(K_XiUi(:));
        K_uimean_ximean = K_ximean_uimean';
        K_uimean_uimean = mean(K_UiUi(:));
        B1 = [ K_ximean_ximean, K_ximean_uimean; K_uimean_ximean, K_uimean_uimean];
        
        K_XiXi_mean = mean(K_XiXi);
        K_XiUi_mean = mean(K_XiUi);
        K_UiXi_mean = mean(K_UiXi);
        K_UiUi_mean = mean(K_UiUi);
        B21 = K_XiXi_mean - K_ximean_ximean*ee;
        B22 = K_XiUi_mean - K_ximean_uimean*ee;
        B23 = K_UiXi_mean - K_uimean_ximean*ee;
        B24 = K_UiUi_mean - K_uimean_uimean*ee;
        B2 = [B21, B22; B23, B24];
        B3 = B2';
        
        B41 = K_XiXi - repmat(K_XiXi_mean,n_XXi1_sam,1) - repmat(K_XiXi_mean, n_XXi1_sam,1)' + K_ximean_ximean*One_matrix;
        B42 = K_XiUi - repmat(mean(K_XiUi,2), 1, n_XXi1_sam) - repmat( K_XiUi_mean, n_XXi1_sam, 1 ) + K_ximean_uimean*One_matrix;
        B43 = B42';
        B44 = K_UiUi - repmat( K_UiUi_mean, n_XXi1_sam, 1 ) - repmat( K_UiUi_mean, n_XXi1_sam, 1 )' + K_uimean_uimean*One_matrix;
        B4 = [B41, B42; B43, B44];
        
        K_XuXu = [B1, B2; B3, B4];
        %--------------------------
        
        en = ones(size(K_XuXu,2),1);
        ntr.P = inv(2*K_XuXu+rho1*(en*en')+rho1*eye(size(K_XuXu,2)) );
        ntr.K_XuY = K_XuY;
        ntr.K_XiY = K_XiY;
        ntr.K_UiY = K_UiY;
        
        dist = myL2C_Correct_fast(K_YY,K_XuXu,K_XuY,B1, B21, B24, B41, B44,lambda1,lambda2,rho1,ntr,tt);
        Dis(ii2) = dist;
    end
    %%%------------------------end----------------------------------------%
    
    [MinDis,Cla] = min(Dis);
    Pre(ii1) = Cla;
end


Acc = sum(Pre == TestLabel)/numel(TestLabel);
fprintf('The classification accuracy is: %f\n',100*Acc);

end

