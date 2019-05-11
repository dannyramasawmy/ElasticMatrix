function obj = setMedium(obj, medium)
    %% functionTemplateFile v1 date:  2019-01-15
    % 
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %   Assigns a medium class to the medium attribute;
    
    try
        % check the class is correct
        if class(medium) == 'Medium'
            obj.medium = medium;
        end
        
        if ~isempty((obj.partialWaveAmplitudes))
            % delete irrelevant fields
            warning('All class fields must be recalculated');
            obj.partialWaveAmplitudes       = [];
            obj.xDisplacement               = [];
            obj.zDisplacement               = [];
            obj.sigmaZZ                     = [];
            obj.sigmaXZ                     = [];
        end
        
    catch
        warning('obj.medium was not changed, incorrect input');
    end
    
    
    
    
end
