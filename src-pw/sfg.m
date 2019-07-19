function sfg()
    %SFG Distributes multiple figures across the screen evenly.
    %
    % DESCRIPTION
    %   SFG() is helpful when there are multiple figures open. This
    %   function detects all of the currently open figure handles, find the
    %   dimensions of the current screen size and resizes and places the
    %   figures in a tiled format to fill the screen. This function works
    %   best with 4-8 figures.
    %
    % USEAGE
    %   sfg;
    %
    % INPUTS
    %   []              - there are no inputs           []
    %
    % OPTIONAL INPUTS
    %   []              - there are no optional inputs  []
    %
    % OUTPUTS
    %   []              - there are no outputs          []
    %
    % DEPENDENCIES
    %   []              - there are no dependencies     []
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 01 - November - 2016
    %   last update     - 19 - July     - 2019
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
    disp('... distributing figures ...')
    
    % if total_figures < 6, add new figures for a nice spacing
    tmp_fig(6-total_figures) = figure;
    if total_figures < 6
        % create new figure array, effectively padding
        for idx = 1:(length(tmp_fig) - 1)
            tmp_fig(idx) = figure;
        end
    end
    
    % get figure handles
    figure_handles = findall(0, 'Type', 'figure');
    
    % number of figure handles
    total_figures = numel(figure_handles);
    
    % get screen size
    screen_size = get(groot, 'Screensize');
    
    % reduce the screen size dimensions (e.g., to exclude toolbars)
    side        = 10;
    vertical    = 100;
    screen_size = screen_size + [side, vertical, -side, -2*vertical];
    
    % check if there an even number of figures
    flag = 'odd';
    if mod(total_figures, 2) == 0
        flag = 'even';
    end
    
    % =====================================================================
    %   SET THE FIGURE DIMENSIONS AND DRAW
    % =====================================================================
    
    % set figure height
    height = (screen_size(4) - screen_size(2)) / 2 - 45 ;
    
    % choose figure width
    switch flag
        case 'even'
            width = (screen_size(3) - screen_size(1)) * 2 ...
                / total_figures;
        case 'odd'
            width = (screen_size(3) - screen_size(1)) * 2 ...
                / (total_figures + 1);
    end
    
    % for odd figures
    width_plus = screen_size(1) ;
    for idx = 1:round(total_figures / 2)
        
        % set the figure size
        set(figure_handles(idx),'Position',...
            [width_plus screen_size(2) width height]);
        
        % add new figure width to previous
        width_plus = width_plus + width + 1;
    end
    
    % for even figures
    width_plus = screen_size(1) ;
    for idx = (round(total_figures/2)+1):total_figures
        
        % set figure size
        set(figure_handles(idx),'Position',...
            [width_plus (height+screen_size(2)+89) width height])
        
        % add new figure width to previous
        width_plus = width_plus + width;
    end
    
    % close figure array
    if ~isempty(tmp_fig)
        for idx = 1:length(tmp_fig)
            close(tmp_fig(idx))
        end
    end
    
    % force drawing of figures
    for idx = 1:length(figure_handles_start)
        figure(figure_handles_start(idx))
        drawnow;
    end
    
end






