function [ medium_layer ] = getAcousticProperties( material )
    %GETACOUSTICPROPERTIES Returns material properties for a material.
    %
    % DESCRIPTION
    %   GETACOUSTICPROPERTIES(material) takes an input string corresponding
    %   to a material defined in materialList.m and returns a Medium object
    %   of size [1, 1] with the attributes assigned.
    %
    % USEAGE
    %   medium_object = Medium.getAcousticProperties('materialName');
    %
    % INPUTS 
    %   material        - A string corresponding to a predefined material.
    %
    % OPTIONAL INPUTS
    %   []              - There are no optional inputs. []
    %
    % OUTPUTS
    %   obj.name                - Name of the material.
    %   obj.thickness           - Thickness of the layer.    [m]
    %   obj.density             - Density.                  [kg/m^3]
    %   obj.stiffness_matrix    - 6 X 6 stiffness matrix.   [Pa]
    %
    % DEPENDENCIES
    %   materialList() defines all the predefined materials
    %   [all_materials] = materialList();
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - January      - 2019
    %   last update     - 03 - September    - 2019
    %
    % This file is part of the ElasticMatrix toolbox.
    % Copyright (c) 2021 Danny Ramasawmy.
    %
    % This file is part of ElasticMatrix. ElasticMatrix is free software:
    % you can redistribute it and/or modify it under the terms of the GNU
    % Lesser General Public License as published by the Free Software
    % Foundation, either version 3 of the License, or (at your option) any
    % later version.
    %
    % ElasticMatrix is distributed in the hope that it will be useful, but
    % WITHOUT ANY WARRANTY; without even the implied warranty of
    % MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    % Lesser General Public License for more details.
    %
    % You should have received a copy of the GNU Lesser General Public
    % License along with ElasticMatrix. If not, see
    % <http://www.gnu.org/licenses/>.
    
    
    % =====================================================================
    %   VALIDATE INPUTS
    % =====================================================================

    % get the list of all the materials
    all_materials = materialList;
    
    % check inputs
    inputCheck(material, fieldnames(all_materials));
    
    % =====================================================================
    %   ASSIGN OBJECT FIELDS
    % =====================================================================
    
    % null constructore / define a new Medium object
    medium_layer = Medium;
    
    % assign the input name to the object
    medium_layer.setName(1, material);
    
    % assign density
    try
        medium_layer.density =  all_materials.(material).rho;
    catch
        warning('Density not assigned')
        medium_layer.density = 0;
    end
    
    % assign the stiffness matrix
    try
        % if the stiffness matrix is defined
        medium_layer.setStiffnessMatrix(...
            1,all_materials.(material).stiffness_matrix);
    catch
        % evaluate string for c, density
        c = all_materials.(material).c;
        % evaluate string for cs, shear speed
        cs = all_materials.(material).cs;
        % evaluate string for rho, density
        density = all_materials.(material).rho;
        % calculate stiffness matrix
        stiffness_matrix = Medium.soundSpeedDensityConversion(c, cs, density);
        % set stiffness matrix
        medium_layer.setStiffnessMatrix(1, stiffness_matrix);
    end
    
end

function inputCheck(material, all_materials_fields)
    %INPUTCHECK checks the inputs for getAcousticProperties().
    %
    % DESCRIPTION
    %   INPUTCHECK checks the properties for the function
    %   getAcousticProperties(material). Firstly it checks the input is a
    %   string and then checks if that string occurs in the all_materials
    %   structure. The all_materials structure contains all the predefined
    %   materials in ElasticMatrix.
    %
    % USEAGE
    %   inputCheck(material, all_materials)
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - January  - 2019
    %   last update     - 20 - July     - 2019
    
    % validate material is a string which is in all_materials
    validatestring(material, all_materials_fields,...
        'getAcousticProperties','material',1);
    
end