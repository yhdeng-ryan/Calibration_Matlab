function [rotation_out] =Convert_Rot_Rxyz(rotations)
%ROTO_MATRIX: calculate rotation matrix from euler angles in degrees
%   Input:  1x3 vector of euler rotations around x rotations(1), y 
%   rotations(2), and z, rotations(3) or 3x3 rotation matrix
%   Output: 3x3 matrix representing rotations around x, y, and z axis
%           or 1x3 vector of euler angles in degrees
%   NOTE: Euler angles returned when doing a decomposition will be in the 
%   following ranges (in radians):

%   theta_x --> (-pi, pi) 
%   theta_y --> (-pi/2, pi/2)
%   theta_z --> (-pi, pi) 

% Angles within these ranges will be the same after decomposition: angles 
% outside these ranges will produce the correct rotation matrix, but the 
% decomposed values will be different to the input angles.

% error check
if  size(rotations, 2) == 2 | size(rotations, 2) > 3
    error('Input must be 1x3 vector of xyz euler rotations or 3x3 rotation matrix');
end

if  size(rotations, 1) == 2 | size(rotations, 2) > 3
    error('Input must be 1x3 vector of xyz euler rotations or 3x3 rotation matrix');
end

if size(rotations, 1) == 1;
% calculate rotation matrix
x_rot = [1 0 0; 0 cosd(rotations(1)) -sind(rotations(1)); 0 sind(rotations(1)) cosd(rotations(1))];
y_rot = [cosd(rotations(2)) 0 sind(rotations(2)); 0 1 0; -sind(rotations(2)) 0 cosd(rotations(2))];
z_rot = [cosd(rotations(3)) -sind(rotations(3)) 0 ; sind(rotations(3)) cosd(rotations(3)) 0; 0 0 1];        
rotation_out = x_rot*y_rot*z_rot;
else
rotation_out = zeros(1,3);
rotation_out(1) = atan2(rotations(3,2),rotations(3,3));
rotation_out(2) = atan2(-rotations(3,1), (sqrt((rotations(3,2)^2)+(rotations(3,3)^2))));
rotation_out(3) = atan2(rotations(2,1),rotations(1,1));
% convert back to degrees
for i=1:size(rotation_out,2)
    rotation_out(i) = 180*rotation_out(i)/pi;
end
end
end


