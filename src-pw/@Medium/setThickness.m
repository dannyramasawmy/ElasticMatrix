function obj = setThickness(obj, layer_index, layer_thickness)
    %SETTHICKNESS Sets the thickness property of the Medium class.
    %
    % DESCRIPTION
    %   SETTHICKNESS(...)  sets the thickness property of the object, for
    %   the specified layer index. This is a method of the Medium class.
    %   This function can also set multiple object thicknesses
    %   simultaneously.
    %
    % USEAGE
    %   obj = setThickness(layer_index, layer_thickness);
    %   obj = setThickness([layer_index_1, layer_index_2, layer_index_3],...
    %       [layer_thickness_1, layer_thickness_2, layer_thickness_3]);
    %
    % INPUTS
    %   layer_index     - the index of the layer, (vector)   []
    %   layer_thickness - the thickness to be set, (vector)  [m]
    %
    % OPTIONAL INPUTS
    %   []              - there are no optional inputs []
    %
    % OUTPUTS
    %   obj.thickness   - the thickness of the object layer  [m]
    %
    % DEPENDENCIES
    %   []              - there are no dependencies     []
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - January  - 2019
    %   last update     - 21 - July     - 2019
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
    
    % check inputs
    inputCheck(layer_index, layer_thickness);
    
    % assign multiple thicknesses
    for idx = 1:length(layer_index)
        obj(layer_index(idx)).thickness = layer_thickness((idx));
    end
    
end

function inputCheck(layer_index, layer_thickness)
    %INPUECHECK Checks the inputs for the current function
    %
    % DESCRIPTION
    %   INPUTCHECK(layer_index, layer_thickness) checks the inputs for the
    %   function setThickness(...). If any of the inputs are not valid, the
    %   function will break and print errors to screen.
    %
    % USAGE
    %   inputChecks(layer_index, layer_thickness);
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
        'setThickness','layer_index',1);
    % validate the attributes for input 2
    validateattributes(layer_thickness,  {'numeric'},attributes,...
        'setThickness','layer_thickness',2);
    
end