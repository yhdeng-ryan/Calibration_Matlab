clear all;
close all;
clc;

fk_t = table2array(readtable("data/20221213_trans_only/CalibrationForwardKinematics.txt"));
ee_t = table2array(readtable("data/20221213_trans_only/CalibrationAtracsysEndEffectorDataAveraged.txt"));
ee_t(:, 1:3) = ee_t(:, 1:3) * 1000;
fk_r = table2array(readtable("data/20221213_rotate_only/CalibrationForwardKinematics_2022_12_13_16-53-53_-0500.txt"));
ee_r = table2array(readtable("data/20221213_rotate_only/CalibrationAtracsysEndEffectorDataAveraged_2022_12_13_16-53-53_-0500.txt"));
ee_r(:, 1:3) = ee_r(:, 1:3) * 1000;

%% <1> solving AX=YB, k_Tform = A, c_Tform = B, k*X = Y*c
% conver quaternion7 data to 4xN tform
[~,K_tform] = Convert_quat7_to_tform([fk_t; fk_r]);
[~,C_tform] = Convert_quat7_to_tform([ee_t; ee_r]);
[X,Y] = AXYB_shah(K_tform,C_tform);  % AXYB function caculates the 4xN tform.

%% Translation only
% [~,K_tform] = Convert_quat7_to_tform(fk_t);
% [~,C_tform] = Convert_quat7_to_tform(ee_t);
% [X,Y] = AXYB_shah(K_tform,C_tform);  % AXYB function caculates the 4xN tform.
%%
calibrate(fk_t, ee_t, X, Y, "Translation Only Calibration");

%% Rotation only
calibrate(fk_r, ee_r, X, Y, "Rotation Only Calibration");



function Coef = calibrate(K_quat, C_quat, X, Y, plot_title)
%% <2> re-subsitute X,Y into k*X=Y*c to solve the prediction k, using tracker data c

[C_tformCell,~] = Convert_quat7_to_tform(C_quat);
n = size(K_quat);
for i= 1:n(1)
    Kpre_Cell(:,:,i) = (Y * C_tformCell(:,:,i))/ X;
end

%% <3>  fit BP. convert data to Vector form, all the data input should be Vector form
% fit Bernstein, input [K_eulXYZ, Kpre_eulXYZ, N], output [Coeff],

[K_V5] = Convert_quat7_to_vect5(K_quat); % convert 4x4xN tform to vector5 form,for K
[Kpre_V5] = Convert_tformCell_to_vect5(Kpre_Cell); %convert 4x4xN tform to vector5 form, for Kpre

para_K = paraBoxF(K_V5);  % define a little larger bound for scaleBox
para_Kp = paraBoxF(Kpre_V5);

Coef = ComputeC_5D(K_V5, Kpre_V5, 2, para_K, para_Kp);% Compute coef of BP, from K to Kpre


%% <4>  Apply BP. Correct the input data with a new input,taking Coef
[KpNew_V5] = BernCorrection_5D(Coef, K_V5, 2, para_K, para_Kp);
[KpNew_quat] = Convert_vect5_to_quat7(KpNew_V5);

%% plot
figure()
sgtitle(plot_title,'fontsize',24)
titles = ["X", "Y", "Z", "Roll", "Tilt"];
ylabels = ["mm", "mm", "mm", "rad", "rad", ];
xlabels = "samples";
hold on

for i = 1:5
    % plot samples
    subplot(2,5,i)
    plot(Kpre_V5(:, i))
    hold on; grid on;
    plot(K_V5(:,i))
    plot(KpNew_V5(:, i))
    title(titles(i),'fontsize',18)
    xlabel(xlabels,'fontsize',18);
    ylabel(ylabels(i),'fontsize',18);
    ax = gca; ax.FontSize = 16; 
    if i==5
        legend(["Ground truth", "Original FK", "Calibrated FK"], "Location","best")
    end
    
    % plot box plot
    subplot(2,5,i+5)
    tmp_o = Kpre_V5(:, i)-K_V5(:,i);
    tmp_c = Kpre_V5(:, i)-KpNew_V5(:, i);
    boxplot([tmp_o tmp_c], ...
         'Labels',{'Original error', 'Calibrated error'});
    set(gca, 'ActivePositionProperty', 'position','FontSize',14)
    title(titles(i),'fontsize',18)
    ylabel(ylabels(i),'fontsize',18);
    xlabel(strcat( "std: ", num2str(std(tmp_o), '%.2e'), "          ", num2str(std(tmp_c), '%.2e') ))
    grid on;
end

end
