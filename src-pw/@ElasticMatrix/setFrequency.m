function obj = setFrequency(obj, frequency_range)
    %SETFREQUENCY Sets the frequency property of the ElasticMatrix class.
    %
    % DESCRIPTION
    %   SETFREQUENCY(...) sets the frequency property of the ElasticMatrix
    %   object. These values are used in the .calculate method. 0 values of
    %   frequency are replaced with 0.01 to avoid zero errors.
    %
    % USEAGE
    %   obj.setFrequency(frequency_range);        
    %
    % INPUTS
    %   frequency_range     - Vector of frequencies (Hz).   [1/s]
    %
    % OPTIONAL INPUTS
    %   []                  - There are no optional inputs. []
    %
    % OUTPUTS
    %   obj.frequency       - Sets the frequency property.  [1/s]
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
    inputCheck(frequency_range);
    
    % to avoid zero errors
    frequency_range(frequency_range == 0) = 0.01;
    
    % set the frequency range
    obj.frequency = frequency_range;
    
end

function inputCheck(frequency_range)
    %INPUECHECK Checks the inputs for the current function.
    %
    % DESCRIPTION
    %   INPUTCHECK(frequency_range) checks the inputs for the function
    %   setFrequency(...). If any of the inputs are not valid, the
    %   function will break and print errors to screen.
    %
    % USAGE
    %   inputChecks(frequency_range);
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 20 - July - 2019
    %   last update     - 21 - July - 2019
    
    % define attributes
    attributes = {'real'};
    
    % validate the attributes for input 1
    validateattributes(frequency_range, {'numeric'}, attributes,...
        'setFrequency', 'frequency_range', 1);
        
end