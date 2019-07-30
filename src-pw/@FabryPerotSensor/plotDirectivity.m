function figure_handle = plotDirectivity(obj, varargin)
    %PLOTDIRECTIVITY Returns calculated directivity data.
    %
    % DESCRIPTION
    %   PLOTDIRECTIVITY(...) plots the directivity data held in property
    %   obj.directivity. The directivity data is in general complex, this
    %   function uses obj.getDirectivity to get the processed directivity.
    %
    % USEAGE
    %   figure_handle = plotDirectivity(obj, varargin)
    %   figure_handle = plotDirectivity(obj, 'raw', 'real')
    %   
    % INPUTS
    %   []                - There are no inputs.          []
    %
    % OPTIONAL INPUTS
    %   Multiple inputs are accepted, these must be strings:
    %   - 'phase'         - Phase of obj.directivity.
    %   - 'linear'        - Normalized to normal incidence response 
    %                       obj.directivity.
    %   - 'decibel'       - Decibel scaling of 'linear'.
    %   - 'normalise'     - Normalized to maximum value of normal incidence.
    %   - 'normal'        - Normal incidence response.
    %
    % OUTPUTS
    %   figure_handle(idx).fig - Figure handles to directivity figures.
    %
    % DEPENDENCIES
    %   []              - There are no dependencies.     []
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 05 - May      - 2019
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
    
    % valid plot inputs
    plot_types = {'normal', 'normalise', 'linear', 'decibel', 'phase'};
    
    % if there is no specific plot input, plot all of them
    if isempty(varargin)
        varargin = plot_types;
    end
    
    % preallocate figure handles space
    figure_handle(length(varargin)).fig = [];
    
    % otherwise plot the input arguments
    for idx = 1:length(varargin)
        
        % open figure 
        figure_handle(idx).fig = figure;
        
        try
            % check plot-type string inputs
            plot_string = validatestring(varargin{idx}, plot_types);
            
            % plot the figure
            plotFigure(obj, figure_handle(idx).fig, plot_string);
        catch
            
            % if the plot input is not valid
            warning('Could not plot.')
            close(figure_handle(idx).fig);
            figure_handle(idx).fig = 0;
        end
    end
    
end

function plotFigure(obj, current_handle, plot_type)
    %PLOTFIGURE Plots the directivity and scales the colour axis.
    %
    % DESCRIPTION
    %   This function plots the directional response of Fabry-Perot
    %   ultrasound sensors.
    %
    % USEAGE
    %   plotFigure(obj, current_handle, plot_type)
    %
    % INPUTS
    %   obj             - FabryPerotSensor object.      []
    %   current_handle  - Figure handle.
    %   plot_type       - A string, see plotDirectiviy.
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
    %   date            - 05 - May      - 2019
    %   last update     - 30 - July     - 2019
    
    % initialize figure
    figure(current_handle);
    
    % plot directivity
    imagesc(obj.angle, obj.frequency/1e6, obj.getDirectivity(plot_type));
    
    % labels
    xlabel('Angle [\circ]')
    ylabel('Frequency [MHz]')
    axis xy square
    colormap hot
    colorbar
    title(plot_type)
    % colour axes
    switch plot_type
        case 'decibel'
            caxis([-20 30])
        case 'linear'
            caxis([0 5])
        case 'normalise'
            caxis([0 1])
        case 'phase'
            caxis([-6 6])
    end
    
    % don't use imagesc if it is a normal plot
    try
        if strcmp(plot_type, 'normal')
            plot(obj.frequency/1e6, obj.getDirectivity(plot_type));
            % labels
            xlabel('Frequency [MHz]')
            title('normal')
        end
    catch
        % do nothing
    end
    
end

