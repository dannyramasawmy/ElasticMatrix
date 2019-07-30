function obj = setAngle(obj, angle_range)
    %SETANGLE Sets the wavenumber property of the ElasticMatrix class.
    %
    % DESCRIPTION
    %   SETANGLE(...) sets the wavenumber property of the ElasticMatrix
    %   object. These values are used in the .calculate method. 0 values of
    %   wavenumber are replaced with 0.01 to avoid zero errors.
    %
    % USEAGE
    %   obj.setAngle(angle_range);        
    %
    % INPUTS
    %   angle_range     - Vector of angles.             [degrees]
    %
    % OPTIONAL INPUTS
    %   []              - There are no optional inputs. []
    %
    % OUTPUTS
    %   obj.angle       - Sets the angle property.      [degrees]
    %
    % DEPENDENCIES
    %   []              - There are no dependencies.    []
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
    
    % check inputs
    inputCheck(angle_range);
    
    % to avoid zero errors
    angle_range(angle_range == 0) = 0.01;
    
    % set the angle range
    obj.angle = angle_range;
end

function inputCheck(angle_range)
    %INPUECHECK Checks the inputs for the current function.
    %
    % DESCRIPTION
    %   INPUTCHECK(angle_range) checks the inputs for the function
    %   setAngle(...). If any of the inputs are not valid, the
    %   function will break and print errors to screen.
    %
    % USAGE
    %   inputChecks(angle_range);
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 20 - July - 2019
    %   last update     - 21 - July - 2019
    
    % define attributes
    attributes = {'real'};
    
    % validate the attributes for input 1
    validateattributes(angle_range, {'numeric'}, attributes,...
        'setAngle', 'angle_range', 1);
        
end