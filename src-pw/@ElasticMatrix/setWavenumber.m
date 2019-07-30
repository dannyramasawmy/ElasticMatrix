function obj = setWavenumber(obj, wavenumber_range)
    %SETWAVENUMBER Sets the wavenumber property of the ElasticMatrix class.
    %
    % DESCRIPTION
    %   SETWAVENUMBER(...) sets the wavenumber property of the
    %   ElasticMatrix object. These values are used in the .calculate
    %   method. 0 values of wavenumber are replaced with 0.01 to avoid zero
    %   errors.
    %
    % USEAGE
    %   obj.setWavenumber(wavenumber_range);        
    %
    % INPUTS
    %   wavenumber_range    - Vector of wavenumbers.        [1/m]
    %
    % OPTIONAL INPUTS
    %   []                  - There are no optional inputs. []
    %
    % OUTPUTS
    %   obj.wavenumber      - Sets the wavenumber property.  [1/m]
    %
    % DEPENDENCIES
    %   []                  - There are no dependencies.    []
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
    inputCheck(wavenumber_range);
    
    % avoid zero errors
    wavenumber_range(wavenumber_range == 0) = 0.01;
    
    % set the wavenumber range
    obj.wavenumber = wavenumber_range;
end


function inputCheck(wavenumber_range)
    %INPUECHECK Checks the inputs for the current function.
    %
    % DESCRIPTION
    %   INPUTCHECK(wavenumber_range) checks the inputs for the function
    %   setWavenumber(...). If any of the inputs are not valid, the
    %   function will break and print errors to screen.
    %
    % USAGE
    %   inputChecks(wavenumber_range);
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 20 - July - 2019
    %   last update     - 21 - July - 2019
    
    % define attributes
    attributes = {'real'};
    
    % validate the attributes for input 1
    validateattributes(wavenumber_range, {'numeric'}, attributes,...
        'setWavenumber', 'wavenumber_range', 1);
        
end
