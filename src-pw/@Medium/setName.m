function obj = setName(obj, layerIndex, layerName)
    %% setName v1 date: 2019-01-15
    % 
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %       Sets the name (layerName) of the layer (layerIndex) in the medium.
    
    obj(layerIndex).name = layerName;
    
end