function [figure_handle, obj] = plotSlowness(obj)
    %PLOTSLOWNESS Plots the slowness profiles.
    %
    % DESCRIPTION
    %   PLOTSLOWNESS is a method of the Medium class. This function plots
    %   the slowness profiles of each material in the Medium object. The
    %   slowness profiles should already be calculated using the
    %   .calcualteSlowness method. This populates the .slowness property of
    %   the object which contains the wave-vector components of each
    %   slowness profile. Only the parts of the slowness profile which have
    %   an imaginary part of 0 are plotted.
    %
    % USEAGE
    %   obj.plotSlowness;
    %   plotSlowness(obj);
    %
    % INPUTS
    %   obj             - Medium object.
    %
    %   The method obj.calculateSlowness should be used prior to calling
    %   the obj.plotSlowness method. This populates the slowness property
    %   of the object:
    %   obj.slowness            - property of Medium, (structure)
    %   obj.slowness.kx         - horizontal component (vector)
    %   obj.slowness.kz_qL1     - (quasi-)L  vertical component -ve
    %   obj.slowness.kz_qL2     - (quasi-)L  vertical component +ve
    %   obj.slowness.kz_qSV1    - (quasi-)SV vertical component -ve
    %   obj.slowness.kz_qSV2    - (quasi-)SV vertical component +ve
    %   obj.slowness.kz_qSH     - (quasi-)SH vertical component +ve
    %
    % OPTIONAL INPUTS
    %   []              - there are no optional inputs          []
    %
    % OUTPUTS
    %   figure_handle   - figure handle to the slowness plots   []
    %
    % DEPENDENCIES
    %   calculateAlphaCoefficients(...) - Christoffel equation
    %   .calculateSlowness(obj)         - calculating the slowness
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - January  - 2019
    %   last update     - 19 - July     - 2019
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
    
    % =====================================================================
    %   INPUT CHECKS
    % =====================================================================
    % check inputs
    inputCheck(obj);
    
    % =====================================================================
    %   PLOT FIGURES
    % =====================================================================
    % loop over each layer and plot the slowness profiles as a separate
    % subplot
    
    % get the length of the object
    number_layers = length(obj);
    
    % open figure
    figure_handle = figure;
    
    plot_counter = 1;
    
    % loop over each layer
    for plot_idx = 1:number_layers
        
        % check if valid
        if isstruct(obj(plot_idx).slowness)
            
            % call figure
            figure(figure_handle);
            
            % make subplots
            subplot( round(number_layers/2), 2, plot_idx )
            
            % plot each line - get rid of complex/imaginary parts
            hold on
            % qL - (quasi)-compressional
            [kx, kz_qL] = getRealDataPoints(...
                obj(plot_idx).slowness.kx, obj(plot_idx).slowness.kz_qL1);
            plot(kx, kz_qL, 'k.')
            % qSV - (quasi)-shear-vertical
            [kx, kz_qSV] = getRealDataPoints(...
                obj(plot_idx).slowness.kx, obj(plot_idx).slowness.kz_qSV1);
            plot(kx, kz_qSV, 'k--')
            % qSH - (quasi)-shear-horizontal
            [kx, kz_qSH] = getRealDataPoints(...
                obj(plot_idx).slowness.kx, obj(plot_idx).slowness.kz_qSH);
            plot(kx, kz_qSH, 'k-.')
            hold off
            
            % labels
            title([obj(plot_idx).name, ', layer : ', num2str(plot_idx)])
            box on
            xlabel('k_x / \omega')
            ylabel('k_z / \omega')
            axis equal
            
            % plot legend outside the figure axes
            if plot_counter == 1
                legend('(q)-L','(q)-SV','(q)-SH','Location','southwest')
                plot_counter = plot_counter +1 ;
            end
            
        elseif isnan(obj(plot_idx).slowness)
            % skip loop
            continue;
        end
        
        
    end
    
end


function [kx, kz] = getRealDataPoints( in_kx, in_kz)
    %GETREALDATAPOINTS Returns the elements of a vector where imag(x) == 0.
    %
    % DESCRIPTION
    %   Returns the element of the wave-vector where the imaginary part of
    %   the vertical-component of the wave-vector is zero. With anisotropic
    %   symmetries there may be two points on a qSV curve for the same kx.
    %   In these cases the remainder of the qSV curve appears in qL.
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - January  - 2019
    %   last update     - 21 - July     - 2019
    %
    % This file is part of the ElasticMatrix toolbox.
    % Copyright (c) 2019 Danny Ramasawmy.
    
    % find all the indices where the imaginary part is 0
    real_idxs = (imag(in_kz) == 0);
    
    % take the absolute value
    kz = abs( real( in_kz( real_idxs ) ) );
    kx = abs( real( in_kx( real_idxs ) ) );
    
    % just for ease in plotting a legend
    if isempty(kz)
        kx = 0;
        kz = 0;
    end
    
end

function inputCheck(obj)
       %INPUECHECK Checks the inputs for the current function
    %
    % DESCRIPTION
    %   INPUTCHECK(layer_index, layer_thickness) checks the inputs for the
    %   function setThickness(...). If any of the inputs are not valid, the
    %   function will break and print errors to screen.
    %
    % USAGE
    %   inputChecks(layer_index, layer_thickness);
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 20 - July - 2019
    %   last update     - 21 - July - 2019
    
    % check if obj.calculateSlowness has been run
    tmp = obj.slowness;
    if isempty(tmp)
        error(['The slowness profiles have not yet been calculated. '...
            'Please use the method: obj.calculateSlowness;.']);
    end
end



