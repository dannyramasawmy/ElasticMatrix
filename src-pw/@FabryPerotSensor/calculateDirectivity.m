function [obj] = calculateDirectivity(obj)
    %% calculateDirectivity v1 date:  2019-01-15
    % 
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %   Calculates the directivity of a FabryPerot interferometer       
    %
    
    % this function calculates the directivity
    disp('... Calculating directivity ...')
    
    obj.calculate;
    
    % difference in vertical displacement of the mirrors
    directivity = ...
        obj.zDisplacement(obj.mirrorLocations(1)).upper - ...
        obj.zDisplacement(obj.mirrorLocations(2)).upper;    
    
    % ## Need to add optics model ##
    warning('### ADD OPTICAL BIREFRINGENCE ###')
    warning('## ADD SPOT SIZE')
    warning('## ADD SPOT TYPE')
      
    % assign to temporary variable for fast plotting
    obj.directivity = directivity;
    
    disp('... Finished calculating ...')
    
end
