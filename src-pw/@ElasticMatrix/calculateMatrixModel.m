function [metrics, field_vars, partial_wave_amplitudes, unnorm_amplitudes] = ...
        calculateMatrixModel(medium, frequency_vec, angle_vec, return_field_var)
    %CALCULATEMATRIXMODEL Partial-wave method in frequency-angle.
    %
    % DESCRIPTION
    %   CALCULATEMATRIXMODEL is an implementation of the partial-wave model
    %   in frequency-angle. See documentation/REFERENCES.txt for more
    %   detail on the underlying model. This function firstly does some
    %   pre-calculations for parameters such as the number of layers and
    %   the total cumulative thickness. After this, there is a frequency
    %   and angle for loop. For every combination of angle and frequency:
    %   1) the wave-vectors and polarizations for every partial wave in
    %   each layer are calculated, 2) the field matrix is calculated, 3)
    %   the system matrix is constructed, 4) the determinant of the
    %   system-matrix is found, 5) the partial-wave-amplitudes are
    %   calculated, 6) the interface displacement and stresses are
    %   calculated.
    %
    %   NOTE: This function will be merged with calculateMatrixModelKf.
    %
    % USEAGE
    %   [metrics, field_vars, partial_wave_amplitudes, unnorm_amplitudes] = ...
    %       calculateMatrixModel(...
    %       medium, frequency_vec, angle_vec, return_field_var);
    %
    % INPUTS
    %   medium              - An object from the Medium class.  []
    %   frequency_vec       - A vector of frequencies.          [Hz]
    %   angle_vec           - A vector of angles.               [degrees]
    %   return_field_var    - A boolean on whether to return the
    %                         field-variables.
    %
    % OPTIONAL INPUTS
    %   []              - There are no optional inputs.         []
    %
    % OUTPUTS
    %   metrics                     - Determinant map of the system matrix
    %                                 of size frequency_vec X angle_vec.
    %   field_vars.                 - The field variables, i.e., stress and
    %                                 displacement, returned as a structure.
    %     - field_vars(idx).upper   - idx, refers to the layer, upper and
    %     - field_vars(idx).lower     lower refer to what side of the
    %                                 interface the field variable has been
    %                                 calculated at.
    %   partial_wave_amplitudes     - The partial_wave_amplitudes is of
    %                                 size n_freqs X n_angles X
    %                                 n_amplitudes. These have been
    %                                 normalized by the amplitude of the
    %                                 incident wave.
    %   unnorm_amplitudes           - The partial-wave-amplitudes but
    %                                 not-normalized.
    %
    % DEPENDENCIES
    %   []              - There are no dependencies.            []
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 17 - January  - 2019
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
    
    % =====================================================================
    %   PRECALCULATIONS
    % =====================================================================
    
    % final phase velocity
    phase_velocity = sqrt(medium(1).stiffness_matrix(1,1) /...
        medium(1).density);
    
    % the number of layers
    num_layers = length(medium);
    
    % the number of interfaces
    num_interfaces = num_layers - 1;
    
    % INTERFACE LOCATIONS =================================================
    
    % get the position of each interface, 0 is at the bottom half-space interface
    cumulative_thickness = 0e-6;
    itfc_position(num_layers-1) = cumulative_thickness;
    % loop over layers in the medium and extract thickness
    for int_dx = num_layers-1:-1:2
        % sum thicknesses apart from the 1 & N layers  (half-spaces)
        cumulative_thickness = cumulative_thickness + medium(int_dx).thickness;
        % interface position
        itfc_position(int_dx-1) = cumulative_thickness;
    end
    % set first boundary to be 0
    itfc_position = itfc_position - max(itfc_position);
    
    % =====================================================================
    %   INTIALISE
    % =====================================================================
    % initialize outputs
    mat_prop(num_layers).alpha = [];
    mat_prop(num_layers).stiffness_matrix = [];
    mat_prop(num_layers).p_vec = [];
    
    
    % initialize field matrices
    field_matrices(num_layers).upper = [];
    field_matrices(num_layers).lower = [];
    itfc_phase(num_layers).up = [];
    itfc_phase(num_layers).dw = [];
    
    % initialize amplitude matrices
    amp_length = num_interfaces*4;
    unnorm_amplitudes = ...
        zeros(length(frequency_vec), length(angle_vec),amp_length ) ;
    % partial wave amplitudes
    partial_wave_amplitudes = ...
        zeros(length(frequency_vec), length(angle_vec),amp_length ) ;
    
    % output metric (determinant)
    metrics = zeros(length(frequency_vec), length(angle_vec));
    
    % field variables
    field_vars(num_interfaces).upper = [];
    field_vars(num_interfaces).lower = [];
    
    
    
    % =====================================================================
    %   ANGLE - FREQUENCY LOOP
    % =====================================================================
    
    for freq_idx = 1:length(frequency_vec)
        % loop over the different angles
        for angle_idx = 1:length(angle_vec)
            
            % basis of phase speed from first layer
            % angle and phase velocity
            angle = angle_vec(angle_idx);
            theta = angle * pi /180;
            
            cp = phase_velocity / sin(theta);
            % frequency
            omega = 2* pi * frequency_vec(freq_idx);
            k = omega / cp ;
            
            % =============================================================
            %   MATERIAL PROPERTIES FOR EACH LAYER
            % =============================================================
            
            % loop over the medium layers and extract the important properties
            %   alpha               - partial wave amplitudes
            %   stiffness_matrix    - stiffness matrix for each material
            %   p_vec               - polarization of each partial wave
            
            for layIdx = 1:length(medium)
                [ mat_prop(layIdx).alpha, mat_prop(layIdx).stiffness_matrix,...
                    mat_prop(layIdx).pVec ] = Medium.calculateAlphaCoefficients(...
                    medium(layIdx).stiffness_matrix, cp, medium(layIdx).density );
            end
            
            % =================================================================
            %   CALCULATE FIELD MATRICIES AND BUILD GLOBAL MATRIX
            % =================================================================
            
            
            % calculate field matrices for each layer with the relative
            % interface positions
            for ifc_idx = 1:num_interfaces
                % which material layer
                idx_up = ifc_idx;
                idx_lw = ifc_idx + 1;
                
                % upper field matrix of interface
                [field_matrices(ifc_idx).upper, itfc_phase(ifc_idx).up  ]   = ...
                    ElasticMatrix.calculateFieldMatrixAnisotropic(...
                    mat_prop(idx_up).alpha, k, itfc_position(ifc_idx), ...
                    mat_prop(idx_up).stiffness_matrix, mat_prop(idx_up).pVec );
                
                % lower field matrix of interface
                [field_matrices(ifc_idx).lower, itfc_phase(ifc_idx).dw ]    = ...
                    ElasticMatrix.calculateFieldMatrixAnisotropic(...
                    mat_prop(idx_lw).alpha, k, itfc_position(ifc_idx), ...
                    mat_prop(idx_lw).stiffness_matrix, mat_prop(idx_lw).pVec );
            end
            
            % scaling factor for the field matrices as the stress equations
            % are significantly larger, this is sometimes 1
            scale_fac = omega^2 * medium(1).density;
            
            
            % initialize the global matrix
            global_matrix = zeros(num_interfaces*4, num_layers*4);
            
            % build system matrix - loop over the number of interfaces
            for ifc_idx = 1:num_interfaces
                
                % relative indices for where the field matrices are placed
                indFactor = ((ifc_idx - 1) * 4 );
                indUp1 = indFactor + 1;
                indUp2 = indFactor + 4;
                
                indLw1 = indFactor + 5;
                indLw2 = indFactor + 8;
                
                % upper side of each interface
                global_matrix(indUp1:indUp2, indUp1:indUp2) = ...
                    field_matrices(ifc_idx).upper;
                % lower side of the interface
                global_matrix(indUp1:indUp2, indLw1:indLw2) = ...
                    -field_matrices(ifc_idx).lower;
                
                % scale the stress rows
                global_matrix([indUp1+2,indUp2],:) = ...
                    global_matrix([indUp1+2,indUp2],:) ./ scale_fac;
                
            end
            
            % =================================================================
            %   BUILD GLOBAL MATRIX - KNOWNS
            % =================================================================
            
            % incident wave amplitude set to 1 MPa
            P_0 = 1e6;
            B_1 = (P_0 * 1i*k) / (medium(1).density*omega^2);
            
            % solve in the form of Ax = b;
            % where b is the knowns of the equation
            % x is the amplitude vector of the partial waves
            % and A is the global matrix
            knowns = -global_matrix(:,[2, 4, end-3 ,end-1]) * ...
                [0; B_1; 0; 0];
            % build system matrix
            sys_mat = global_matrix(:,[1,3,5:end-4,end-2,end]);
            
            % inverse system of equations
            output = sys_mat \ knowns;
            
            unnorm_amplitudes(freq_idx, angle_idx, :) = output;
            % partial wave amplitudes
            partial_wave_amplitudes(freq_idx, angle_idx, :) = ...
                zeros(size(output));
            
            % the output dispersion metric (determinant)
            metrics( freq_idx, angle_idx )     = (det(  sys_mat));
            
            % loop over each layer
            for layerIdx = 1:num_layers
                switch layerIdx
                    
                    case 1
                        % first layer / reflection coefficient
                        partial_wave_amplitudes(freq_idx, angle_idx, 1) = ...
                            output(1) / B_1 / mat_prop(layerIdx).alpha(1);
                        partial_wave_amplitudes(freq_idx, angle_idx, 2) = ...
                            output(2) / B_1 ;
                        
                        
                        
                    case num_layers
                        output_idx = 4*(layerIdx - 2)+ [3,4];
                        % last layer/ transmission coefficient
                        partial_wave_amplitudes(freq_idx, angle_idx, output_idx(1)) = ...
                            output(output_idx(1)) / B_1 / mat_prop(layerIdx).alpha(1);
                        partial_wave_amplitudes(freq_idx, angle_idx, output_idx(2)) = ...
                            output(output_idx(2)) / B_1 ;
                        
                    otherwise
                        % intermediate coefficients
                        output_idx = 4*(layerIdx - 2)+ [3,4,5,6];
                        % shear outputs
                        partial_wave_amplitudes(freq_idx, angle_idx, output_idx(1)) = ...
                            output(output_idx(1)) / B_1 / mat_prop(layerIdx).alpha(1);
                        partial_wave_amplitudes(freq_idx, angle_idx, output_idx(2)) = ...
                            output(output_idx(2)) / B_1 / mat_prop(layerIdx).alpha(1);
                        
                        % compressional outputs
                        partial_wave_amplitudes(freq_idx, angle_idx, output_idx(3)) = ...
                            output(output_idx(3)) / B_1 ;
                        partial_wave_amplitudes(freq_idx, angle_idx, output_idx(4)) = ...
                            output(output_idx(4)) / B_1 ;
                        
                end
            end
            
            % =============================================================
            %   CALCULATE OUTPUT DISPLACEMENTS - FULL ELASTIC MATRIX
            % =============================================================
            
            if return_field_var == 1
                % loop over the number of interfaces and calculate the displacement
                if num_interfaces == 1
                    % for a single interface
                    idx = 1;
                    
                    % all field variables uppers
                    field_vars(idx).upper(freq_idx, angle_idx, 1:4) = ...
                        field_matrices(idx).upper(:,[1 3 4]) * [output(1:2) ; B_1 ];
                    
                    % all field variables lower
                    field_vars(idx).lower(freq_idx, angle_idx, 1:4) = ...
                        field_matrices(idx).lower(:,[2 4]) * output(3:4);
                else
                    % for more than one interface
                    for idx = 1:num_interfaces
                        choice = (idx - 2)*4 + 3;
                        
                        switch idx
                            case 1
                                % all field variables uppers
                                field_vars(idx).upper(freq_idx, angle_idx, 1:4) = ...
                                    field_matrices(idx).upper(:,[1 3 4]) * [output(1:2) ; B_1 ];
                                
                                % all field variables lower
                                field_vars(idx).lower(freq_idx, angle_idx, 1:4) = ...
                                    field_matrices(idx).lower(:,:) * output(3:6);
                                
                            case num_interfaces
                                % all field variables upper
                                field_vars(idx).upper(freq_idx, angle_idx, 1:4) = ...
                                    field_matrices(idx).upper(:,:) * output(choice:choice+3);
                                
                                % all field variables lower
                                field_vars(idx).lower(freq_idx, angle_idx, 1:4) = ...
                                    field_matrices(idx).lower(:,[2,4]) * output(choice+4:end);
                                
                            otherwise
                                % all field variables upper
                                field_vars(idx).upper(freq_idx, angle_idx, 1:4) = ...
                                    field_matrices(idx).upper(:,:) * output(choice:choice+3);
                                
                                % all field variables lower
                                field_vars(idx).lower(freq_idx, angle_idx, 1:4) = ...
                                    field_matrices(idx).lower(:,:) * output(choice+4:choice+7);
                        end
                    end
                end % if num_of_interface
            end % return displacements
            
        end
    end
    
    
    
end

