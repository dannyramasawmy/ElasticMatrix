function obj = disp(obj)
    %DISP Displays the important properties of the Medium object.
    %
    % DESCRIPTION
    %   DISP prints the key properties of the Medium object to the command
    %   window. It makes use of the the table classes in MATLAB.
    %
    % USEAGE
    %   obj.disp;
    %   disp(obj);
    %
    % INPUTS
    %   obj             - Medium object.                []
    %
    % OPTIONAL INPUTS
    %   []              - There are no optional inputs. []
    %
    % OUTPUTS
    %   []              - The outputs.                  []
    %
    % DEPENDENCIES
    %   printLineBreaks - plotting === across the screen
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
    
    % print lines
    printLineBreaks;    
    % message
    disp('    Medium')
    printLineBreaks;

    
    % preallocate structure
    print_table(    length(obj))  = struct;
    print_table_2(  length(obj))  = struct;
    
    % copy fields to print
    for idx = 1:length(obj)
    
        % table 1
        print_table(idx).index       = idx;
        print_table(idx).name        = obj(idx).name;
        print_table(idx).thickness   = obj(idx).thickness;
        print_table(idx).density     = obj(idx).density;
        print_table(idx).state       = obj(idx).state;
        
        % table 2
        print_table_2(idx).index      = idx;
        print_table_2(idx).C11        = obj(idx).stiffness_matrix(1,1)/1e9;
        print_table_2(idx).C13        = obj(idx).stiffness_matrix(1,3)/1e9;
        print_table_2(idx).C33        = obj(idx).stiffness_matrix(3,3)/1e9;
        print_table_2(idx).C55        = obj(idx).stiffness_matrix(5,5)/1e9;
    end
    
    % display the table
    disp(struct2table(print_table));
    disp(' Stiffness coefficients given in GPa')
    disp(struct2table(print_table_2));
    
end