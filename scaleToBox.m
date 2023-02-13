%% scaleToBox: scale the input into a bounding box [0,1]
% Input q with its max and min element,output u with all elements bounding in [0,1]
function [u] = scaleToBox(q, qmin, qmax)
	[rows, cols] = size(q);
	u = (q - repmat(qmin,1,cols)) ./ repmat((qmax - qmin),1,cols);
end