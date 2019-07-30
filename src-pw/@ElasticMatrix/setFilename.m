function obj = setFilename(obj, filename)
    %SETFILENAME Sets the object filename property of ElasticMatrix.
    %
    % DESCRIPTION
    %   SETFILENAME(...) sets the object filename of the ElasticMatrix
    %   class. This is used only when the obj.save method is used. The .mat
    %   file saved will be the identifiable as the filename.
    %
    % USEAGE
    %   obj.filename(filename);
    %
    % INPUTS
    %   filename        - Character string between 1-30 characters. []
    %
    % OPTIONAL INPUTS
    %   []              - There are no optional inputs.             []
    %
    % OUTPUTS
    %   obj.filename    - Filename property of ElasticMatrix.       []
    %
    % DEPENDENCIES
    %   []              - There are no dependencies.                []
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
    
    % input checks
    inputCheck(filename);
    
    % set the name
    obj.filename = filename;
    
end

function inputCheck(filename)
    %INPUECHECK Checks the inputs for the current function.
    %
    % DESCRIPTION
    %   INPUTCHECK(filename) checks the inputs for the function
    %   setFilename(...). If any of the inputs are not valid, the
    %   function will break and print errors to screen.
    %
    % USAGE
    %   inputChecks(filename);
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 20 - July - 2019
    %   last update     - 22 - July - 2019
    
    % check the class is correct
    if ~isa(filename,'char')
        error('The input to setFilename should of type ''char''.')
    end
    
    % maximum length
    MAX_STRING_LENGTH = 30;
    if length(filename) > MAX_STRING_LENGTH
        error('The input string must not be longer than 30 characters.')
    end
     
    % minimum length
    if isempty(filename) 
        error('The input string must be longer than 0 characters.')
    end
    
end



