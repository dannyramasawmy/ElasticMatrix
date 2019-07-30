function obj = setName(obj, layer_index, layer_name)
    %SETNAME Sets the name property of the Medium class.
    %
    % DESCRIPTION
    %   SETNAME(...) sets the name property of the object, for the
    %   specified layer index. This is a method of the Medium class. 
    %
    % USEAGE
    %   obj = setName(layer_index, layer_name);
    %
    % INPUTS
    %   layer_index     - The index of the layer, (double).  []
    %   layer_name      - The name to be set, (string).      []
    %
    % OPTIONAL INPUTS
    %   []              - There are no optional inputs.      []
    %
    % OUTPUTS
    %   obj.name        - The name property of the object.  []
    %
    % DEPENDENCIES
    %   []              - There are no dependencies.         []
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - January  - 2019
    %   last update     - 30 - July     - 2019
    %
    % This file is part of the ElasticMatrix toolbox.
    % Copyright (c) 2019 Danny Ramasawmy.
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
    
    % check the inputs
    inputCheck(layer_index, layer_name);
    
    % set the name of layer (layer_index) to layer_name
    obj(layer_index).name = layer_name;
    
end


function inputCheck(layer_index, layer_name)
    %INPUECHECK Checks the inputs for the current function.
    %
    % DESCRIPTION
    %   INPUTCHECK(layer_index, layer_density) checks the inputs for the
    %   function setDensity(...). If any of the inputs are not valid, the
    %   function will break and print errors to screen.
    %
    % USAGE
    %   inputChecks(layer_index, layer_density);
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 20 - July - 2019
    %   last update     - 20 - July - 2019
    
    % define attributes
    attributes = {'real','positive'};
    
    % validate the attributes for input 1
    validateattributes(layer_index,   {'numeric'},attributes,...
        'setName','layer_index',1);
    
    % validate the second input is a string
    if ~isstr(layer_name)
        error('Expected input number 2, layer_name to be a string.')
    end
end
