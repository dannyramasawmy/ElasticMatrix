function figHandle = plotDirectivity(obj, varargin)
    %% plotDirectivity v1 date:  2019-01-15
    %
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %       Plots the calculated directional response. For specific types
    %       of normalisation the input arguments to obj.getDirectivity can
    %       be used
    
    
    % if there is no specific plot, then plot all of them
    if isempty(varargin)
        varargin = {'normal', 'normalise', 'linear', 'decibel'};
    end
    
    % otherwise plot the input arguments
    for idx = 1:length(varargin)   
        figHandle(idx).fig = figure;
        try
           plotFigure(obj, figHandle(idx).fig, varargin{idx});
        catch
            warning('Could not plot...')
            close(figHandle(idx).fig);
            figHandle(idx).fig = 0;
        end
    end
    
end

function plotFigure(obj, currentHandle, plotType)
    % plotFigure v1 date:  2019-05-15
    %
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %       Plotting directivity
    
    % initalise figure
    figure(currentHandle);
    
    % plot directivity
    imagesc(obj.angle, obj.frequency/1e6, obj.getDirectivity(plotType));
       
    % labels
    xlabel('Angle [\circ]')
    ylabel('Frequency [MHz]')
    
    axis xy square
    colormap hot
    colorbar
    % colour axes
    switch plotType
        case 'decibel'
            caxis([-20 30])
        case 'linear'
            caxis([0 5])
        case 'normalise'
            caxis([0 1])
        case 'phase'
            caxis([-3 3])
    end
    
    % don't use imagesc if it is a normal plot 
    try
        if plotType == 'normal'
            plot(obj.frequency/1e6, obj.getDirectivity(plotType));
            xlabel('Frequency [MHz]')
        end
    catch
    end
    
end