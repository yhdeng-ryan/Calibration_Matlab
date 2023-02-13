clear all;
close all;
clc;
load Data5

K_quat = p_robot;
C_quat = p_tracker;
 %% <1> solving AX=YB to have X,Y, (k_Tform = A, c_Tform = B, k*X = Y*c)
 % conver quaternion7 data to 4xN tform 
 [K_tformCell,K_tform] = Convert_quat7_to_tform(K_quat);
 [C_tformCell,C_tform] = Convert_quat7_to_tform(C_quat);
 [X,Y] = AXYB_shah(K_tform,C_tform);  % AXYB function caculates the 4xN tform.

 %% <2> re-subsitute X,Y into k*X=Y*c to solve the prediction 'Kpre' and  'dK'
 n = size(K_quat);
 % solve 'Kpre', Kpre = inv(X)*Y*C
 for i= 1:n(1);
Kpre_Cell(:,:,i) = (Y * C_tformCell(:,:,i))/ X;
 end
 % solve 'dK',  kPre = k * dk
 for i= 1:n;
dK_tformCell(:,:,i) = K_tformCell(:,:,i)\Kpre_Cell(:,:,i);
 end

%% <3>  fit BP. convert data to Vector form
% fit Bernstein, input [K_vect5, dK_vect6, N], output [Coeff]. from K to dK
[K_vect5] = Convert_tformCell_to_vect5(K_tformCell); 
[dK_vect6] = Convert_tformCell_to_vectXYZ6(dK_tformCell); % for Kpre

para_K = paraBoxF(K_vect5);  % define a little larger bound for scaleBox
para_dK = paraBoxF(dK_vect6);

Coef = ComputeC_5D(K_vect5, dK_vect6, 2, para_K,para_dK);% Compute coef of BP
%% <4>  Apply BP. Correct the input data with a new input,taking Coef, output
% input (Coef , Knew, N). output [corrected dK]
[dK_vect6BP] = BernCorrection_5D(Coef, K_vect5, 2, para_K,para_dK);

% re-compute KpreNew = k * dKbp
[dK_CellBP] = Convert_vectXYZ6_to_tformCell(dK_vect6BP); % convert dk(1,2,3,4,5,6) to tform
for i= 1:n;
KpreNew_Cell(:,:,i) = K_tformCell(:,:,i)*dK_CellBP(:,:,i);
end
[KpNew_quat] = Convert_tform_to_quat7(KpreNew_Cell); % output the quat7 form KpreNew







