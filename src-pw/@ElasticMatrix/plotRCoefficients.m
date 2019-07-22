function [figureHandle, obj] = plotRCoefficients(obj)
    %% plotRCoefficients v1 date: 2019-01-15
    %
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Descriptions:
    %       Plots the reflection and transmission (displacement) coeffients
    %       for the first and last layers. If the first and last layers are
    %       liquid these will be equivalent to the pressure reflection and
    %       transmission coefficients.
    %       Energy coefficients will be added in the future.
    %
    %       Partial wave amplitudes (pwa) give the reflection anf transmission
    %       coefficients, pwa = FREQ X ANGLE X AMPLITUDES [complex]
    %       AMPLITUDES(1) = shear reflection
    %       AMPLITUDES(2) = compressional reflection
    %       AMPLITUDES(end - 1) = shear transmission
    %       AMPLITUDES(end) = compressional transmission
    
    % number of layers
    nLayers = length(obj.medium);
    
    % =====================================================================
    %   PARAMETER CHECKING
    % =====================================================================
    warning on
    
    % if any layers are a vacuum do not allow to plot
    for layerDx = 1:nLayers
        if strcmp(obj.medium(layerDx).state,'Vacuum')
            warning('Reflection and Transmission coefficients cannot be displayed for a vacuum')
            return
        end
    end
    
    % check frequency vector has been populated
    if isempty(obj.frequency)
        warning('Please set one or more values of frequency and recalculate')
       return
    end
    
    % check angle vector has been populated
    if isempty(obj.angle)
       warning('Please set one or more values of angle and recalculate')
        return
    end
    
    % get the partial wave amplitudes if possible
    try
        % get the partial wave amplitues
        pwa = obj.partial_wave_amplitudes;
    catch
        warning('cannot plot, please use the .calculate method first')
    end
    
    % =====================================================================
    %   PLOTTING
    % =====================================================================
    
    % open figure
    figureHandle = figure;
    
    % get vectors
    angleRange = obj.angle;
    frequencyRange = obj.frequency;
    
    % check shear support of material
    if strcmp(obj.medium(1).state, 'Liquid')
        pwa(:,:,1) = 0;
    end
    
    if strcmp(obj.medium(nLayers).state, 'Liquid')
        pwa(:,:,end - 1) = 0;
    end
    
    
    if length(obj.angle) == 1
        % plot the frequency dependent reflection and transmission
        % coefficient
        hold on
        plot(frequencyRange/1e6, abs(pwa(:,1,2)),'b-') % comp R
        plot(frequencyRange/1e6, abs(pwa(:,1,1)),'c-') % shear R
        plot(frequencyRange/1e6, abs(pwa(:,1,end)),'r-') % comp T
        plot(frequencyRange/1e6, abs(pwa(:,1,end - 1)),'m-') % shear T
        hold off
        % labels
        xlabel('Frequency [MHz]')
        legend('|R_L|','|R_S|','|T_L|','|T_S|')
        
        
    elseif length(obj.frequency) == 1
        % plot the angle dependent reflection and transmission coefficient
        hold on
        plot(angleRange, abs(pwa(1,:,2)),'b-') % comp R
        plot(angleRange, abs(pwa(1,:,1)),'c-') % shear R
        plot(angleRange, abs(pwa(1,:,end)),'r-') % comp T
        plot(angleRange, abs(pwa(1,:,end - 1)),'m-') % shear T
        hold off
        % labels
        xlabel('Angle [\circ]')
        legend('|R_L|','|R_S|','|T_L|','|T_S|')
        
        
    else
        % plot the frequency-angle dependent reflection coefficient
        subplot(2,2,1)
        % plot compressional reflection
        imagesc(angleRange, frequencyRange/1e6, abs(pwa(:,:,2)))
        % labels
        xlabel('Angle [\circ]')
        ylabel('Frequency [MHz]')
        title('|R_L|')
        axis xy
        colormap gray
        colorbar
        
        subplot(2,2,2)
        % plot shear reflection
        imagesc(angleRange, frequencyRange/1e6, abs(pwa(:,:,1)))
        % labels
        xlabel('Angle [\circ]')
        ylabel('Frequency [MHz]')
        title('|R_S|')
        axis xy
        colormap gray
        colorbar
            
        subplot(2,2,3)
        % plot compressional transmission
        imagesc(angleRange, frequencyRange/1e6, abs(pwa(:,:,end)))
        % labels
        xlabel('Angle [\circ]')
        ylabel('Frequency [MHz]')
        title('|T_L|')
        axis xy
        colormap gray
        colorbar
        
        subplot(2,2,4)
        % plot shear transmission
        imagesc(angleRange, frequencyRange/1e6, abs(pwa(:,:,end - 1 )))
        % labels
        xlabel('Angle [\circ]')
        ylabel('Frequency [MHz]')
        title('|T_S|')
        axis xy
        colormap gray
        colorbar
        
    end
    
end


