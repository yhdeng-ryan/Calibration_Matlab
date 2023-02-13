function [B] = Convert_vect5_to_quat7(A)

[B_tformCell,B_tform] = Convert_vect5_to_tform(A); % convert vect5 to tform
[B] = Convert_tform_to_quat7(B_tformCell); % conver tform to quaternion7

end