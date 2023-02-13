%%%% The steps are like
<1> [X,Y] = AXYB(K, C) to solve X,Y   (K, C are input rob_pos and trac_pos)
<2> [Kpre] = Y*C*inv(X) to solve Kpre  (Kpre is the prediction, resub X and Y)
<3> [Coef] = Fit_Bernstein(K, Kpre, N, para) 
<4> [KpreNew] = Apply_Bernsein(Coef, Knew, N, para)
(N is the degree, para is the parameter of scalebox, made a bit larger)

%%%% there are two main tests,run "TeseMain1.m" and "TeseMain2.m" 
% TestMain1 is the direct way fiting from K to Kpre, like above, given input [K, Kpre], output [Coef]. it means given nominal K, tell where i am. vise versa, switch <3> as [Coef] = Fit_Bernstein(Kpre, K, N, para) 

% TestMain2 is fitting from K to dK. In <2> Add a step like 'Kpre = K*dK' to solve dK. In <3> it should be [Coef] = Fit_Bernstein(K, dK). In <4> it is to compute [dKnew] = Apply_Bernsein(Coef, Knew). Finaly, re-compute 'KpreNew = K * dKnew'. 

%% TestMain1 is more fast, effective and easier, TeseMain2 is a bit complicated. they have very close accuracy. You can try TestMain1 to comply motion firstly.

%% In AXYB part, there are two ways named "AXYB_shah.m" and "AXYB_li.m", Basically "AXYB_shah.m" is OK and effective and used in the codes. 'AXYB_li.m' is an alternative may have a bit better accuracy.


"ComputeC_5D.m"-- 5-dimensional Bernstein-polyn. All data input should be N*6 matrix.  Output: [Coef]

"BernCorrection_5D.m"--  Input [Coef, p_newRawData, N, paraBox], Output [p_corrected]

there are also two function with suffix "6D". it means the data input should be N*5 data with 5 Dof or 6Dof. 

"AXYB_shah.m"---Solves the problem AX=YB

"splitData.m"---split data into 2 sets, see function, there is an example

"convert_vectXYZ6_to_tform.m"
there are many functions named with "convert XXXXX". they just convert the data to different forms
e.g the AXYB is implented in 4xM form, the BP-fitting is vector form, the input data is quaternion form
"tform"  means the homogeneous matrix form, frame form with 4xN, 4 rows and N columns, N is 4, 8, 12..with times of 4.
"tformCell" means the 4xN homogeneous matrix is save as 4*4*M cell in matlab, N=4*M
"vectXYZ6"  means the 6DOF data [1,2,3,4,5,6], the first 3 is translation.e.g dK
"vect5"  means the 5DOF data [1,2,3,4,5]. e.g K, Kpre
"quat7" means the quaternion form with [1,2,3,4,5,6,7], the first 3 is translation.

