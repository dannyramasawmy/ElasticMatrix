function [ mediumLayer ] = getAcousticProperties( material )
    %% functionTemplateFile v1 date:  2019-01-15
    %
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %       Loads the material list and assigns the properties to the
    %       class attributes.
    
    materialList;
    
    %% ====================================================================
    %   ASSIGN OBJECT FIELDS
    % =====================================================================
    
    % get the material
    mediumLayer = Medium;
    % assign fields
    mediumLayer.name = material;
    
    % assign state
    try
        % check the state is a correct keyword
        switch allMaterialStruct.(material).state
            case {'Unknown','Vacuum','Gas','Liquid','Isotropic','Anisotropic'}
                mediumLayer.state = allMaterialStruct.(material).state;
            otherwise
                error('Layer state is not valid / defined');
        end
        
    catch
        warning(['Check material state : ',material])
        mediumLayer.state = 'Unknown';
    end
    
    % check state is valid
    
    
    % assign nedsity
    try
        mediumLayer.density =  allMaterialStruct.(material).rho;
    catch
        warning('Density not assigned')
        mediumLayer.density = 0;
    end
    
    % assign the stiffness matrix
    try
        % if the stiffness matrix is defined
        mediumLayer.stiffnessMatrix = allMaterialStruct.(material).stiffnessMatrix;
    catch
        % evaluate string for c, density
        c = allMaterialStruct.(material).c;
        % evaluate string for cs, shear speed
        cs = allMaterialStruct.(material).cs;
        % evaluate string for rho, density
        rho = allMaterialStruct.(material).rho;
        mediumLayer.stiffnessMatrix = Medium.soundSpeedDensityConversion(c, cs, rho);
    end
    
    
    
end