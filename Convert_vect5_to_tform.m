function [B_tformCell,B_tform] = Convert_vect5_to_tform(A)

%% convert vector5 to tform, Call function, [ F ] = Convert_RT2frame(roll, tilt )
n =  size(A);
for  i=1:n;
B_tformCell(1:3,4,i) = A(i,1:3)';
B_tformCell(4,1:4,i) = [0 0 0 1]; 
end

for i=1:n;
B_tformCell(1:3,1:3,i) = Convert_RT2frame(A(i,4), A(i,5));
end
B_tform = reshape(B_tformCell,4,[]);