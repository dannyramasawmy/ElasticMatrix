function obj = setThickness(obj, layerIndex, layerValue)
    %% functionTemplateFile v1 date:  2019-01-15
    % 
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %       Copies the thickness (layerValue) to the corresponding
    %       layer (layerIndex);
    
    
    % assign multiple thicknesses
    for idx = 1:length(layerIndex)
        obj(layerIndex(idx)).thickness = layerValue((idx));
    end
    
end