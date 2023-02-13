function [data1, data2, i1, i2] = splitData (data, r)
% split data into 2 sets, r is the percentage of data1, 1-r should be the data2
% i1 and i2 represent which data is selected in the list
n = size(data);
n = n(1);
index = randperm(n);
n1 = fix(r * n);

i1 = index(1:n1);
i2 = index((n1+1):n);

data1 = data(i1,:);
data2 = data(i2,:);
end

%% example, the following split p_robot & p_tracker data to two datasets, C should be corresponding to K 
% [K_quat_1st, K_quat_2nd, i1, i2] = splitData (p_robot, 0.75);
% C_quat_1st = p_tracker(i1,:); C_quat_2nd = p_tracker(i2,:); 
 