function [figureHandle, obj] = plotInterfaceParameters( obj )
    %% plotInterfaceParameters v1 date: 2019-01-15
    %
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Descriptions:
    %       Plots the parameters at every interface of the
    %   multi-layered medium. (only for Angle and Frequency)
    %
    
    % =====================================================================
    %   ERROR CHECKING
    % =====================================================================
    
    % if any layers are a vacuum do not allow to plot
    for layerDx = 1:length(obj.medium)
        if strcmp(obj.medium(layerDx).state,'Vacuum')
            warning('Interface parameters are 0 for a vacuum')
            return
        end
    end
    
    % check angle and frequency vectors
    if isempty(obj.angle)
        warning(...
            ['Angle vector is empty, this is currently only available for '...
            ,'Angle and frequency'])
        return;
    end
    
    % check angle and frequency vectors
    if isempty(obj.frequency)
        warning(...
            ['Angle vector is empty, this is currently only available for '...
            ,'Angle and frequency'])
        return;
    end
    
    % =====================================================================
    %   PLOTTING
    % =====================================================================
    
    angleRange = obj.angle;
    frequencyRange = obj.frequency;
    
    % check for every interface
    for idx = 1:length(obj.medium) - 1
        
        % create a figure handle struct
        figureString = ['interface',num2str(idx)];
        figureHandle.(figureString) = figure;
        
        % extract uz
        uzUp = obj.z_displacement(idx).upper;
        uzDw = obj.z_displacement(idx).lower;
        
        % extract ux
        uxUp = obj.x_displacement(idx).upper;
        uxDw = obj.x_displacement(idx).lower;
        
        % extract sigma_zz
        sigZZup = obj.sigma_zz(idx).upper;
        sigZZdw = obj.sigma_zz(idx).lower;
        
        % extract sigma_xz
        sigXZup = obj.sigma_xz(idx).upper;
        sigXZdw = obj.sigma_xz(idx).lower;
        
        
        % sort to determine the plot type
        if length(angleRange) == 1
            % plot uz
            subplot(2,2,1)
            plot(frequencyRange, abs(uzUp), 'k')
            % labels
            xlabel('Frequency [MHz]')
            ylabel('Displacement [Pa]')
            title('Displacement - z')
            
            % plot uz
            subplot(2,2,2)
            plot(frequencyRange, abs(uxUp), 'k')
            xlabel('Frequency [MHz]')
            ylabel('Displacement [Pa]')
            title('Displacement - x')
            
            % plot sigma zz
            subplot(2,2,3)
            plot(frequencyRange, abs(sigZZup), 'k')
            xlabel('Frequency [MHz]')
            ylabel('Stress [Pa]')
            title('Stress - zz')
            
            % plot sigma xz
            subplot(2,2,4)
            plot(frequencyRange, abs(sigXZup), 'k')
            xlabel('Frequency [MHz]')
            ylabel('Stress [Pa]')
            title('Stress - xz')
            
            
        elseif length(frequencyRange) == 1
            % plot uz
            subplot(2,2,1)
            plot(angleRange, abs(uzUp), 'k')
            % labels
            xlabel('Angle [\circ]')
            ylabel('Displacement [Pa]')
            title('Displacement - z')
            
            % plot uz
            subplot(2,2,2)
            plot(angleRange, abs(uxUp), 'k')
            xlabel('Angle [\circ]')
            ylabel('Displacement [Pa]')
            title('Displacement - x')
            
            % plot sigma zz
            subplot(2,2,3)
            plot(angleRange, abs(sigZZup), 'k')
            xlabel('Angle [\circ]')
            ylabel('Stress [Pa]')
            title('Stress - zz')
            
            % plot sigma xz
            subplot(2,2,4)
            plot(angleRange, abs(sigXZup), 'k')
            xlabel('Angle [\circ]')
            ylabel('Stress [Pa]')
            title('Stress - xz')
            
        else
            % plot uz
            subplot(2,2,1)
            tmp = normMe(abs(uzUp));
            imagesc(angleRange, frequencyRange/1e6,  tmp)
            % labels
            title('Displacement - z')
            axis xy
            xlabel('Angle [\circ]')
            ylabel('Frequency [MHz]')
            colorbar
            
            % plot ux
            subplot(2,2,2)
            tmp = normMe(abs(uxUp));
            imagesc(angleRange, frequencyRange/1e6, tmp)
            % labels
            title('Displacement - x')
            axis xy
            xlabel('Angle [\circ]')
            ylabel('Frequency [MHz]')
            colorbar
            
            % plot sigma z
            subplot(2,2,3)
            tmp = normMe(abs(sigZZup));
            imagesc(angleRange, frequencyRange/1e6, tmp)
            % labels
            title('Stress - zz')
            axis xy
            xlabel('Angle [\circ]')
            ylabel('Frequency [MHz]')
            colorbar
            
            % plot sigma x
            subplot(2,2,4)
            tmp = normMe(abs(sigXZup));
            imagesc(angleRange, frequencyRange/1e6, tmp)
            % labels
            title('Stress - xz')
            axis xy
            xlabel('Angle [\circ]')
            ylabel('Frequency [MHz]')
            colorbar
        end
        
        % over title
        sgtitle(['Interface ',num2str(idx)])
    end
    
    
