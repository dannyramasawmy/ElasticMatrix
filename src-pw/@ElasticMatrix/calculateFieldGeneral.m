function [fields, obj] = calculateFieldGeneral(obj, calculation_type, ....
        frequency_choice, second_choice, varargin)
    %CALCULATEFIELDGENERAL Calculates the displacement and stress fields.
    %
    % DESCRIPTION
    %   CALCULATEFIELD(...) plots the displacement and stress field in the
    %   multi-layered structure for a given pair of frequency and angle.
    %   The function takes the partial_wave_amplitudes calculated from the
    %   .calculate function, and calculates the displacement and stress
    %   within the multi-layered structure over a range of values X_hf and
    %   Z_hf. Currently this function is limited to only plotting a single
    %   angle and frequency and cannot plot if the first layer is a vacuum.
    %   There are multiple types of figure-styles that can be plotted and
    %   these are described below.
    %
    % USEAGE
    %   [figure_handle] = calculateField(frequency_choice, kx_choice);
    %   [figure_handle] = calculateField(frequency_choice, kx_choice,...
    %       {vector-Z, vector-X});
    %   [figure_handle] = calculateField(frequency_choice, kx_choice,...
    %       {vector-Z, vector-X}, time);
    %
    % INPUTS
    %   frequency_choice    - Choice of frequency.  [Hz]
    %   angle_choice        - Choice of angle.      [degrees]
    %
    % OPTIONAL INPUTS
    %   {z_vector, x_vector} - cell containing two vectors, these vectors
    %   define the range in z and x and sample density. The grid on which
    %   the field parameters are calculated are at [Z, X] =
    %   meshgrid(z_vector, x_vector);
    %
    %   z_vector        - Range of z-coordinates.           [m]
    %   x_vector        - Range of x-coordinates.           [m]
    %   time            - Time of propagation, default 0.   [s]
    %
    % OUTPUTS
    %   fields                  - Structure with the calculated fields:
    %   fields.z_vector         - 1D vector of z-range.         [m]
    %   fields.x_vector         - 1D vector of x-range.         [m]
    %   fields.x_displacement   - 2D matrix of x-displacements. [m]
    %   fields.z_displacement   - 2D matrix of z-displacements. [m]
    %   fields.sigma_zz         - 2D matrix of normal stress.   [Pa]
    %   fields.sigma_xz         - 2D matrix of shear stress.    [Pa]
    %
    % DEPENDENCIES
    %   []              - There are no dependencies.    []
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - January      - 2019
    %   last update     - 05 - May          - 2020
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
        
    % =====================================================================
    %   DETERMINE CALCULATION TYPE
    % =====================================================================
        
    dispf('... calculating displacement and stress fields ...')
    
    switch calculation_type
        case 'frequency-angle'            
            % set the properties and calculate the partial-wave amplitudes
            obj.setFrequency(frequency_choice);
            obj.setAngle(second_choice);
            obj.calculate;
            
            % future updates will include multiple frequency/angle calculations
            % find the closest amplitudes
            [~, aidx] = findClosest(obj.angle, second_choice);
            [~, fidx] = findClosest(obj.frequency, frequency_choice);
            
            % assign closest frequency and angle
            freq_vec    = obj.frequency(fidx);
            angle_vec   = obj.angle(aidx);
            
            % output wave amplitudes from calculated model
            wave_amplitudes = (obj.unnormalised_amplitudes(fidx, aidx,:));
            
            % =====================================================================
            %   PRECALCULATIONS
            % =====================================================================
            % final phase velocity
            phase_vel = sqrt(obj.medium(1).stiffness_matrix(1,1) /...
                obj.medium(1).density);
            
            % the number of layers
            num_layers = length(obj.medium);
            
            % angle and phase velocity
            angle   = angle_vec;
            theta   = angle * pi /180;
            % phase velocities
            cp      = phase_vel / sin(theta);
            % frequency
            omega   = 2* pi * freq_vec;
            k       = omega / cp ;
    
        case 'frequency-wavenumber'
            
            % set the properties and calculate the partial-wave amplitudes
            obj.setFrequency(frequency_choice);
            obj.setWavenumber(second_choice);
            obj.calculate;
            
            % future updates will include multiple frequency/angle calculations
            % find the closest amplitudes
            [~, widx] = findClosest(obj.wavenumber, second_choice);
            [~, fidx] = findClosest(obj.frequency, frequency_choice);
            
            % assign closest frequency and angle
            freq_vec    = obj.frequency(fidx);
            kx_vec = obj.wavenumber(widx);
            %     angle_vec   = obj.angle(widx);
            
            % output wave amplitudes from calculated model
            wave_amplitudes = (obj.unnormalised_amplitudes(fidx, widx,:));
            
            % the number of layers
            num_layers = length(obj.medium);
            
            % frequency
            omega = 2* pi * freq_vec;
            
            % wavenumber
            k = kx_vec ;
            
            % phase velocity
            cp = omega / k;
            
    end
    
 
    
    
    % incident wave amplitude set to 1 MPa
    P_0 = 1e6;
    B_1 =  (P_0 * 1i*k) / (obj.medium(1).density*omega^2);
    
    % =====================================================================
    %   INTERFACE POSITIONS
    % =====================================================================
    
    % get the position of each interface, 0 is at the bottom half-space interface
    cumulative_thickness = 0e-6;
    itfc_position(num_layers-1) = cumulative_thickness;
    % loop over layers in the medium and extract thickness
    for intIdx = num_layers-1:-1:2
        % sum thicknesses apart from the 1 & N layers  (half-spaces)
        cumulative_thickness = cumulative_thickness + obj.medium(intIdx).thickness;
        % interface position
        itfc_position(intIdx-1) = cumulative_thickness;
    end
    % set first boundary to be 0
    itfc_position = itfc_position - max(itfc_position);
    
    % =====================================================================
    %   DEFINE THE GRID
    % =====================================================================
    
    % choose number of samples
    z_samples = 256;
    x_samples = z_samples;
    
    % auto scale grid axes
    z_steps = linspace(-40*10^-6  + min(itfc_position), ...
        40*10^-6   , z_samples);
    x_steps = linspace(-1/ cp   , 1/ cp     , x_samples);
    
    try
        % varargin{1} - grid data
        z_steps = varargin{1}{1};
        x_steps = varargin{1}{2};
        % z_samples = length(z_steps);
        x_samples = length(x_steps);
        
        
    catch
        % error
        warning('Incorrect or no field input')
    end
    
    % define grid
    [Z , X] = (meshgrid(z_steps, x_steps));
    
    % =====================================================================
    % GET THE SENSOR GEOMETRY - grid indices
    % =====================================================================
    
    % first find which layer the indices belong too
    
    % Show the image
    % initialise
    layer(length(obj.medium)).idxs = 0;
    % populate layer.idxs
    layer(1).idxs = find(Z >= itfc_position(1));
    for ldx = 2:length(obj.medium)-1
        tmp = find(Z >= itfc_position(ldx) & Z < itfc_position(ldx-1));
        layer(ldx).idxs = tmp;
    end
    layer(length(obj.medium)).idxs = find(Z < itfc_position(end));
    
    % check with an image
    my_image = zeros(size(Z));
    for ldx = 1:length(layer)
        my_image(layer(ldx).idxs) = ldx;
    end
    
    % plot geometry DEBUG
    %{
    figure;
    % plot the figure
    imagesc(Zsteps,Xsteps,myImage)
    hold on
    plot(Z(layer(1).idxs),X(layer(1).idxs),'o')
    % labels
    title('Sensor Geometry')
    xlabel('Z - Depth')
    ylabel('X')
    %}
    
    % =============================================================
    %   MATERIAL PROPERTIES FOR EACH LAYER
    % =============================================================
    
    % loop over the medium layers and extract the important properties
    %   alpha               - partial wave amplitudes
    %   stiffness_matrix    - stiffness matrix for each material
    %   p_vec               - polarization of each partial wave
    
    % initalise outputs
    mat_prop(num_layers).alpha = [];
    mat_prop(num_layers).stiffness_matrix = [];
    mat_prop(num_layers).p_vec = [];
    
    % calculate properties
    for layIdx = 1:num_layers
        [ mat_prop(layIdx).alpha, mat_prop(layIdx).stiffness_matrix, ...
            mat_prop(layIdx).p_vec ] = Medium.calculateAlphaCoefficients(...
            obj.medium(layIdx).stiffness_matrix, cp, obj.medium(layIdx).density );
    end
    
    % initialize displacement matrices
    x_displacement  = zeros(size(Z));
    z_displacement  = zeros(size(Z));
    normal_stress   = zeros(size(Z));
    shear_stress    = zeros(size(Z));
    
    % time/phase loop
    time = 0;
    try
        time = varargin{2};
    catch
        % do nothing
    end
    
    % time / phase loop
    for tdx = time
        % loop over the layers
        for layer_idx = 1:num_layers
            
            % the dx and dz steps
            dz1 = (Z(layer(layer_idx).idxs));
            dx1 = (X(layer(layer_idx).idxs));
            dz = reshape(dz1,x_samples,(length(dz1)/x_samples));
            dx = reshape(dx1,x_samples,(length(dz1)/x_samples));
            
            % common factor
            Psy = exp(1i * k * (dx - cp*tdx)) ;
            
            % fluid correction in first layer
            fluid_correction = 1;
            if mat_prop(layer_idx).stiffness_matrix(5,5) < 5
                fluid_correction = 0; % remove shear components
            end
            
            % factor needed to scale each stress correctly
            stress_normalisation = 1i*k;
            
            switch layer_idx
                case 1
                    
                    % amplitude and z-phase
                    e1 = exp(1i * k * mat_prop(layer_idx).alpha(1) * dz) * wave_amplitudes(1) * fluid_correction;
                    e3 = exp(1i * k * mat_prop(layer_idx).alpha(3) * dz) * wave_amplitudes(2);
                    e4 = exp(1i * k * mat_prop(layer_idx).alpha(4) * dz) * B_1;
                    
                    % x-displacement
                    ux = Psy .* (e1 + e3 + e4) ;
                    % y-displacement
                    uz = Psy .* (...
                        e1 * mat_prop(layer_idx).p_vec(1) + ...
                        e3 * mat_prop(layer_idx).p_vec(3) + ...
                        e4 * mat_prop(layer_idx).p_vec(4));
                    
                    
                    % normal stress
                    sigma_zz =  Psy .* stress_normalisation .* ( ...
                        e1 * (mat_prop(layer_idx).stiffness_matrix(1,3) + (mat_prop(layer_idx).stiffness_matrix(3,3)) * mat_prop(layer_idx).alpha(1) * mat_prop(layer_idx).p_vec(1)) + ...
                        e3 * (mat_prop(layer_idx).stiffness_matrix(1,3) + (mat_prop(layer_idx).stiffness_matrix(3,3)) * mat_prop(layer_idx).alpha(3) * mat_prop(layer_idx).p_vec(3)) + ...
                        e4 * (mat_prop(layer_idx).stiffness_matrix(1,3) + (mat_prop(layer_idx).stiffness_matrix(3,3)) * mat_prop(layer_idx).alpha(4) * mat_prop(layer_idx).p_vec(4)) ) ;
                    
                    % shear stress
                    st2 = mat_prop(layer_idx).stiffness_matrix(5, 5) * stress_normalisation; % a coefficient
                    sigma_xz =  Psy .* fluid_correction .* st2 .*(...
                        e1 * (mat_prop(layer_idx).alpha(1) + mat_prop(layer_idx).p_vec(1)) + ...
                        e3 * (mat_prop(layer_idx).alpha(3) + mat_prop(layer_idx).p_vec(3)) + ...
                        e4 * (mat_prop(layer_idx).alpha(4) + mat_prop(layer_idx).p_vec(4))) ;
                    
                    
                case num_layers
                    
                    % amplitude and z-phase
                    e2 = exp(1i * k * mat_prop(layer_idx).alpha(2) * dz) * wave_amplitudes(end-1) * fluid_correction;
                    e4 = exp(1i * k * mat_prop(layer_idx).alpha(4) * dz) * wave_amplitudes(end);
                    
                    % x-displacement
                    ux = Psy .* (e2 + e4) ;
                    % y-displacement
                    uz = Psy .* (...
                        e2 * mat_prop(layer_idx).p_vec(2) + ...
                        e4 * mat_prop(layer_idx).p_vec(4));
                    
                    % normal stress
                    sigma_zz =  Psy .* stress_normalisation .* ( ...
                        e2 * (mat_prop(layer_idx).stiffness_matrix(1,3) + (mat_prop(layer_idx).stiffness_matrix(3,3)) * mat_prop(layer_idx).alpha(2) * mat_prop(layer_idx).p_vec(2)) + ...
                        e4 * (mat_prop(layer_idx).stiffness_matrix(1,3) + (mat_prop(layer_idx).stiffness_matrix(3,3)) * mat_prop(layer_idx).alpha(4) * mat_prop(layer_idx).p_vec(4)) ) ;
                    
                    % shear stress
                    st2 = mat_prop(layer_idx).stiffness_matrix(5, 5) * stress_normalisation; % a coefficient
                    sigma_xz =  Psy .* fluid_correction .* st2 .*(...
                        e2 * (mat_prop(layer_idx).alpha(2) + mat_prop(layer_idx).p_vec(2)) + ...
                        e4 * (mat_prop(layer_idx).alpha(4) + mat_prop(layer_idx).p_vec(4))) ;
                    
                    
                    
                otherwise
                    amp_idx = (layer_idx - 2)*4 + 2;
                    
                    % amplitude and z-phase
                    e1 = exp(1i * k * mat_prop(layer_idx).alpha(1) * dz) * wave_amplitudes(amp_idx + 1);
                    e2 = exp(1i * k * mat_prop(layer_idx).alpha(2) * dz) * wave_amplitudes(amp_idx + 2);
                    e3 = exp(1i * k * mat_prop(layer_idx).alpha(3) * dz) * wave_amplitudes(amp_idx + 3);
                    e4 = exp(1i * k * mat_prop(layer_idx).alpha(4) * dz) * wave_amplitudes(amp_idx + 4);
                    
                    % x-displacement
                    ux = Psy .* ( fluid_correction .*e1 +  fluid_correction .* e2 + e3 + e4) ;
                    % y-displacement
                    uz = Psy .* (...
                        e1 * mat_prop(layer_idx).p_vec(1) + ...
                        e2 * mat_prop(layer_idx).p_vec(2) + ...
                        e3 * mat_prop(layer_idx).p_vec(3) + ...
                        e4 * mat_prop(layer_idx).p_vec(4));
                    
                    % normal stress
                    sigma_zz =   Psy .* stress_normalisation .* ( ...
                        e1 * (mat_prop(layer_idx).stiffness_matrix(1,3) + (mat_prop(layer_idx).stiffness_matrix(3,3)) * mat_prop(layer_idx).alpha(1) * mat_prop(layer_idx).p_vec(1)) + ...
                        e2 * (mat_prop(layer_idx).stiffness_matrix(1,3) + (mat_prop(layer_idx).stiffness_matrix(3,3)) * mat_prop(layer_idx).alpha(2) * mat_prop(layer_idx).p_vec(2)) + ...
                        e3 * (mat_prop(layer_idx).stiffness_matrix(1,3) + (mat_prop(layer_idx).stiffness_matrix(3,3)) * mat_prop(layer_idx).alpha(3) * mat_prop(layer_idx).p_vec(3)) + ...
                        e4 * (mat_prop(layer_idx).stiffness_matrix(1,3) + (mat_prop(layer_idx).stiffness_matrix(3,3)) * mat_prop(layer_idx).alpha(4) * mat_prop(layer_idx).p_vec(4)) ) ;
                    
                    % shear stress
                    st2 = mat_prop(layer_idx).stiffness_matrix(5, 5) * stress_normalisation; % a coefficient
                    sigma_xz =  Psy .* fluid_correction .* st2 .*(...
                        e1 * (mat_prop(layer_idx).alpha(1) + mat_prop(layer_idx).p_vec(1)) + ...
                        e2 * (mat_prop(layer_idx).alpha(2) + mat_prop(layer_idx).p_vec(2)) + ...
                        e3 * (mat_prop(layer_idx).alpha(3) + mat_prop(layer_idx).p_vec(3)) + ...
                        e4 * (mat_prop(layer_idx).alpha(4) + mat_prop(layer_idx).p_vec(4))) ;
                                  
            end
            
            % assign calculated values
            x_displacement(layer(layer_idx).idxs) = ux;
            z_displacement(layer(layer_idx).idxs) = uz;
            normal_stress(layer(layer_idx).idxs)  = sigma_zz;
            shear_stress(layer(layer_idx).idxs)   = sigma_xz;
            
        end
        %fields in each layer
        fields.z_vector     = z_steps;
        fields.x_vector     = x_steps;
        fields.x_displacement    = x_displacement;
        fields.z_displacement    = z_displacement;
        fields.sigma_zz    = normal_stress;
        fields.sigma_xz    = shear_stress;

    end % time loop
    
    dispf('... finished calculating displacement and stress fields ...')
end
