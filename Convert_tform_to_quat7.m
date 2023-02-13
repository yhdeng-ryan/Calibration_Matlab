function [B] = Convert_tform_to_quat7(A)
% transfer homogenous data:4xN form to quaternion7 data
% samples form
% input A is homogenous form, B is quaternion 7 data 

% check if 4x4xN
if  size(A, 1) == size(A, 2)
    n = size(A,3);
else  A = reshape(A, 4, 4, []);
    n = size(A,3);
end
  for i = 1: n;
     B(i,4:7) = tform2quat(A(:,:,i));
     B(i,1:3)= A(1:3,4,i)';
  end  

end

