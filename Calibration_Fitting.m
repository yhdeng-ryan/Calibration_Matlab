function [FK_original, FK_calibrated, FK_groundtruth] = Calibration_Fitting(fitting_FK, fitting_EE, order, Coef, X, Y, para_K, para_Kp)

% fitting data
K_quat = fitting_FK;
K_V5 = Convert_quat7_to_vect5(K_quat);
FK_original = K_V5;
FK_calibrated = BernCorrection_5D(Coef, K_V5, order, para_K, para_Kp);

% ground truth
C_quat = fitting_EE;
[C_tformCell,~] = Convert_quat7_to_tform(C_quat);
n = size(C_quat);
for i= 1:n(1)
    Kpre_Cell(:,:,i) = (Y * C_tformCell(:,:,i))/ X;
end
FK_groundtruth = Convert_tformCell_to_vect5(Kpre_Cell); %convert 4x4xN tform to vector5 form, for Kpre

end