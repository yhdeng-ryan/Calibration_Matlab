function [B] = Convert_vectXYZ6_to_tformCell(A)

%% convert EulerXYZ form with 6Dof to 4x4xN homogenous form
% Vector6 first 3 is tran, last 3 is rot part, Rxyz= rot_x * rot_y * rot_z
n = size(A);
for i=1:n;
    x_rot(:,:,i) = [1 0 0; 0 cos(A(i,4)) -sin(A(i,4)); 0 sin(A(i,4)) cos(A(i,4))];
    y_rot(:,:,i)  = [cos(A(i,5)) 0 sin(A(i,5)); 0 1 0; -sin(A(i,5)) 0 cos(A(i,5))];
    z_rot(:,:,i)  = [cos(A(i,6)) -sin(A(i,6)) 0 ; sin(A(i,6)) cos(A(i,6)) 0; 0 0 1];        
   B(1:3,1:3,i)= x_rot(:,:,i) * y_rot(:,:,i) * z_rot(:,:,i);
   
   B(1:3,4,i) = A(i,1:3); % trans part
   B(4,:,i) = [0 0 0 1];
end
end