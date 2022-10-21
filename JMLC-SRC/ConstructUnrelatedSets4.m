function [ UnRelatedSet ] = ConstructUnrelatedSets4( TrainData,TrainLabel,TestData_i,param )

TrainNum = param.TrainNum;
nClass = param.nClass;
%nImgSet = param.nImgSet;
nTrain = TrainNum*nClass;

X_all = cell2mat(TrainData);
L = size(X_all,2);

y_mean = mean(TestData_i,2);
beta = (X_all'*X_all + 0.001*eye(L) )\X_all'*y_mean;

Dis = zeros(1,L);
for i2 = 1:L
    Dis(i2) = norm(X_all(:,i2)*beta(i2) - y_mean);
end

%%%----construct 'AllLabel" according to 'TrainLabel'
AllLabel = zeros(1,L);
sum1 = 0;
for loop1 = 1:nTrain
    Data_loop1 = TrainData{loop1}; 
    n_loop1 = size(Data_loop1,2);
    AllLabel(1,sum1+1:sum1+n_loop1) = TrainLabel(loop1)*ones(1,n_loop1);
    sum1 = sum1 + n_loop1;
end
%%%-----------------------------

%%%--Construct the unrelated set of the each training image set.
UnRelatedSet = cell(1,nTrain);
for j1 = 1:nTrain
    Classi = TrainLabel(j1); 
    n_j1_1 = sum(AllLabel <= Classi-1); 
    
    n_j1 = sum(AllLabel == Classi); 
    
    X_all_hat = X_all;
    
    Dis_hat = Dis;
    Dis_hat(:,n_j1_1+1:n_j1_1+n_j1) = 1e10; 
    
    [~,labsel] = sort(Dis_hat,'ascend');  % ascend 
    UnRelatedSet{j1} = X_all_hat(:,labsel(1:n_j1));
    
end
%%%--end

%end


end

