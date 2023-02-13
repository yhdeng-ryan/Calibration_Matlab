function [Vector6] = Convert_tformCell_to_vectXYZ6(A)

%% convert 4x4xN homogenous form to EulerXYZ form with 6Dof
% Vector6 first 3 is tran, last 3 is rot part, Rxyz= rot_x * rot_y * rot_z
n = size(A);
for i=1:n(3);
    Vector6(i,1:3) = A(1:3,4,i); % trans part
    Vector6(i,4) = atan2(A(3,2,i),A(3,3,i));
    Vector6(i,5) = atan2(-A(3,1,i), (sqrt((A(3,2,i)^2)+(A(3,3,i)^2))));
    Vector6(i,6) = atan2(A(2,1,i),A(1,1,i));
end
end