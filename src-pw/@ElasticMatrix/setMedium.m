function obj = setMedium(obj, new_medium)
    %SETMEDIUM Sets the Medium property of the ElasticMatrix class.
    %
    % DESCRIPTION
    %   SETMEDIUM(new_medium) sets the Medium property of the ElasticMAtrix
    %   class. new_medium must be a Medium object which can be 1 X N
    %   dimensions. The Medium object contains the material properties and
    %   thickness of each layer in the multi-layered medium. Setting a new
    %   Medium object will deleted previously calculated properties of
    %   ElasticMatrix.
    %
    % USEAGE
    %   obj.setMedium(new_medium);
    %
    % INPUTS
    %   new_medium      - a Medium object                       []
    %
    % OPTIONAL INPUTS
    %   []              - there are no optional inputs          []
    %
    % OUTPUTS
    %   obj.medium      - the Medium property of ElasticMatrix  []
    %
    % DEPENDENCIES
    %   obj = Medium(...)  - requires a Medium object           []
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - January  - 2019
    %   last update     - 22 - July     - 2019
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
    inputCheck(new_medium);
    
    % assign medium object to medium property
    obj.medium = new_medium;
    
    % reset class properties, they will not be valid with a new Medium
    if ~isempty((obj.partial_wave_amplitudes))
        % delete irrelevant fields
        warning('All class properties must be recalculated.');
        obj.partial_wave_amplitudes      = [];
        obj.x_displacement               = [];
        obj.z_displacement               = [];
        obj.sigma_zz                     = [];
        obj.sigma_xz                     = [];
    end
    
    
end

function inputCheck(new_medium)
    %INPUECHECK Checks the inputs for the current function.
    %
    % DESCRIPTION
    %   INPUTCHECK(new_medium) checks the inputs for the function
    %   setMedium(...). If any of the inputs are not valid, the
    %   function will break and print errors to screen.
    %
    % USAGE
    %   inputChecks(new_medium);
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 20 - July - 2019
    %   last update     - 22 - July - 2019
    
    % check the class is correct
    if ~isa(new_medium,'Medium')
        error('The input to setMedium should be a Medium object.')
    end
     
end