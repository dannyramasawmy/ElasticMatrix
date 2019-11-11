function obj = times(value, medium_1)
    %TIMES Overloads the times operator for periodic Medium objects.
    %
    % DESCRIPTION
    %   TIMES(...) overloads the times operator and can be used to generate
    %   large periodic Medium objects. The "unit cell" of the periodic
    %   structure must be defined using Medium. Then, multiplying this
    %   object with an integer n will return a new object with the "unit
    %   cell" n times. The order must be (1) integer then (2) Medium.
    %
    % USEAGE
    %   obj = 6 .* Medium(...
    %       'material_1', thickness_1, 'material_2', 'thickness_2')
    %
    % INPUTS
    %   value           - number of repetitions.
    %   medium_1        - Medium class objects.
    %
    % OPTIONAL INPUTS
    %   []              - There are no optional inputs.       []
    %
    % OUTPUTS
    %   obj             - Medium class object.
    %
    % DEPENDENCIES
    %   []              - There are no dependencies.          []
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 11 - November     - 2019
    %   last update     - 11 - November     - 2019
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
    
    % input check
    inputCheck(value, medium_1)
    
    % assign a temporary object with the periodic unit medium
    tmp = medium_1;
    
    % loop and add the periodic object to the temporary object until the
    % number of desired repetitions has been reached
    for idx = 1:value-1
        tmp = tmp + medium_1;
    end
    
    % return new object
    obj = tmp;
end

function inputCheck(value, medium_1)
    %INPUTCHECK Checks the inputs for the current function.
    %
    % DESCRIPTION
    %   INPUTCHECK(value, medium_2) checks the inputs for the
    %   function times(...). If any of the inputs are not valid, the
    %   function will break and print errors to screen.
    %
    % USAGE
    %   inputChecks(value, medium_2);
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 11 - November     - 2019
    %   last update     - 11 - November     - 2019
    
    % define attributes
    attributes = {'size', [1 1], 'real', 'positive', 'integer'};
    
    % validate the attributes for input 1
    validateattributes(value, {'numeric'},attributes,...
        'times', 'value',1);
    
    if ~isa(medium_1,'Medium')
        error('The input to setMedium should be a Medium object.')
    end
        
end