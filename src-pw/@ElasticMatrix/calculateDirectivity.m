function [directivity, obj] = calculateDirectivity(obj, mirrorLocation)
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
    
    % difference in vertical displacement of the mirrors
    directivity = ...
        obj.zDisplacement(mirrorLocation(1)).upper - ...
        obj.zDisplacement(mirrorLocation(2)).upper;    
    
    % ## Need to add optics model ##
    disp('### ADD OPTICAL BIREFRINGENCE ###')
      
    % assign to temporary variable for fast plotting
    obj.tempFeature = directivity;
    
    disp('... Finished calculating ...')
    
end