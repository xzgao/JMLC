function [ UnRelatedSet ] = ConstructUnrelatedSets6( TrainData,TrainLabel,TestData_i,param )

TrainNum = param.TrainNum;
nClass = param.nClass;
%nImgSet = param.nImgSet;
nTrain = TrainNum*nClass;
lambda = param.lambda;
X_all = cell2mat(TrainData);
L = size(X_all,2);


%%%%%%%%%%%%%%%%%%%--------$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
% construct P - V

P = []; V = [];
SampleTrainLabel = [];
for ai1 = 1:nClass
    DataClass_i = TrainData( (ai1-1)*TrainNum+1:ai1*TrainNum ); 
    DataClass_i_matrix = cell2mat(DataClass_i);
    nSampleClass_i = size(DataClass_i_matrix,2); 
    label = ai1*ones(1,nSampleClass_i);
    SampleTrainLabel = [SampleTrainLabel,label];
       
    ci = mean(DataClass_i_matrix,2); 
    P = [P,ci];
    
    Ai = DataClass_i_matrix - repmat(ci,1,nSampleClass_i);
    V = [V,Ai];
end

%%%%%%%%%%%%%%%%%%%--------$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


%%%%%%%%%%%%%%
% normalization
[nPRow,nPColumn] = size(P);
[nVRow,nVColumn] = size(V);

PN = zeros(nPRow,nPColumn);
for pi1 = 1:nPColumn
    pi = P(:,pi1);
    pi2 = pi/norm(pi);
    PN(:,pi1) = pi2;
end

VN = zeros(nVRow,nVColumn);
for vi1 = 1:nVColumn
    vi = V(:,vi1);
    vi2 = vi/norm(vi);
    VN(:,vi1) = vi2;
end
%%%%%%%%%%%%%%%

P = PN;
V = VN;


y_mean = mean(TestData_i,2);
kl = size([P,V],2);
gamma = ( [P,V]'*[P,V] + lambda*eye( kl ) )\[P,V]'*y_mean;
alpha = gamma(1:nClass);
beta = gamma(nClass+1:end);


Dis = zeros(1,L);
for i2 = 1:L
    Class_i2 = SampleTrainLabel(i2);
    alpha_i2 = alpha(Class_i2);
    delta_alpha = zeros(1,nClass);
    delta_alpha(Class_i2) = alpha_i2;
    
    Dis(i2) = norm([P,V(:,i2)]*[delta_alpha';beta(i2)] - y_mean);
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


