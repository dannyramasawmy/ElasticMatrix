function dfg()
    %SFG Docks all open figures.
    %
    % DESCRIPTION
    %   DFG() is helpful when there are multiple figures open. This
    %   function detects all of the currently open figure handles and docks
    %   them to the IDE.
    %
    % USEAGE
    %   dfg;
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
    %   []              - There are no dependencies.    []
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 26 - November - 2020
    %   last update     - 26 - November - 2020
    %
    % This file is part of the ElasticMatrix toolbox.
    % Copyright (c) 2020 Danny Ramasawmy.
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
    
    % =====================================================================
    %   GET ALL FIGURE HANDLES AND THE SCREEN SIZE
    % =====================================================================
    
    % get figure handles
    figure_handles_start = findall(0, 'Type', 'figure');
    
    % number of figure handles
    total_figures = numel(figure_handles_start);
    
    % do nothing if there are no figures
    if total_figures == 0
        % display message
        disp('... no figures detected ...')
        return;
    end
    
    % display a message
    disp('... docking figures ...')
    
    % dock figures
    for fdx = 1:length(figure_handles_start)
        set(figure_handles_start(fdx),'WindowStyle','docked')
    end
        
        
    