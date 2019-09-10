function [figure_handle, obj] = plotInterfaceParameters( obj )
    %PLOTINTERFACEPARAMETERS Plots the parameters at the interface.
    %
    % DESCRIPTION
    %   PLOTINTERFACEPARAMETERS plots the displacement and stresses at the
    %   interfaces of each layer. These are automatically calculated when
    %   the partial-wave method is used (obj.calculate). The stresses and
    %   displacements are relative to an input stress of 1MPa.
    %
    %   Currently this function will only plot the frequency-angle
    %   dependent stress and displacements. If the .frequency and .angle
    %   properties are larger than [1 1] then a 2D plot will be used. If
    %   either of .frequency or .angle have a dimension of [1 1] then a 1D
    %   plot will be used.
    %
    % USEAGE
    %   obj.plotInterfaceParameters;
    %
    % INPUTS
    %   obj.x_displacement      - Displacement in x direction. [m]
    %   obj.z_displacement      - Displacement in z direction. [m]
    %   obj.stress_zz           - Normal stress.
    %   obj.stress_xz           - Shear stress.
    %
    %   Each of the above properties is a structure with .lower or .upper.
    %   For example: obj.z_displacement(interface_idx).upper and
    %   obj.z_displacement(interface_idx).lower. These refer to the field
    %   parameters calculated above (upper) and below (lower) the
    %   interface. The index, interface_idx indicates the interfaces
    %   between each layer. See documentation/REFERENCES.txt.
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
    
    % check inputs
    inputCheck(obj);
    
    % =====================================================================
    %   PLOTTING
    % =====================================================================
    
    % get plotting ranges
    angle_range     = obj.angle;
    frequency_range = obj.frequency;
    
    % check for every interface
    for idx = 1:length(obj.medium) - 1
        
        % create a figure handle structure
        figureString = ['interface_',num2str(idx)];
        figure_handle.(figureString) = figure;
        
        % get uz
        uz_up = obj.z_displacement(idx).upper;
        % uzDw = obj.z_displacement(idx).lower; % alternative
        
        % get ux
        ux_up = obj.x_displacement(idx).upper;
        % uxDw = obj.x_displacement(idx).lower; % alternative
        
        % get sigma_zz
        sig_ZZ_up = obj.sigma_zz(idx).upper;
        % sigZZdw = obj.sigma_zz(idx).lower; % alternative
        
        % get sigma_xz
        sig_XZ_up = obj.sigma_xz(idx).upper;
        % sigXZdw = obj.sigma_xz(idx).lower; % alternative
        
        
        % sort to determine the plot type
        if length(angle_range) == 1
            % plot uz
            subplot(2,2,1)
            plot(frequency_range, abs(uz_up), 'k')
            % labels
            xlabel('Frequency [MHz]')
            ylabel('Displacement [m]')
            title('Displacement - z')
            
            % plot uz
            subplot(2,2,2)
            plot(frequency_range, abs(ux_up), 'k')
            xlabel('Frequency [MHz]')
            ylabel('Displacement [m]')
            title('Displacement - x')
            
            % plot sigma zz
            subplot(2,2,3)
            plot(frequency_range, abs(sig_ZZ_up), 'k')
            xlabel('Frequency [MHz]')
            ylabel('Stress [Pa]')
            title('Stress - zz')
            
            % plot sigma xz
            subplot(2,2,4)
            plot(frequency_range, abs(sig_XZ_up), 'k')
            xlabel('Frequency [MHz]')
            ylabel('Stress [Pa]')
            title('Stress - xz')
            
            
        elseif length(frequency_range) == 1
            % plot uz
            subplot(2,2,1)
            plot(angle_range, abs(uz_up), 'k')
            % labels
            xlabel('Angle [\circ]')
            ylabel('Displacement [m]')
            title('Displacement - z')
            
            % plot uz
            subplot(2,2,2)
            plot(angle_range, abs(ux_up), 'k')
            xlabel('Angle [\circ]')
            ylabel('Displacement [m]')
            title('Displacement - x')
            
            % plot sigma zz
            subplot(2,2,3)
            plot(angle_range, abs(sig_ZZ_up), 'k')
            xlabel('Angle [\circ]')
            ylabel('Stress [Pa]')
            title('Stress - zz')
            
            % plot sigma xz
            subplot(2,2,4)
            plot(angle_range, abs(sig_XZ_up), 'k')
            xlabel('Angle [\circ]')
            ylabel('Stress [Pa]')
            title('Stress - xz')
            
        else
            % plot uz
            subplot(2,2,1)
            tmp = normMe(abs(uz_up));
            imagesc(angle_range, frequency_range/1e6,  tmp)
            % labels
            title('Displacement - z')
            axis xy
            xlabel('Angle [\circ]')
            ylabel('Frequency [MHz]')
            colorbar
            
            % plot ux
            subplot(2,2,2)
            tmp = normMe(abs(ux_up));
            imagesc(angle_range, frequency_range/1e6, tmp)
            % labels
            title('Displacement - x')
            axis xy
            xlabel('Angle [\circ]')
            ylabel('Frequency [MHz]')
            colorbar
            
            % plot sigma z
            subplot(2,2,3)
            tmp = normMe(abs(sig_ZZ_up));
            imagesc(angle_range, frequency_range/1e6, tmp)
            % labels
            title('Stress - zz')
            axis xy
            xlabel('Angle [\circ]')
            ylabel('Frequency [MHz]')
            colorbar
            
            % plot sigma x
            subplot(2,2,4)
            tmp = normMe(abs(sig_XZ_up));
            imagesc(angle_range, frequency_range/1e6, tmp)
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
end

function inputCheck(obj)
    %INPUTCHECK Checks the inputs for the current function.
    %
    % DESCRIPTION
    %   INPUTCHECK(obj) checks the inputs for the function
    %   plotInterfaceparameters(...). If any of the inputs are not valid,
    %   the function will break and print errors to screen.
    %
    % USAGE
    %   inputChecks(obj);
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 20 - July - 2019
    %   last update     - 22 - July - 2019
    
    % do not plot for a vacuum
    for layerDx = 1:length(obj.medium)
        if strcmp(obj.medium(layerDx).state,'Vacuum')
            error('Interface parameters are 0 for a vacuum')
        end
    end
    
    % check angle and frequency properties
    if isempty(obj.angle)
        error(...
            ['obj.angle property is empty, .plotInterfaceParameters() is ',...
            'currently only available for angle and frequency.'])
    end
    
    % check angle and frequency properties
    if isempty(obj.frequency)
        error(...
            ['obj.frequency property is empty, .plotInterfaceParameters()',...
            ' is currently only available for angle and frequency.'])
    end
    
    % check the relevant properties are populated - x-displacement
    if isempty(obj.x_displacement)
        error('obj.x_displacement is empty, please use the obj.calculate method.')
    end
    
    % check the relevant properties are populated - z-displacement
    if isempty(obj.z_displacement)
        error('obj.z_displacement is empty, please use the obj.calculate method.')
    end
    
    % check the relevant properties are populated - normal stress
    if isempty(obj.sigma_zz)
        error('obj.sigma_zz is empty, please use the obj.calculate method.')
    end
    
    % check the relevant properties are populated - shear stress
    if isempty(obj.sigma_xz)
        error('obj.sigma_xz is empty, please use the obj.calculate method.')
    end
    
    
end
