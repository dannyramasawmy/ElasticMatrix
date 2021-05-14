function [figure_handle, obj] = plotDispersionCurves( obj )
    %PLOTDISPERSIONCURVES Plots dispersion curves.
    %
    % DESCRIPTION
    %   PLOTDISPERSIONCURVES plots the calculated dispersion curves in
    %   terms of frequency-wavenumber and frequency-phase-speed.
    %
    % USEAGE
    %   [figure_handle] = plotDispersionCurves;
    %
    % INPUTS
    %   obj.dispersion_curves(idx). - A structure containing the (idx)th 
    %                                 dispersion curves.
    %       dispersion_curves.k     - Wavenumber vector.    [1/m]
    %       dispersion_curves.f     - Frequency vector.     [Hz, 1/s]
    %       dispersion_curves.c     - Phase-speed vector.   [m/s]
    %
    % OPTIONAL INPUTS
    %   []              - There are no optional inputs. []
    %
    % OUTPUTS
    %   figure_handle       - A structure with figure handles.
    %   figure_handle.fig1  - Figure handle for first figure.
    %   figure_handle.fig2  - figure handle for second figure.
    %
    % DEPENDENCIES
    %   []              - There are no dependencies.     []
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - January  - 2019
    %   last update     - 31 - July     - 2019
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
    
    % check which method has been used to produce the dispersion curves
    % one method gives a structure which can be indexed - each index
    % corresponds to a different curve. The second (rough) method just
    % finds the points to give a rough outline of where the dispersion
    % curves are.
        
    % number of dispersion curves traced
    n_curves =  length(obj.dispersion_curves);
    
    % plot style, if n_curves is 1 then the coarse algorithm was used so use
    plotStyle = 'k-';
    if n_curves == 1
        plotStyle = 'k.';    
    end
    
    % open figures
    figure_handle.fig1 = figure;
    figure_handle.fig2 = figure;
    
    % plot each mode individually
    for modeDx = 1:n_curves
        
        % choose first figure
        figure(figure_handle.fig1)
        hold on
        plot(...
            obj.dispersion_curves(modeDx).k /1e3, ...
            obj.dispersion_curves(modeDx).f /1e6, plotStyle)
        hold off
        
        % choose second figure
        figure(figure_handle.fig2)
        hold on
        plot(...
            obj.dispersion_curves(modeDx).f /1e6, ...
            obj.dispersion_curves(modeDx).c /1e3, plotStyle)
        hold off
    end
    
    % labels for first figure
    figure(figure_handle.fig1)
    % labels
    ylim([0.1 max(obj.frequency)/1e6])
    % xlim([0 10])
    ylabel('Frequency [MHz]')
    xlabel('Wavenumber [1/km]')
    box on  
    
    % labels for second figure
    figure(figure_handle.fig2)
    % labels
    xlim([0.1 max(obj.frequency)/1e6])
    ylim([0 10])
    xlabel('Frequency [MHz]')
    ylabel('Phase Velocity [km/s]')
    box on
    

end
