%% input p, output bound of box, p and q are N*3 data
% This function just give the bounds of the data, for ScaleToBox
% we can make it a bit larger bound by changing the parameter 0.0001
function [para] = paraBoxF(p)
     p = p';
    pmax = max(p,[],2)+0.1;             % find max bound for data p, 0.0001 can be changed depending on the dataset 
    pmin = min(p,[],2)-0.1;             % find min bound for data p
    para(:,1) = pmax;
    para(:,2) = pmin;
end

