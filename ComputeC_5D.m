% here it is the 5-dimensional Bernstein-polyn. All data input should be N*5matrix.

% Input: [p_distortedData. q_groundTruth, N, paraBox]
%        p_distortedData and q_groundTruth are used for traninng to get a Coeffient.
%        N is the orders of bernstein polynomials. should not be higher than 5 or 6.  
%        paraBox is the boundary parameters of the ScaleBox, see the function [paraBox]
   
% Output: [Coef]
%         Coef is the Coefficient matrix.depending on the different order.

%% Bernstein coef 

function [Coef] = ComputeC_5D(p_distortedData,q_groundTruth,N,paraP,paraQ)
    
    p = p_distortedData';  % convert p, q N*5 to 5*N form, the following is under 6*N form
    q = q_groundTruth'; 
   %% find the bound,   scaletobox

     pmax  = paraP(:,1); % entire data, pmax for distortedData
     pmin  = paraP(:,2);
     qmax  = paraQ(:,1); % entire data, qmax for groundTruth
     qmin  = paraQ(:,2);
     
     u = scaleToBox(p,pmin,pmax); % distortedData,after scale, u is 5x5000 
     v = scaleToBox(q,qmin,qmax); % groundTruth, after scale, v is 5x5000 
	
    %% compute Bernstein-polyn using built-in function in MATLAB. each B gives me Npoints x (5+1) mat
	
    Bu = bernsteinMatrix(N,u(1,:));
    Bv = bernsteinMatrix(N,u(2,:));
    Bx = bernsteinMatrix(N,u(3,:)); 
    By = bernsteinMatrix(N,u(4,:));
    Bz = bernsteinMatrix(N,u(5,:)); % for N=5, Bz is 6x5000 matrix if there is 5000 data, each row is 6x1 for 1 point
	%% compute F. The reshape and transpose to achieve this sequence in subscript
	% 000, 001, 002, ..., 005, 010, 011, ..., 015, 020, 021, ..., 555
    [dim,Npoints] = size(q);   
	for i = 1:Npoints;
		temp1(:,:,i) = By(i,:)' * Bz(i,:); % Bz(i,:) is 1x6, By(i,:)' is 6x1, temp is 6x6x5000
		bigRow1(i,:) = reshape(temp1(:,:,i)',1,[]); % bigRow1 is 5000x36
        
        temp2(:,:,i) = Bx(i,:)' * bigRow1(i,:);         % temp2 is 6x36x5000
        bigRow2(i,:) = reshape(temp2(:,:,i)',1,[]);     % bigRow2 is 5000x216
        
        temp3(:,:,i) = Bv(i,:)'*bigRow2(i,:);           % temp3 is 6x216x5000
        bigRow3(i,:) = reshape(temp3(:,:,i)',1,[]);     % bigRow3 is 5000x1296
        
        temp4(:,:,i) = Bu(i,:)'*bigRow3(i,:);           % temp4 is 6x1296x5000
        bigRow4(i,:) = reshape(temp4(:,:,i)',1,[]);     % bigRow4 is 5000x7776
        
    end
    F = bigRow4;    % F is 5000x7776
   %compute Coeff C which will be used later.
	v = v';            % v is 5x5000, v' is 5000*Number, Number is the dimension, could be 5 or 6 
	Coef = F\v;           % F(5000x7776) * Coef = v(5000xNumber), Coef should be (7776xNumber)
   
   % The above computes Coeffecients C and parameters pmin,pmax,qmin,qmax, with the input (p_groundTruth,q_distortedData)
   % The below starts the correction procedure. when input a new set of distored data, can give a correct output.
   % The computation will use Coeffecients C and parameters pmin,pmax,qmin,qmax before. 
       
end



