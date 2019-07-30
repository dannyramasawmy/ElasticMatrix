function obj = setMirrorLocations(obj, interface_locations)
    %SETMIRRORLOCATIONS Interface locations of mirrors.
    %
    % DESCRIPTION
    %   SETMIRRORLOCATIONS(...) sets the mirror locations of the
    %   Fabry-Perot mirrors. Currently these can only be set as the
    %   interfaces between layers. For a structure consisting of four
    %   layers, there are three interfaces. The input to this function is
    %   the index of the interfaces, (i.e., 1,2 or 3 for this example). Two
    %   indices must be used, and they should be in ascending order.
    %
    % USEAGE
    %   obj.setMirrorLocations(obj, interface_locations);
    %   
    % INPUTS
    %   interface_locations     - a vector of size [2 X 1], with the inputs
    %                             as follows [interface_index_1,
    %                             interface_index_2]
    %
    % OPTIONAL INPUTS
    %   []                      - there are no optional inputs  []
    %
    % OUTPUTS
    %   obj.mirror_locations     - the interface locations      []
    %
    % DEPENDENCIES
    %   []                      - there are no dependencies     []
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 05 - May      - 2019
    %   last update     - 28 - July     - 2019
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
    
    % get the number of layers
    number_layers = length(obj.medium);
    
    % check that the interface locations are integers
    bool_var = [...
        checkInterfaceInput(interface_locations(1), number_layers), ...
        checkInterfaceInput(interface_locations(2), number_layers)];
        
    autoAssignFlag = 0;
    % assign mirror interfaces
    if sum(bool_var) == 2
        % check inputs are in ascending order and assign
            obj.mirror_locations = ...
                sort([interface_locations(1), interface_locations(2)]);
    else
        autoAssignFlag = 1;
    end
    
    
    if autoAssignFlag == 1
        % auto assign mirror interfaces
        warning(['Incorrect inputs, the mirror locations ',...
            'will be automatically assigned.'])
        
        % check number of layers is more than three - assign first and last
        % interfaces
        if number_layers > 2
            obj.mirror_locations = [1, number_layers-1];
        else
            error('obj.medium must be at least three layers');
        end
    end
    
    
end

function [logical_output] = checkInterfaceInput(interface_location, n_layers)
    %CHECKINTERFACEINPUT Interface locations check.
    %
    % DESCRIPTION
    %   CHECKINTERFACEINPUT(...) checks the validity of the interface
    %   location inputs.
    %
    % USEAGE
    %   [logical_output] = checkInterfaceInput(...
    %       interface_location, n_layers)
    %   
    % INPUTS
    %   interface_location      - a [2 X 1] vector
    %   n_layers                - number of layers in obj.medium
    %
    % OPTIONAL INPUTS
    %   []                      - there are no optional inputs  []
    %
    % OUTPUTS
    %   logical_output          - boolean for if the inputs are valid
    %
    % DEPENDENCIES
    %   []                      - there are no dependencies     []
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 05 - May      - 2019
    %   last update     - 28 - July     - 2019
    
    logical_output = 1;
    
    % check interface location is more than 0
    if interface_location > 0
        logical_output = 1 * logical_output;
    else
        logical_output = 0 * logical_output;
    end
    
    % check interface location is less than the maximum number of layers
    if interface_location < n_layers
        logical_output = 1 * logical_output;
    else
        logical_output = 0 * logical_output;
    end
    
    % check that it is an integer
    if floor(interface_location) == interface_location
        logical_output = 1 * logical_output;
    else
        logical_output = 0 * logical_output;
    end
 
end