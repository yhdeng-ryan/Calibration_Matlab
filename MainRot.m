clear all;
% close all;
clc;

fk_t = table2array(readtable("data/20221213_trans_only/CalibrationForwardKinematics.txt"));
ee_t = table2array(readtable("data/20221213_trans_only/CalibrationAtracsysEndEffectorDataAveraged.txt"));
ee_t(:, 1:3) = ee_t(:, 1:3) * 1000;
fk_r = table2array(readtable("data/20221213_rotate_only/CalibrationForwardKinematics_2022_12_13_16-53-53_-0500.txt"));
ee_r = table2array(readtable("data/20221213_rotate_only/CalibrationAtracsysEndEffectorDataAveraged_2022_12_13_16-53-53_-0500.txt"));
ee_r(:, 1:3) = ee_r(:, 1:3) * 1000;

% fk_t = table2array(readtable("data/20230210_trans_only/CalibrationForwardKinematics_2023_02_10_15-53-18_-0500.txt"));
% ee_t = table2array(readtable("data/20230210_trans_only/CalibrationAtracsysEndEffectorDataAveraged_2023_02_10_15-53-18_-0500.txt"));
% ee_t(:, 1:3) = ee_t(:, 1:3) * 1000;
% fk_r = table2array(readtable("data/20230210_rotate_only/CalibrationForwardKinematics_2023_02_10_14-04-04_-0500.txt"));
% ee_r = table2array(readtable("data/20230210_rotate_only/CalibrationAtracsysEndEffectorDataAveraged_2023_02_10_14-04-04_-0500.txt"));
% ee_r(:, 1:3) = ee_r(:, 1:3) * 1000;

%% Train-test-split
test_ratio = .20;

idx_t = 1:size(fk_t,1) > size(fk_t,1)*test_ratio;
idx_t = idx_t(randperm(length(idx_t)));
idx_t(1) = 1;
% idx_t = ones(1,size(fk_t,1));
% idx_t(2:round(1/test_ratio):size(fk_t,1)) = 0;
fk_t_train = fk_t(idx_t==1, :); fk_t_test = fk_t(idx_t==0, :);
ee_t_train = ee_t(idx_t==1, :); ee_t_test = ee_t(idx_t==0, :);

idx_r = 1:size(fk_r,1) > size(fk_r,1)*test_ratio;
idx_r = idx_r(randperm(length(idx_r)));
idx_t(1) = 1;
% idx_r = ones(1,size(fk_r,1));
% idx_r(2:round(1/test_ratio):size(fk_r,1)) = 0;
fk_r_train = fk_r(idx_r==1, :); fk_r_test = fk_r(idx_r==0, :);
ee_r_train = ee_r(idx_r==1, :); ee_r_test = ee_r(idx_r==0, :);


%% Calibration
% order of BPoly
order = 2;

title_name = 'Rotation only dataset';

% training
[Coef, X, Y, para_K, para_Kp] = Calibration_Training([fk_t_train; fk_r_train], [ee_t_train; ee_r_train], fk_r_train, ee_r_train, order);

% fitting
[FK_original, FK_calibrated, FK_groundtruth] = Calibration_Fitting(fk_r_test, ee_r_test, order, Coef, X, Y, para_K, para_Kp);

%% Errors
% rad to degree
FK_original(:,4:5) = FK_original(:,4:5) * 180 / pi;
FK_calibrated(:,4:5) = FK_calibrated(:,4:5) * 180 / pi;
FK_groundtruth(:,4:5) = FK_groundtruth(:,4:5) * 180 / pi;

err_original = abs(FK_original - FK_groundtruth);
err_calibrated = abs(FK_calibrated - FK_groundtruth);

err_original_statistic = [mean(err_original); std(err_original); max(err_original)]
err_calibrated_statistic = [mean(err_calibrated); std(err_calibrated); max(err_calibrated)]

%% plot error statistics
MainPlotBox;

%% plot error scatter
MainPlotScatter;




