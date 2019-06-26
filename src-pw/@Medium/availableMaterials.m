function [ ] = availableMaterials()
    %% availableMaterials v1 date: 2016-10-11
    % 
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %       Run script to load all materials as materialtV structure
    %       Prints the available materials for input to the
    %       generateMaterialStructure function. 
    

    % try run script
    try
        materialList
    catch
        error('Cannot find material Input')
    end
    
    % store as new variable
    mats = fieldnames(allMaterialStruct);
    
    % clear temporary variable
    clear('allMaterialStruct');
    
    % convert the cell to a Table class
    T = cell2table(mats);
    
    % change the properties of the table class name
    T.Properties.VariableNames = {'currentMaterials'};
    
    % display the table
    disp(sortrows(T));
    
end

