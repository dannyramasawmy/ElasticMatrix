function obj = setStiffnessMatrix(obj, layer_index, stiffness_matrix)
    %SETSTIFFNESSMATRIX Sets the stiffness property of the Medium class.
    %
    % DESCRIPTION
    %   SETSTIFFNESSMATRIX(...) sets the stiffness_matrix property of the
    %   object, for the specified layer index. This is a method of the
    %   Medium class.
    %
    % USEAGE
    %   obj = setStiffnessMatrix(obj, layer_index, stiffness_matrix);
    %
    % INPUTS
    %   layer_index      - The index of the layer, (double).        []
    %   stiffness_matrix - The 6 X 6 stiffness matrix to be set.    [Pa]
    %
    % OPTIONAL INPUTS
    %   []               - There are no optional inputs.            []
    %
    % OUTPUTS
    %   obj.stiffness_matrix    - 6 X 6 stiffness matrix.           [Pa]
    %
    % DEPENDENCIES
    %   []              - There are no dependencies.                []
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - January  - 2019
    %   last update     - 21 - July     - 2019
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
    
    % check inputs
    inputCheck(layer_index, stiffness_matrix);
    
    % assign the stiffness_matrix
    obj(layer_index).stiffness_matrix = stiffness_matrix;
    
    
    
end

function inputCheck(layer_index, stiffness_matrix)
    %INPUECHECK Checks the inputs for the current function
    %
    % DESCRIPTION
    %   INPUTCHECK(layer_index, stiffness_matrix) checks the inputs for the
    %   function setStiffnessMatrix(...). If any of the inputs are not
    %   valid, the function will break and print errors to screen.
    %
    % USAGE
    %   inputChecks(layer_index, stiffness_matrix);
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 20 - July - 2019
    %   last update     - 21 - July - 2019
    
    % define attributes
    attributes = {'size',[1 1],'real','positive'};
    
    % validate the attributes for input 1
    validateattributes(layer_index,   {'numeric'},attributes,...
        'setStiffnessMatrix','layer_index',1);
    
    % define attributes
    attributes = {'size',[6 6],'real'};
    
    % validate the attributes for input 2
    validateattributes(stiffness_matrix,  {'numeric'},attributes,...
        'setStiffnessMatrix','stiffness_matrix',2);
    
end