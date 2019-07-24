function obj = setSpotType(obj, spot_type)
    %% setFrequency v1 date:  2019-01-15
    %
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %   Choose whether the interrogation is a Guassian, collimated beam.
    
    % format check on string
    spotTypeFormatted = stringCheck(spot_type);
    
    switch spotTypeFormatted
        case {'gaussian'}
            obj.spot_type = 'gaussian';
        case {'collimated'}
            obj.spot_type = 'collimated';
        otherwise
            obj.spot_type = 'none';
    end
    
end

function spotTypeFormatted = stringCheck(stringInput)
    %% setFrequency v1 date:  2019-01-15
    %
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %   Format the sting.
    
    defaultOutput = 0;
    
    if ischar(stringInput)
        % set string to lower case
        spotTypeFormatted = lower(stringInput);
    else       
        % incorrect input
        defaultOutput = 1;
    end
        
    % there is an error in the string
    if defaultOutput == 1
        spotTypeFormatted = 0;
    end
end