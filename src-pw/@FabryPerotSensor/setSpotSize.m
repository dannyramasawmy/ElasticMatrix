function obj = setSpotSize(obj, spotDiameter)
    %% setSpotSize v1 date:  2019-01-15
    %
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %  Set the interrogation laser spot diameter.
    
    % set to 0;
    obj.spotSize = 0;
    
    % check it is a double
    try
        if class(spotDiameter) == 'double'
            % set the interrogation spot diameter range
            obj.spotSize = spotDiameter;
        end
    catch
        warning('Incorrect input')
    end
    
end