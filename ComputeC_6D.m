% here it is the 6-dimensional Bernstein-polyn. All data input should be N*6 matrix.

% Input: [p_distortedData. q_groundTruth, N, paraBox]

%% Bernstein coef 

function [Coef] = ComputeC_6D(p_distortedData,q_groundTruth,N,paraBox)
    
    p = p_distortedData';  % convert p, q N*6 to 6*N form, the following is under 6*N form
    q = q_groundTruth'; 
   %% find the bound,   scaletobox

     pmax  = paraBox(:,1); % entire data, pmax for distortedData
     pmin  = paraBox(:,2);
     qmax  = paraBox(:,1); % entire data, qmax for groundTruth
     qmin  = paraBox(:,2);
     
     u = scaleToBox(p,pmin,pmax); % distortedData,after scale
     v = scaleToBox(q,qmin,qmax); % groundTruth, after scale
	
    %% compute Bernstein-polyn using built-in function in MATLAB. each B gives me Npoints x (5+1) mat
	Bw = bernsteinMatrix(N,u(1,:));
    Bu = bernsteinMatrix(N,u(2,:));
    Bv = bernsteinMatrix(N,u(3,:));
    Bx = bernsteinMatrix(N,u(4,:)); 
    By = bernsteinMatrix(N,u(5,:));
    Bz = bernsteinMatrix(N,u(6,:));
	%% compute F. The reshape and transpose to achieve this sequence in subscript
	% 000, 001, 002, ..., 005, 010, 011, ..., 015, 020, 021, ..., 555
    [dim,Npoints] = size(q);   
	for i = 1:Npoints;
		temp1(:,:,i) = By(i,:)' * Bz(i,:);
		bigRow1(i,:) = reshape(temp1(:,:,i)',1,[]);
        
        temp2(:,:,i) = Bx(i,:)' * bigRow1(i,:);
        bigRow2(i,:) = reshape(temp2(:,:,i)',1,[]);
        
        temp3(:,:,i) = Bv(i,:)'*bigRow2(i,:);
        bigRow3(i,:) = reshape(temp3(:,:,i)',1,[]);
        
        temp4(:,:,i) = Bu(i,:)'*bigRow3(i,:);
        bigRow4(i,:) = reshape(temp4(:,:,i)',1,[]);
        
        temp5(:,:,i) = Bw(i,:)'*bigRow4(i,:);
        bigRow5(i,:) = reshape(temp5(:,:,i)',1,[]);
    end
    F = bigRow5;
   %compute Coeff C which will be used later.
	v = v';             
	Coef = F\v;           
   
   % The above computes Coeffecients C and parameters pmin,pmax,qmin,qmax, with the input (p_groundTruth,q_distortedData)
   % The below starts the correction procedure. when input a new set of distored data, can give a correct output.
   % The computation will use Coeffecients C and parameters pmin,pmax,qmin,qmax before. 
       
end



