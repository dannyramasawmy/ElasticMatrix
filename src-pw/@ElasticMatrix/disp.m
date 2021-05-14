function obj = disp(obj)
    %DISP Displays the important properties of the ElasticMatrix object.
    %
    % DESCRIPTION
    %   DISP prints the key properties of the ElasticMatrix object to the
    %   command window. It makes use of the the table classes in MATLAB.
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
    %   printLineBreaks;    - Prints === across the command window.
    %   Medium.disp;        - Displays the Medium object.
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
    
    % print lines
    printLineBreaks;
    disp('   ElasticMatrix  ')
    printLineBreaks;
    % print filename
    disp(['    Filename:   ',obj.filename])
    % empty line
    disp('  ')
    
    % =====================================================================
    %   PROPERTIES THAT NEED TO/CAN BE SET
    % =====================================================================
    
    disp(' ')
    disp('    Properties to set:')
    disp(' ')
    
    % list of properties to display
    string_list = {'frequency', 'angle', 'phasespeed', 'wavenumber'};
    
    % list of units
    units_list = {'[MHz]', '[degree]', '[m/s]', '[1/m]'};
    
    % initialize structure
    print_table(length(string_list)).property = '';
    
    % copy values for settable properties
    for idx = 1:length(string_list)
        
        % for displaying frequency
        factor = 1;
        if strcmp(string_list{idx}, 'frequency')
            factor = 1e6;
        end
        
        % copy properties
        print_table(idx).property     = string_list{idx};
        print_table(idx).miniumum     = min(obj.(string_list{idx}))/factor;
        print_table(idx).maximum      = max(obj.(string_list{idx}))/factor;
        print_table(idx).length       = length(obj.(string_list{idx}));
        print_table(idx).units        = units_list{idx};     
    end
    
    % display the table
    disp(struct2table(print_table));
    
    % =====================================================================
    %   PROPERTIES THAT SHOULD BE CACULATED
    % =====================================================================
    disp(' ')
    disp('    Properties to calculate:')
    disp(' ')
    
    % list of properties to display
    string_list = {'partial_wave_amplitudes', 'x_displacement', ...
        'z_displacement', 'sigma_zz', 'sigma_xz', 'dispersion_curves' };
    
    % initialize table
    print_table_2(length(string_list)).property      = '';
    print_table_2(length(string_list)).calculated    = 0;
    
    % loop and copy properties / check if they have been calculated
    for idx = 1:length(string_list)
        print_table_2(idx).property       = string_list{idx};
        print_table_2(idx).calculated     = ~isempty(obj.(string_list{idx}));
    end
    
    % display the table
    disp(struct2table(print_table_2));
    
    % =====================================================================
    %   PRINT THE MEDIUM CLASS
    % =====================================================================
    
    % display the medium object
    obj.medium.disp;
    
end