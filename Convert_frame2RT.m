function [RT] = Convert_frame2RT(F)
%FRAME2RT convert from frame to roll and tilt

% pick out the z vector of the frame rotation
zR = F(1:3,3);

%reconstruct roll
projectedRoll = [0;zR(2);zR(3)];
projectedRoll = unit(projectedRoll);

% atan2 with these arguments is key
roll = atan2(-projectedRoll(2),projectedRoll(3));

%undo roll
projectedTilt = rotx(roll)'*zR;

%reconstruct tilt
tilt = atan2(projectedTilt(1),projectedTilt(3));

RT = [roll, tilt];
end

%% UNIT Unitize a vector
% VN = UNIT(V) is a unit-vector parallel to V.
% Note:: - Reports error for the case where norm(V) is zero.
% This file is part of The Robotics Toolbox for MATLAB (RTB). by Peter I. Corke
%  <http://www.gnu.org/licenses/>.
% http://www.petercorke.com

function u = unit(v)
    n = norm(v, 'fro');
    if n < eps
        error('RTB:unit:zero_norm', 'vector has zero norm');
    end

	u = v / n;
end


