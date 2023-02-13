function [B0,B1] = Convert_quat7_to_tform(A)
% transfer quaternion7 data to homogenous data:
% B0 is the 4x4xM form. B1 is 4xN with N/4
% samples form
% input A is quaternion 7 data, B is homogenous form
B_Pos = A(:,1:3);
B_Rot = A(:,4:7);
B_Rob_Tform = quat2tform(B_Rot);
B_Rob_Tform(1:3,4,:) = B_Pos';
B0 = B_Rob_Tform;

% reshape 4x4xM data to 4xN form with N/4 samples,
B1 = reshape(B0,4,[]);
end




