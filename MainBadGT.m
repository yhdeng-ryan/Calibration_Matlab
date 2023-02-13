clear all;
% close all;
clc;
%% old dataset
fk_t = table2array(readtable("data/20221213_trans_only/CalibrationForwardKinematics.txt"));
ee_t = table2array(readtable("data/20221213_trans_only/CalibrationAtracsysEndEffectorDataAveraged.txt"));
ee_t(:, 1:3) = ee_t(:, 1:3) * 1000;
fk_r = table2array(readtable("data/20221213_rotate_only/CalibrationForwardKinematics_2022_12_13_16-53-53_-0500.txt"));
ee_r = table2array(readtable("data/20221213_rotate_only/CalibrationAtracsysEndEffectorDataAveraged_2022_12_13_16-53-53_-0500.txt"));
ee_r(:, 1:3) = ee_r(:, 1:3) * 1000;

order = 2;

[Coef, X, Y, para_K, para_Kp] = Calibration_Training([fk_t; fk_r], [ee_t; ee_r], fk_r, ee_r, order);

[FK_original, FK_calibrated, FK_groundtruth] = Calibration_Fitting(fk_r, ee_r, order, Coef, X, Y, para_K, para_Kp);

% bad ground truth
data = [FK_original(:,1:3); FK_groundtruth(:,1:3)];
axis_limit = [min(data(:,1)) max(data(:,1)) min(data(:,2)) max(data(:,2)) min(data(:,3)) max(data(:,3))];

figure(); box on; axis equal; grid on; hold on;
scatter3(FK_original(:,1), FK_original(:,2), FK_original(:,3), 100, 'filled', 'Color', 'b', 'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.8)
xlabel("X (mm)",'FontSize', 15); ylabel("Y (mm)",'FontSize', 15); zlabel("Z (mm)",'FontSize', 15);


scatter3(FK_groundtruth(:,1), FK_groundtruth(:,2), FK_groundtruth(:,3), 100, 'filled', 'Color', 'r', 'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.8)
xlabel("X (mm)",'FontSize', 15); ylabel("Y (mm)",'FontSize', 15); zlabel("Z (mm)",'FontSize', 15);

title('Old dataset','FontSize',20)
legend({'original FK', 'ground truth FK'}, 'FontSize',15)

%% new dataset
fk_t = table2array(readtable("data/20230210_trans_only/CalibrationForwardKinematics_2023_02_10_15-53-18_-0500.txt"));
ee_t = table2array(readtable("data/20230210_trans_only/CalibrationAtracsysEndEffectorDataAveraged_2023_02_10_15-53-18_-0500.txt"));
ee_t(:, 1:3) = ee_t(:, 1:3) * 1000;
fk_r = table2array(readtable("data/20230210_rotate_only/CalibrationForwardKinematics_2023_02_10_14-04-04_-0500.txt"));
ee_r = table2array(readtable("data/20230210_rotate_only/CalibrationAtracsysEndEffectorDataAveraged_2023_02_10_14-04-04_-0500.txt"));
ee_r(:, 1:3) = ee_r(:, 1:3) * 1000;

[Coef, X, Y, para_K, para_Kp] = Calibration_Training([fk_t; fk_r], [ee_t; ee_r], fk_r, ee_r, order);

[FK_original, FK_calibrated, FK_groundtruth] = Calibration_Fitting(fk_r, ee_r, order, Coef, X, Y, para_K, para_Kp);

% bad ground truth
data = [FK_original(:,1:3); FK_groundtruth(:,1:3)];
axis_limit = [min(data(:,1)) max(data(:,1)) min(data(:,2)) max(data(:,2)) min(data(:,3)) max(data(:,3))];

figure(); box on; axis equal; grid on; hold on;
scatter3(FK_original(:,1), FK_original(:,2), FK_original(:,3), 100, 'filled', 'Color', 'b', 'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.8)
xlabel("X (mm)",'FontSize', 15); ylabel("Y (mm)",'FontSize', 15); zlabel("Z (mm)",'FontSize', 15);


scatter3(FK_groundtruth(:,1), FK_groundtruth(:,2), FK_groundtruth(:,3), 100, 'filled', 'Color', 'r', 'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.8)
xlabel("X (mm)",'FontSize', 15); ylabel("Y (mm)",'FontSize', 15); zlabel("Z (mm)",'FontSize', 15);

title('New dataset','FontSize',20)
legend({'original FK', 'ground truth FK'}, 'FontSize',15)
