
function [TrainData,TestData,TrainLabel,TestLabel] = DataProcess(param,loop)

% output:
%   - TrainData: 1*n cell data, and each element is an image set matrix (each column is an image in the set)
%   - TestData£º same to TrainData£»

nClass = param.nClass;
name = 'ExtYaleB';
s1 = load('D:\Databases\PCAlab_Datasets\ExtYaleB_illumination\ExtYaleB_Sub1_38_7_96_84');
s1 = s1.DAT;
[ data1,label1 ] = myPreprocess_Vector_cell( s1,name );
data1 = my_cell2mat(data1);
s2 = load('D:\Databases\PCAlab_Datasets\ExtYaleB_illumination\ExtYaleB_Sub2_38_12_96_84');
s2 = s2.DAT;
[ data2,label2 ] = myPreprocess_Vector_cell( s2,name );
data2 = my_cell2mat(data2);
s3 = load('D:\Databases\PCAlab_Datasets\ExtYaleB_illumination\ExtYaleB_Sub3_38_12_96_84');
s3 = s3.DAT;
[ data3,label3 ] = myPreprocess_Vector_cell( s3,name );
data3 = my_cell2mat(data3);
s4 = load('D:\Databases\PCAlab_Datasets\ExtYaleB_illumination\ExtYaleB_Sub4_38_14_96_84');
s4 = s4.DAT;
[ data4,label4 ] = myPreprocess_Vector_cell( s4,name );
data4 = my_cell2mat(data4);
s5 = load('D:\Databases\PCAlab_Datasets\ExtYaleB_illumination\ExtYaleB_Sub5_38_19_96_84');
s5 = s5.DAT;
[ data5,label5 ] = myPreprocess_Vector_cell( s5,name );
data5 = my_cell2mat(data5);

%------ In the kernel version, the follow line code  may not be used.
% data3{15,1}(:,5) = 0.00001*rand(504,1); % This column is all 0, unable to calculate
data3{15,1}(:,5) = []; % This column is all 0, unable to calculate

switch loop
    case 1
        TrainData = data1';
        TrainLabel = label1(:,1)';

        TestData = [data2,data3,data4,data5];
        TestData = reshape(TestData',1,nClass*4);
        TestLabel = reshape( label1(:,1:4)',1,nClass*4);
    case 2
        TrainData = data2';
        TrainLabel = label2(:,1)';

        TestData = [data1,data3,data4,data5];
        TestData = reshape(TestData',1,nClass*4);
        TestLabel = reshape( label2(:,1:4)',1,nClass*4);
        
    case 3
        TrainData = data3';
        TrainLabel = label3(:,1)';
        TestData = [data2,data1,data4,data5];
        TestData = reshape(TestData',1,nClass*4);
        TestLabel = reshape( label3(:,1:4)',1,nClass*4);
        
    case 4
        TrainData = data4';
        TrainLabel = label4(:,1)';

        TestData = [data2,data3,data1,data5];
        TestData = reshape(TestData',1,nClass*4);
        TestLabel = reshape( label4(:,1:4)',1,nClass*4);
        
    case 5
        TrainData = data5';
        TrainLabel = label5(:,1)';

        TestData = [data2,data3,data4,data1];
        TestData = reshape(TestData',1,nClass*4);
        TestLabel = reshape( label5(:,1:4)',1,nClass*4);
end


end


