function [ F ] = Convert_RT2frame(roll, tilt )
%RT2FRAME take in a position 3 vector (xyz) and roll and tilt angles in
%radians, return a 3x3 matrix, which is Rotation part of homogeneous frame

R = rotx(roll)*roty(tilt);
F = eye(3);
F(1:3,1:3) = R;
end

