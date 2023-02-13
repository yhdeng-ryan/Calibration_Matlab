clear all;
close all;
clc;
load Data5

K_quat = p_robot;
C_quat = p_tracker;
%% <1> solving AX=YB, k_Tform = A, c_Tform = B, k*X = Y*c
% conver quaternion7 data to 4xN tform
[K_tformCell,K_tform] = Convert_quat7_to_tform(K_quat);
[C_tformCell,C_tform] = Convert_quat7_to_tform(C_quat);
[X,Y] = AXYB_shah(K_tform,C_tform);  % AXYB function caculates the 4xN tform.

%% <2> re-subsitute X,Y into k*X=Y*c to solve the prediction k, using tracker data c
n = size(K_quat);
for i= 1:n(1);
    Kpre_Cell(:,:,i) = (Y * C_tformCell(:,:,i))/ X;
end

%% <3>  fit BP. convert data to Vector form, all the data input should be Vector form
% fit Bernstein, input [K_eulXYZ, Kpre_eulXYZ, N], output [Coeff],

[K_V5] = Convert_quat7_to_vect5(K_quat); % convert 4x4xN tform to vector5 form,for K
[Kpre_V5] = Convert_tformCell_to_vect5(Kpre_Cell); %convert 4x4xN tform to vector5 form, for Kpre

para_K = paraBoxF(K_V5);  % define a little larger bound for scaleBox
para_Kp = paraBoxF(Kpre_V5);

Coef = ComputeC_5D(K_V5, Kpre_V5, 2, para_K,para_Kp);% Compute coef of BP, from K to Kpre

%% <4>  Apply BP. Correct the input data with a new input,taking Coef
[KpNew_V5] = BernCorrection_5D(Coef, K_V5, 2, para_K,para_Kp);
[KpNew_quat] = Convert_vect5_to_quat7(KpNew_V5);


% %% plot
% clc; clf;
% titles = ["X", "Y", "Z", "Roll", "Tilt"];
% 
% for i = 1:5
%     subplot(2,5,i)
%     plot(Kpre_V5(:, i))
%     hold on;
%     plot(K_V5(:,i))
%     plot(KpNew_V5(:, i))
%     title(titles(i))
%     if i==3
%         legend(["K pred", "K", "K cal."], "Location","best")
%     end
% 
%     subplot(2,5,i+5)
%     boxplot([Kpre_V5(:, i)-K_V5(:,i) Kpre_V5(:, i)-KpNew_V5(:, i)], ...
%         'Labels',{'K - K pred','K cal. - K_pred'})
% end

%% plot
figure()
sgtitle("Ray's Mixed Calibration")
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
    title(titles(i))
    xlabel(xlabels);
    ylabel(ylabels(i));
    if i==5
        legend(["Ground truth", "Original FK", "Calibrated FK"], "Location","best")
    end
    
    % plot box plot
    subplot(2,5,i+5)
    boxplot([Kpre_V5(:, i)-K_V5(:,i) Kpre_V5(:, i)-KpNew_V5(:, i)], ...
        'Labels',{'Original error','Calibrated error'})
    title(titles(i))
    ylabel(ylabels(i));
    grid on;
end




