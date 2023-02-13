%% this is a Demo for test the BernsteinPolyn
% there are two Bp. ComputeC_5D.m is for BernCorrection_5D.m, ComputeC_6D.m is for BernCorrection_6D.m
% 
clear all;
close all;
clc;
load Data % this data only contains RobotPos and TrackerPos

[K_eulZYX, K_eulXYZ] = Convert_quat7_to_euler6(p_robot); % convert the quaternion data to Eulerform, for p_robot
[C_eulZYX, C_eulXYZ] = Convert_quat7_to_euler6(p_tracker); % convert the quaternion data to Eulerform, for p_tracker


%% Test Bernstein, 6-dimension input, 6D output

para = paraBoxF(K_eulXYZ,C_eulXYZ);  % define a little larger bound for scaleBox, see function paraBoxF

Coef = ComputeC_6D(K_eulXYZ,C_eulXYZ,2,para);% Compute coef of BP, using input p, q,
[K_corrected] = BernCorrection_6D(Coef,K_eulXYZ,2,para);% Correct the input data with a new input,taking Coef

error = K_corrected - K_eulXYZ;