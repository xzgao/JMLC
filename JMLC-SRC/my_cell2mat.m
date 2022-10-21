function [ output_args ] = my_cell2mat( input_args )
% 自带的cell2mat只能转换1行cell数据，例如1x12 cell。但是对于多行（例如：10x12 cell）却无能为力，
% 我们的算法就是处理多行cell的
[n1,~] = size(input_args); % 输入样本的行数

output_args = cell(n1,1);
for i1 = 1:n1
    input1 = input_args(i1,:);
    output_args{i1,:} = cell2mat(input1);
end


end

