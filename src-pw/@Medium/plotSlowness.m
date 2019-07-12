function [figureHandle, obj] = plotSlowness(obj)
    %% plotSlowness v1 date:  2019-01-15
    %
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %       Plots the slowness profiles for each material in the
    %       layered object
    
    
    % get the length of the object
    numberLayers = length(obj);
    
    % open figure
    figureHandle = figure;
    
    plotCounter = 1;
    
    % loop over each layer
    for plotDx = 1:numberLayers
        
        % check if valid
        if isstruct(obj(plotDx).slowness)
            
            % call figure
            figure(figureHandle);
            
            % make subplots
            subplot( round(numberLayers/2), 2, plotDx )
            
            % plot each line - get rid of complex/imaginary parts
            hold on
            % qL - (quasi)-compressional
            [kx, kz_qL] = getRealDataPoints( obj(plotDx).slowness.kx, obj(plotDx).slowness.kz_qL1);
            plot(kx, kz_qL, 'k.')
            % qSV - (quasi)-shear-vertical
            [kx, kz_qSV] = getRealDataPoints( obj(plotDx).slowness.kx, obj(plotDx).slowness.kz_qSV1);
            plot(kx, kz_qSV, 'k--')
            % qSH - (quasi)-shear-horizontal
            [kx, kz_qSH] = getRealDataPoints( obj(plotDx).slowness.kx, obj(plotDx).slowness.kz_qSH);
            plot(kx, kz_qSH, 'k-.')
            hold off
            
            % labels
            title([obj(plotDx).name, ', layer : ', num2str(plotDx)])
            box on
            xlabel('k_x / \omega')
            ylabel('k_z / \omega')
            axis equal
            % plot legend outside
            if plotCounter == 1
                legend('(q)-L','(q)-SV','(q)-SH','Location','southwest')
                plotCounter = plotCounter +1 ;
            end
            
        elseif isnan(obj(plotDx).slowness)
            % skip loop
            continue;
        end
        
        
    end
    
end


function [kx, kz] = getRealDataPoints( inKx, inKz)
    % getRealDataPoints v1 date:  2019-01-15
    %
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %       Seperates the real data points of the slowness profiles
    %
    
    % with anisotropic symmetries there may be two points on a qSV curve
    % for the same kx. In these cases the remainder of the qSV curve
    % appears in qL.
    realIdxs = (imag(inKz) == 0);
    
    % 
    kz = abs( real( inKz( realIdxs ) ) );
    kx = abs( real( inKx( realIdxs ) ) );
    
    
    % just for ease in plotting a legend
    if isempty(kz)
        kx = 0;
        kz = 0;
    end
        
end
    