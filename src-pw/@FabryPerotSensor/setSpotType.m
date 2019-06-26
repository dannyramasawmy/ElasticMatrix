function obj = setSpotType(obj, spotType)
    %% setFrequency v1 date:  2019-01-15
    %
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %   Choose whether the interrogation is a Guassian, collimated beam.
    
    % format check on string
    spotTypeFormatted = stringCheck(spotType);
    
    switch spotTypeFormatted
        case {'gaussian'}
            obj.spotType = 'gaussian';
        case {'collimated'}
            obj.spotType = 'collimated';
        otherwise
            obj.spotType = 'none';
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