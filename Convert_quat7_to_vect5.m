function [Vector5] = Convert_quat7_to_vect5(A)
% transfer Quaternion data (each row has 7 value, the first 3 are trans, last 4 are quaternion)
% to Vector data (each row has 6 value,the first 3 are trans, last 2 are Roll and Tilt):

%% first convert quat7 to tform, Call function [B0,B1] = Convert_quat7_to_tform(A)
%% then convert tform to vector, Call function [Vector5] = Convert_tformCell_to_vect5(A)

BCell = Convert_quat7_to_tform(A); % BCell is tformCell, which is 4x4xN data

Vector5 = Convert_tformCell_to_vect5(BCell);

end