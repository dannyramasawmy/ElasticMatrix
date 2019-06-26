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

    if size(cMatrix) == [6 6]
        % assign a single C_matrix at a time
        obj(layerIndex).cMat = cMatrix;
    else
        warning('Failed to assign c-matrix, incorrect dimensions. ')
        obj(layerIndex).cMat = eye(6);
    end
    
    
    
end

