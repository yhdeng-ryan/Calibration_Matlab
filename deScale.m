%% deScale: counter the scale process
function [w] = deScale(q,qmin,qmax)
	[rows, cols] = size(q);
	w = q .* repmat((qmax - qmin),1,cols) + repmat(qmin,1,cols);
end