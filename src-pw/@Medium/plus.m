function obj = plus(medium_1, medium_2)
    %PLUS Overloads the plus operator and combines two Medium objects.
    %
    % DESCRIPTION
    %   PLUS(...) overloads the plus operator and can be used to combine
    %   two Medium objects or to add a layer on the end .
    %
    % USEAGE
    %   obj = Medium('material', thickness) ...
    %      + Medium('material', thickness, 'material', thickness,)
    %      + Medium('material', thickness);
    %
    % INPUTS
    %   medium_1             - Medium class object.
    %   medium_2             - Medium class object.
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
    inputCheck(medium_1, medium_2);
    
    % create a temporary object based on the first Medium object
    tmp = medium_1;
    
    % add the layers of the second object to the temporary object
    tmp((length(medium_1)+1):(length(medium_2)+(length(medium_1)))) = medium_2;
    
    % return the new object
    obj = tmp;
    
end

function inputCheck(medium_1, medium_2)
    %INPUTCHECK Checks the inputs for the current function.
    %
    % DESCRIPTION
    %   INPUTCHECK(medium_1, medium_2) checks the inputs for the
    %   function plus(...). If any of the inputs are not valid, the
    %   function will break and print errors to screen.
    %
    % USAGE
    %   inputChecks(medium_1, medium_2);
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 11 - November     - 2019
    %   last update     - 11 - November     - 2019
    
    % check the class is correct
    if ~isa(medium_1,'Medium')
        error('The first input to plus should be a Medium object.')
    end
    
    if ~isa(medium_2,'Medium')
        error('The second input to plus should be a Medium object.')
    end
end
