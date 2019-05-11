function [ closest, idx, difference ] = findClosest(xList,x)
    %% findClosest
    %
    % Author    :   Danny Ramasawmy
    %               rmapdrr@ucl.ac.uk
    % Date      :   2017-03-29  -   created
    %
    %
    % Description
    %   Find the closest value in Xlist to x
    %   returns the closest value and the index
    
    % take x away and find smallest different
    [difference, idx] = min(abs((xList - x)));
    closest = xList(idx);
    
end

