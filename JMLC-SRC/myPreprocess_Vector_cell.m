function [ data,label ] = myPreprocess_Vector_cell( input,name )
%  transform the 3D data to cell data
%  input -  3D data£¬such as ORL_40_10_56_46.mat£¬which is a 2576 x 10 x 40 3D data¡£
%  output - cell data£¬where each row denotes all images belong to same class, and each element is an image
%
%    Row - the row of each image
%    Column - the column of each image
%
%  label - the label of the output¡£

if strcmp('ORL',name)
    Row = 56;
    Col = 46;
    ReRow = 28;
    ReCol = 23;
else if strcmp('Yale',name)
        Row = 100;
        Col = 80;
        ReRow = 25;
        ReCol = 20;
    else if strcmp('ar',name)
            Row = 50;
            Col = 40;
            ReRow = 25;
            ReCol = 20;
        else if strcmp('ExtYaleB',name)
                Row = 96;
                Col = 84;
                ReRow = 24;
                ReCol = 21;
            end
        end
    end
end



[nFeature,nSample,nClass] = size(input); %  nFeature: the dimension of features¡£ nSample: samples in each class¡£ nClass£ºclass number

data = cell(nClass,nSample);
for i1=1:nClass
    for j1=1:nSample
        aa = input(:,j1,i1);
        aa1 = reshape(aa,[Row,Col]);
        aa2 = imresize(aa1,[ReRow,ReCol]);
        %data{i1,j1} = aa;
        data{i1,j1} = reshape(aa2,ReRow*ReCol,[]);
        
        %data{i1,j1} = input(:,j1,i1)';
        %dataResize{i1,j1} = imresize( aa1,[ReRow,ReCol]);
    end
end


label = zeros(nClass,nSample);
for i2 = 1:nClass
    label( i2,: ) = i2*ones(1,nSample);
end

end

