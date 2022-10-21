function [ UnRelatedSet ] = ConstructUnrelatedSets1( TrainData,TrainLabel,TestData_i,param )


TrainNum = param.TrainNum;
nClass = param.nClass;
%nImgSet = param.nImgSet;
nTrain = TrainNum*nClass;

X_all = cell2mat(TrainData);
L = size(X_all,2);

y_mean = mean(TestData_i,2);

xmeanall = mean(X_all,2);
train_tem2_all = X_all-xmeanall*ones(1,L);
test_tem2 = TestData_i - y_mean*ones(1,size(TestData_i,2));%t
test_train_tem2_all = [train_tem2_all -test_tem2];
XmeanYmeanall = y_mean-xmeanall;

coef=inv(test_train_tem2_all'*test_train_tem2_all+0.01*eye( size(test_train_tem2_all,2) ))*test_train_tem2_all'*XmeanYmeanall;

Dis = zeros(1,L);
for kt = 1:L
    Dis(kt) = norm(XmeanYmeanall-X_all(:,kt)*coef(kt));
end

%%%----construct 'AllLabel" according to 'TrainLabel'
AllLabel = zeros(1,L);
sum1 = 0;
for loop1 = 1:nTrain
    Data_loop1 = TrainData{loop1}; % the loop1^{th} image set
    n_loop1 = size(Data_loop1,2);
    AllLabel(1,sum1+1:sum1+n_loop1) = TrainLabel(loop1)*ones(1,n_loop1);
    sum1 = sum1 + n_loop1;
end
%%%-----------------------------

%%%--Construct the unrelated set of the each training image set.
UnRelatedSet = cell(1,nTrain);
for j1 = 1:nTrain
    Classi = TrainLabel(j1); % the label of the j1^{th} image set in TrainData¡£
    n_j1_1 = sum(AllLabel <= Classi-1); % Total image set number of the first 'Classi-1' class
    
    n_j1 = sum(AllLabel == Classi); % Total image set number of the Classi^{th} class
    
    X_all_hat = X_all;
    
    Dis_hat = Dis;
    Dis_hat(:,n_j1_1+1:n_j1_1+n_j1) = 1e10; %[]; Let the distance corresponding to class i sample becomes very large
    
    [~,labsel] = sort(Dis_hat,'ascend');  % ascend 
    UnRelatedSet{j1} = X_all_hat(:,labsel(1:n_j1));
    
end
%%%--end

%end


end

