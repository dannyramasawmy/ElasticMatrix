function obj = setDensity(obj, layerIndex, layerDensity)
    %% setDensity v1 date:  2019-01-15
    % 
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %       Sets the density of the layer (layerIndex) to the corresponding
    %       value in layerDensity.
    
    % loop over the number of indices and change the values
    for idx = 1:length(layerIndex)
      obj(layerIndex(idx)).density = layerDensity(idx);  
    end
    
    
end