function [obj] = calculateDirectivity(obj)
    %	CALCULATEDIRECTIVITY - one line description
    %
    % DESCRIPTION
    %   A short description of the functionTemplate goes here.
    %
    % USEAGE
    %   outputs = functionTemplate(input, another_input)
    %   outputs = functionTemplate(input, another_input, optional_input)
    %
    % INPUTS
    %   input           - the first input   [units]
    %
    % OPTIONAL INPUTS
    %   []              - there are no optional inputs []
    %
    % OUTPUTS
    %   outputs         - the outputs       [units]
    %
    % DEPENDENCIES
    %   []              - there are no dependencies     []
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
    
    % this function calculates the directivity
    disp('... Calculating directivity ...')
    
    obj.calculate;
    
    % difference in vertical displacement of the mirrors
    directivity = ...
        obj.z_displacement(obj.mirror_locations(1)).upper - ...
        obj.z_displacement(obj.mirror_locations(2)).upper;
    
    % FINEME : FUTURE ADDITIONS
    % warning('### ADD OPTICAL BIREFRINGENCE ###')
    % warning('## ADD SPOT SIZE')
    % warning('## ADD SPOT TYPE')
    
    % assign to temporary variable for fast plotting
    obj.directivity = directivity;
    
    disp('... Finished calculating ...')
    
end
