function [] = availableMaterials()
    %AVAILABLEMATERIALS Prints all available materials to screen.
    %
    % DESCRIPTION
    %   AVAILABLEMATERIALS prints the list of available materials to the
    %   command window. The pre-defined materials can be found in the
    %   function materialList;
    %
    % USEAGE
    %   Medium.availableMaterials;
    %
    % INPUTS
    %   []              - There are no inputs.          []
    %
    % OPTIONAL INPUTS
    %   []              - There are no optional inputs. []
    %
    % OUTPUTS
    %   []              - There are no outputs.         []
    %
    % DEPENDENCIES
    %   materialList    - Gets material names using this function.
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 19 - January - 2019
    %   last update     - 30 - July    - 2019
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
    
    
    % try run script
    try
        all_materials = materialList;
    catch
        error('Cannot find materials, check for ./src-pw/materialList.')
    end
    
    % store as new variable
    materials = fieldnames(all_materials);
    
    % clear temporary variable
    clear('all_materials');
    
    % convert the cell to a Table class
    T = cell2table(materials);
    
    % print lines
    printLineBreaks;
    
    % change the properties of the table class name
    T.Properties.VariableNames = {'materials'};
    
    % display the table
    disp(sortrows(T));
    
    % print lines
    printLineBreaks;
    
end

