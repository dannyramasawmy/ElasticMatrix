function figHandle = plotDirectivityTmp(obj, varargin)
    %% plotDirectivity v1 date:  2019-01-15
    % 
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %       Plots the calculated directional response.
    
    % open figure
    figHandle = figure;
  
    % normalise directivity
    directivityNorm = ...
        obj.tempFeature ./ ...
        (obj.tempFeature(:,1) * ones(1, length(obj.angle)));
    
    % plot directivity
    imagesc(obj.angle, obj.frequency/1e6, abs(directivityNorm))
    
    % labels
    xlabel('Angle [\circ]')
    ylabel('Frequency [MHz]')
    
    % plot nicely
    caxis([0 5])
    axis xy square
    colormap hot
    colorbar
    
end