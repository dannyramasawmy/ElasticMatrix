function obj = setSpotSize(obj, spot_diameter)
    %% setSpotSize v1 date:  2019-01-15
    %
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %  Set the interrogation laser spot diameter.
    
    % set to 0;
    obj.spot_size = 0;
    
    % check it is a double
    try
        if class(spot_diameter) == 'double'
            % set the interrogation spot diameter range
            obj.spot_size = spot_diameter;
        end
    catch
        warning('Incorrect input')
    end
    
end