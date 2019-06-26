function obj = setMirrorLocations(obj, interfaceLocations)
    %% setMirrorLocations v1 date:  2019-01-15
    %
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %   Set the interface locations of the mirrors. Exects a vector of two
    %   integers which is the interface of the first and last mirror.
    
    % get the number of layers
    numberLayers = length(obj.medium);
    
    % check that the interface locations are integers
    boolVar = [...
        checkInterfaceInput(interfaceLocations(1), numberLayers), ...
        checkInterfaceInput(interfaceLocations(2), numberLayers)];
        
    autoAssignFlag = 0;
    % assign mirror interfaces
    if boolVar == [1 1]
        % check inputs are in ascending order and assign
            obj.mirrorLocations = ...
                sort([interfaceLocations(1), interfaceLocations(2)]);
    else
        autoAssignFlag = 1;
    end
    
    
    if autoAssignFlag == 1
        % auto assign mirror interfaces
        warning('Incorrect inputs, the mirror locations will be automatically assigned')
        
        % check number of layers is more than three - assign first and last
        % interfaces
        if numberLayers > 2
            obj.mirrorLocations = [1, numberLayers-1];
        else
            error('obj.medium must be at least three layers');
        end
    end
    
    
end

function [logicalOutput] = checkInterfaceInput(interfaceLocation, numberLayers)
    %% checkInterfaceInput v1 date:  2019-01-15
    %
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %   Checks the interface choice is correct.
    
    logicalOutput = 1;
    
    % check interface location is more than 0
    if interfaceLocation > 0
        logicalOutput = 1 * logicalOutput;
    else
        logicalOutput = 0 * logicalOutput;
    end
    
    % check interface location is less than the maximum number of layers
    if interfaceLocation < numberLayers
        logicalOutput = 1 * logicalOutput;
    else
        logicalOutput = 0 * logicalOutput;
    end
    
    % check that it is an integer
    if floor(interfaceLocation) == interfaceLocation
        logicalOutput = 1 * logicalOutput;
    else
        logicalOutput = 0 * logicalOutput;
    end
 
end