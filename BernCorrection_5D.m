%% ND_Maping is the function to correct distortion. 
% here it is the 5-dimensional Bernstein-polyn correction. All data input should be N*5 matrix.

% Input: [Coef, p_newRawData, N, paraBox]
%        p_newRawData is the new dataset to be corrected by using Bernstein-polyn
%        N is the orders of bernstein polynomials. should not be higher than 5 or 6.  
%        paraBox is the boundary parameters of the ScaleBox, see the function [paraBox]
   
% Output: [p_corrected]
%         p_corrected is the corrected data with input p_newRawData, using the Bernstein Coefficient from training (p_distortedData, q_groundTruth)
%
function [p_corrected] = BernCorrection_5D(Coef,p_newRawData,N,paraP,paraQ)
 % scale new data, but use previous params qmin,qmax to keep alignment.
    
     pmax  = paraP(:,1); % entire data, pmax for distortedData
     pmin  = paraP(:,2);
     qmax  = paraQ(:,1); % entire data, qmax for groundTruth
     qmin  = paraQ(:,2);
     
    p2 = p_newRawData';
	u2 = scaleToBox(p2,pmin,pmax);  
    
 %% compute Bernstein polynomials again. compute F, again.
	
     Bu2 = bernsteinMatrix(N,u2(1,:));
     Bv2 = bernsteinMatrix(N,u2(2,:));	
     Bx2 = bernsteinMatrix(N,u2(3,:));       
	 By2 = bernsteinMatrix(N,u2(4,:));
	 Bz2 = bernsteinMatrix(N,u2(5,:));
     
    [dim2,Npoints2] = size(p2);
	for j = 1:Npoints2;                        
        tempN1(:,:,j) = By2(j,:)' * Bz2(j,:);
		bigRowN1(j,:) = reshape(tempN1(:,:,j)',1,[]);
        
        tempN2(:,:,j) = Bx2(j,:)' * bigRowN1(j,:);
        bigRowN2(j,:) = reshape(tempN2(:,:,j)',1,[]);
        
        tempN3(:,:,j) = Bv2(j,:)'*bigRowN2(j,:);
        bigRowN3(j,:) = reshape(tempN3(:,:,j)',1,[]);
        
        tempN4(:,:,j) = Bu2(j,:)'*bigRowN3(j,:);
        bigRowN4(j,:) = reshape(tempN4(:,:,j)',1,[]);
                
    end
     Fnew = bigRowN4;
    % use the previous Coef to correct. use the same params to descale.
	vNew = (Fnew * Coef)';                          
	p_corrected = deScale(vNew,qmin,qmax);
    p_corrected = p_corrected';
end
