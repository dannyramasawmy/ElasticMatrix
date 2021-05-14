function [figure_handle, obj] = plotRTCoefficients(obj)
    %PLOTRTCOEFFICIENTS Plots the reflection and transmission coefficients.
    %
    % DESCRIPTION
    %   PLOTRTCOEFFICIENTS plots the reflection and transmission
    %   (displacement) coefficients for the first and last layers of
    %   ElasticMatrix. If the first and last layers are liquid these will
    %   be equivalent to the pressure reflection and transmission
    %   coefficients. Prior to calling this method plot these the
    %   .calculate method must be used.
    %
    %   Currently this function will only plot the frequency-angle
    %   dependent reflection and transmission coefficients. If the
    %   .frequency and .angle properties are larger than [1 1] then a 2D
    %   plot will be used. If either of .frequency or .angle have a
    %   dimension of [1 1] then a 1D plot will be used.
    %
    %   The partial_wave_amplitudes property of ElasticMatrix contain the
    %   reflection and transmission coefficients. The
    %   partial_wave_amplitudes property has dimensions:
    %     - p_w_a = n_freq X n_angle X n_amplitudes [complex]
    %   The third (AMPLITUDES) dimension is dependent on the number of
    %   layers used in the model.
    %   The partial wave amplitude order:
    %    
    %   - amplitudes(1)     - Upwards qSV in 1st layer (reflected). 
    %   - amplitudes(2)     - Upward qL in 1st layer (reflected). 
    %   - amplitudes(end-1)   - Downward qSV in last layer (transmitted). 
    %   - amplitudes(end) - Downward qL in last layer (transmitted).
    %
    %
    % USEAGE
    %   obj.plotRTCoefficients;
    %
    % INPUTS
    %   []              - There are no inputs.           []
    %
    % OPTIONAL INPUTS
    %   []              - There are no optional inputs.  []
    %
    % OUTPUTS
    %   figure_handle   - The figure_handle is returned. []
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
    
    % number of layers
    n_layers = length(obj.medium);
    
    % check inputs
    inputCheck(obj);
    
    % get the partial wave amplitudes
    pwa = obj.partial_wave_amplitudes;
    
    % =====================================================================
    %   PLOTTING
    % =====================================================================
    
    disp('... plotting reflection and transmission coefficients ...')

    % open figure
    figure_handle = figure;
    
    % get vectors
    angle_range = obj.angle;
    frequency_range = obj.frequency;
    
    % check shear support of material
    if strcmp(obj.medium(1).state, 'Liquid')
        pwa(:,:,1) = 0;
    end
    
    if strcmp(obj.medium(n_layers).state, 'Liquid')
        pwa(:,:,end - 1) = 0;
    end
    
    
    if length(obj.angle) == 1
        % plot the frequency dependent reflection and transmission
        % coefficient
        hold on
        plot(frequency_range/1e6, abs(pwa(:,1,2)),'b-') % comp R
        plot(frequency_range/1e6, abs(pwa(:,1,1)),'c-') % shear R
        plot(frequency_range/1e6, abs(pwa(:,1,end)),'r-') % comp T
        plot(frequency_range/1e6, abs(pwa(:,1,end - 1)),'m-') % shear T
        hold off
        % labels
        xlabel('Frequency [MHz]')
        legend('|R_L|','|R_S|','|T_L|','|T_S|')
        
        
    elseif length(obj.frequency) == 1
        % plot the angle dependent reflection and transmission coefficient
        hold on
        plot(angle_range, abs(pwa(1,:,2)),'b-') % comp R
        plot(angle_range, abs(pwa(1,:,1)),'c-') % shear R
        plot(angle_range, abs(pwa(1,:,end)),'r-') % comp T
        plot(angle_range, abs(pwa(1,:,end - 1)),'m-') % shear T
        hold off
        % labels
        xlabel('Angle [\circ]')
        legend('|R_L|','|R_S|','|T_L|','|T_S|')
        
        
    else
        % plot the frequency-angle dependent reflection coefficient
        subplot(2,2,1)
        % plot compressional reflection
        imagesc(angle_range, frequency_range/1e6, abs(pwa(:,:,2)))
        % labels
        xlabel('Angle [\circ]')
        ylabel('Frequency [MHz]')
        title('|R_L|')
        axis xy
        colormap gray
        colorbar
        
        subplot(2,2,2)
        % plot shear reflection
        imagesc(angle_range, frequency_range/1e6, abs(pwa(:,:,1)))
        % labels
        xlabel('Angle [\circ]')
        ylabel('Frequency [MHz]')
        title('|R_S|')
        axis xy
        colormap gray
        colorbar
        
        subplot(2,2,3)
        % plot compressional transmission
        imagesc(angle_range, frequency_range/1e6, abs(pwa(:,:,end)))
        % labels
        xlabel('Angle [\circ]')
        ylabel('Frequency [MHz]')
        title('|T_L|')
        axis xy
        colormap gray
        colorbar
        
        subplot(2,2,4)
        % plot shear transmission
        imagesc(angle_range, frequency_range/1e6, abs(pwa(:,:,end - 1 )))
        % labels
        xlabel('Angle [\circ]')
        ylabel('Frequency [MHz]')
        title('|T_S|')
        axis xy
        colormap gray
        colorbar
        
    end
    
end

function inputCheck(obj)
    %INPUTCHECK Checks the inputs for the current function.
    %
    % DESCRIPTION
    %   INPUTCHECK(obj) checks the inputs for the function
    %   setMedium(...). If any of the inputs are not valid, the
    %   function will break and print errors to screen.
    %
    % USAGE
    %   inputChecks(obj);
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 20 - July - 2019
    %   last update     - 22 - July - 2019 
    
    % check for vacuums
    for layer_idx = 1:length(obj.medium)
        if strcmp(obj.medium(layer_idx).state,'Vacuum')
            error(['Reflection and Transmission coefficients cannot ',...
                'be displayed for a vacuum.']);
        end
    end
    
    % check frequency vector has been populated
    if isempty(obj.frequency)
        error('Please set one or more values of frequency and recalculate.')
    end
    
    % check angle vector has been populated
    if isempty(obj.angle)
        error('Please set one or more values of angle and recalculate.')
    end
    
    % check angle vector has been populated
    if isempty(obj.partial_wave_amplitudes)
        error('Nothing to plot, please use the obj.calculate method first.')
    end
    
end