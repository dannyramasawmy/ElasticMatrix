function obj = setPhasespeed(obj, phasespeed_range)
    %SETPHASESPEED Sets the phasespeed property of the ElasticMatrix class.
    %
    % DESCRIPTION
    %   SETPHASESPEED(...) sets the phasespeed property of the
    %   ElasticMatrix object. These values are used in the .calculate
    %   method. 0 values of phasespeed are replaced with 0.01 to avoid zero
    %   errors.
    %
    % USEAGE
    %   obj.setPhasespeed(phasespeed_range);        
    %
    % INPUTS
    %   phasespeed_range    - Vector of phasespeeds.        [m/s]
    %
    % OPTIONAL INPUTS
    %   []                  - There are no optional inputs. []
    %
    % OUTPUTS
    %   obj.phasespeed      - Sets the phasespeed property.  [s/m]
    %
    % DEPENDENCIES
    %   []                  - There are no dependencies.    []
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
    inputCheck(phasespeed_range);
    
    % avoid zero error
    phasespeed_range(phasespeed_range == 0) = 0.01;
    
    % set range of phasespeeds
    obj.phasespeed = phasespeed_range;
    
end

function inputCheck(phasespeed_range)
    %INPUECHECK Checks the inputs for the current function.
    %
    % DESCRIPTION
    %   INPUTCHECK(phasespeed_range) checks the inputs for the function
    %   setPhasespeed(...). If any of the inputs are not valid, the
    %   function will break and print errors to screen.
    %
    % USAGE
    %   inputChecks(phasespeed_range);
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 20 - July - 2019
    %   last update     - 21 - July - 2019
    
    % define attributes
    attributes = {'real'};
    
    % validate the attributes for input 1
    validateattributes(phasespeed_range, {'numeric'}, attributes,...
        'setPhasespeed', 'phasespeed_range', 1);
        
end