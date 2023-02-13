function [Coef, X, Y, para_K, para_Kp] = Calibration_Training(HEC_data_FK, HEC_data_EE, train_FK, train_EE, order)

% <1> solving AX=YB, k_Tform = A, c_Tform = B, k*X = Y*c
% conver quaternion7 data to 4xN tform
[~,K_tform] = Convert_quat7_to_tform(HEC_data_FK);
[~,C_tform] = Convert_quat7_to_tform(HEC_data_EE);
[X,Y] = AXYB_shah(K_tform,C_tform);  % AXYB function caculates the 4xN tform.


K_quat = train_FK;
C_quat = train_EE;

% <2> re-subsitute X,Y into k*X=Y*c to solve the prediction k, using tracker data c

[C_tformCell,~] = Convert_quat7_to_tform(C_quat);
n = size(K_quat);
for i= 1:n(1)
    Kpre_Cell(:,:,i) = (Y * C_tformCell(:,:,i))/ X;
end

% <3>  fit BP. convert data to Vector form, all the data input should be Vector form
% fit Bernstein, input [K_eulXYZ, Kpre_eulXYZ, N], output [Coeff],

[K_V5] = Convert_quat7_to_vect5(K_quat); % convert 4x4xN tform to vector5 form,for K
[Kpre_V5] = Convert_tformCell_to_vect5(Kpre_Cell); %convert 4x4xN tform to vector5 form, for Kpre

para_K = paraBoxF(K_V5);  % define a little larger bound for scaleBox
para_Kp = paraBoxF(Kpre_V5);

Coef = ComputeC_5D(K_V5, Kpre_V5, order, para_K, para_Kp);% Compute coef of BP, from K to Kpre
end