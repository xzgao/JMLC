function [ output_args ] = my_cell2mat( input_args )
% �Դ���cell2matֻ��ת��1��cell���ݣ�����1x12 cell�����Ƕ��ڶ��У����磺10x12 cell��ȴ����Ϊ����
% ���ǵ��㷨���Ǵ������cell��
[n1,~] = size(input_args); % ��������������

output_args = cell(n1,1);
for i1 = 1:n1
    input1 = input_args(i1,:);
    output_args{i1,:} = cell2mat(input1);
end


end

