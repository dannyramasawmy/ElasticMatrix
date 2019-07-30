function [figure_handle, obj] = plotDispersionCurves( obj )
    %% plotDispersionCurves v1 date:  2019-01-15
    %
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %       Plots the dispersioncuvres.
    
    
    % check which method has been used to produce the dispersion curves
    % one method gives a structure which can be indexed - each index
    % corresponds to a different curve. The second (rough) method just
    % finds the points to give a rough outline of where the dispersion
    % curves are.
    
    % number of modes
    dispersionCurves = obj.dispersion_curves;
    
    % number of curves
    nCurves =  length(dispersionCurves);
    
    % plot style, if nCurves is 1 then the coarse algorithm was used so use
    % points to plot the dispersion curves
    plotStyle = 'k-';
    if nCurves == 1
        plotStyle = 'k.';    
    end
    
    
    % open figures
    figure_handle.fig1 = figure;
    figure_handle.fig2 = figure;
    
    % plot each mode individually
    for modeDx = 1:nCurves
        
        % choose first figure
        figure(figure_handle.fig1)
        hold on
        plot(obj.dispersion_curves(modeDx).y /1e3, obj.dispersion_curves(modeDx).x /1e6, plotStyle)
        hold off
        
        % choose second figure
        figure(figure_handle.fig2)
        hold on
        plot(obj.dispersion_curves(modeDx).x /1e6, obj.dispersion_curves(modeDx).c /1e3, plotStyle)
        hold off
    end
    
    % choose first figure
    figure(figure_handle.fig1)
    % labels
    ylim([0.1 max(obj.frequency)/1e6])
    % xlim([0 10])
    ylabel('Frequency [MHz]')
    xlabel('Wavenumber [1/km]')
    box on  
    
    
    % choose second figure
    figure(figure_handle.fig2)
    % labels
    xlim([0.1 max(obj.frequency)/1e6])
    ylim([0 10])
    xlabel('Frequency [MHz]')
    ylabel('Phase Velocity [km/s]')
    box on
    
    
    
    
end
