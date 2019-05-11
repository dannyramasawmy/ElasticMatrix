function obj = setAngle(obj, angleRange)
    %% angleRange v1 date:  2019-01-15
    % 
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %   Vector of angles to calculate the model.
    
    % to avoid zero errord
    angleRange(angleRange == 0) = 0.01;
    
    % set the angle range
    obj.angle = angleRange;
end