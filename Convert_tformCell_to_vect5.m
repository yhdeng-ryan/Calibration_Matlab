function [Vector5] = Convert_tformCell_to_vect5(A)

% Vector,the first 3 are trans, last 2 are Roll and Tilt):

n = size(A);

for i = 1: n(3);
% trans part
Vector5(i,1:3) = A(1:3,4,i);
% Call function Convert_frame2RT
Vector5(i,4:5) = Convert_frame2RT(A(:,:,i));
end

end