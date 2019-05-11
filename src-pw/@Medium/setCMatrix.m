function obj = setCMatrix(obj, layerIndex, cMatrix)
    %% setCMat v1 date:  2019-01-15
    % 
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %       Sets the stiffness matrix (cMatrix) for the corresponding layer
    %       (layerIndex)
        
    % assign a single C_matrix at a time
        obj(layerIndex).cMat = cMatrix;
    
    
end