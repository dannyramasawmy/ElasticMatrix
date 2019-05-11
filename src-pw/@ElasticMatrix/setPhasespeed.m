function obj = setPhasespeed(obj, phasespeedRange)
    %% setPhasespeed v1 date:  2019-01-15
    % 
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %   Vector of phasespeeds to calculate the model.
    
    
    % avoid zero error
    phasespeedRange(phasespeedRange == 0) = 0.01;
    
    % set range of phasespeeds
    obj.phasespeed = phasespeedRange;
    
end