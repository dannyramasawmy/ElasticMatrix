function [metrics, fieldVariables, partialWaveAmplitudes, unnormalisedAmplitudes temp] = ...
        calculateMatrixModelKf( medium, frequencyVec, wavenumberVec, returnFieldVariable, varargin )
    %% Solve_Matrix_Model - v1.0 Date: 2018-
    %
    % Author    :   Danny Ramasawmy
    %               rmapdrr@ucl.ac.uk
    %               dannyramasawmy@gmail.com
    % Date      :   2019 - 01 - 17 -  created
    %
    %
    % Description
    %   Solves the partial wave model.
    %       1 = x direction
    %       3 = z direction
    %       this function is done in wavenumber(Kx)-frequency space for the
    %       dispersion curve calculation
    %
    %       INPUTS:
    %           medium - medium classz
    %
    %       OUTPUTS
    %           displacements at each interface
    %
    % ERROR     :   2019 - 01 - 17
    %           :   FIND ME - need to check the first layer information
    %           :   2019 - 01 - 31 - some error in the reflection and
    %           transmisison coefficients (some relationship to the phase
    %           information)
    %
    %
    % =====================================================================
    %   ALTERNATIVE FUNCTIONS
    % =====================================================================
    
    % the dispersion calculation will not return the field variables
    if returnFieldVariable ~= 1
        fieldVariables = 0;
    end
    
    % a debugging variable
    %     temp = [];
    % ## DEBGUG
    %     % overide functions - converts angles into phase velocities for
    %     % dispersion curve calcualtions
    %     if isempty(varargin)
    %
    %
    %     end
    
    
    % =====================================================================
    %   PRECALCULATIONS
    % =====================================================================
    
    % final phase velocity
    % phase_vel_limit = sqrt(medium(1).C_mat(1,1) / medium(1).Density);
    
    % the number of layers
    numLayers = length(medium);
    
    % the number of interfaces
    numInterfaces = numLayers - 1;
    
    % INTERFACE LOCATIONS =================================================
    
    % get the position of each interface, 0 is at the bottom halfspace interface
    cumulativeThickness = 0e-6;
    itfcPosition(numLayers-1) = cumulativeThickness;
    % loop over layers in the medium and extract thickness
    for intIdx = numLayers-1:-1:2
        % sum thicknesses apart from the 1 & N layers  (halfspaces)
        cumulativeThickness = cumulativeThickness + medium(intIdx).thickness;
        % interface position
        itfcPosition(intIdx-1) = cumulativeThickness;
    end
    % set first boundary to be 0
    itfcPosition = itfcPosition - max(itfcPosition);
    
    % =====================================================================
    %   WAVENUMBER - FREQUENCY LOOP
    % =====================================================================
    
    % check both the frequency_vecotr and wavenumber vector are the same
    % length
    if length(frequencyVec) ~= length(wavenumberVec)
        % break if vectors \rent the right length
        return;
    end
    
    % the number of loops
    nVector = length(frequencyVec);
    
    % loop over the vector length for frequency and wavenumber
    for fKIdx = 1:nVector
        
        
        % basis of phase speed from first layer
        % angle and phase velocity
        % angle = angle_vec(angle_idx);
        % theta = angle * pi /180;
        
        % cp = phase_vel_limit / sin(theta);
        % frequency
        omega = 2* pi * frequencyVec(fKIdx);
        
        % wavenumber
        k = wavenumberVec(fKIdx) ;
        
        % phase velocity
        cp = omega / k;
        
        % =============================================================
        %   MATERIAL PROPERTIES FOR EACH LAYER
        % =============================================================
        
        % loop over the medium layers and extract the important properties
        %   alpha - partial wave amplitudes
        %   C_mat - stiffness matrix for each material
        %   p_vec - polarisation of each partial wave
        for layIdx = 1:length(medium)
            [ matProp(layIdx).alpha, matProp(layIdx).cMat, matProp(layIdx).pVec ] = ...
                calculateAlphaCoefficients(...
                medium(layIdx).cMat, cp, medium(layIdx).density );
        end
        
        
        
        % =================================================================
        %   CALCULATE FIELD MATRICIES AND BUILD GLOBAL MATRIX
        % =================================================================
        
        % initalise global matrix #### FIND ME ### check if liquid or soild
        %
        globalMatrixLength = numInterfaces * 4 - 1;
        sysMat = zeros(globalMatrixLength);
        knowns = zeros(globalMatrixLength,1);
        
        % calculate field matrices for each layer with the relative
        % interface positions
        for ifcIdx = 1:numInterfaces
            % which material layer
            idxUp = ifcIdx;
            idxLw = ifcIdx + 1;
            
            % upper field matrix of interface
            [fieldMatrices(ifcIdx).upper, itfc_phase(ifcIdx).up  ]   = ...
                calculateFieldMatrixAnisotropic(...
                matProp(idxUp).alpha, k, itfcPosition(ifcIdx), matProp(idxUp).cMat, matProp(idxUp).pVec );
            
            % lower field matrix of interface
            [fieldMatrices(ifcIdx).lower, itfc_phase(ifcIdx).dw ]    = ...
                calculateFieldMatrixAnisotropic(...
                matProp(idxLw).alpha, k, itfcPosition(ifcIdx), matProp(idxLw).cMat, matProp(idxLw).pVec );
        end
        
        % scaling factor for the field matrices as the stress equations
        % are significantly larger
        scaleFm = omega^2 * medium(1).density;
        
        
        % initalise the global matrix
        globalMatrix = zeros(numInterfaces*4, numLayers*4);
        
        % build system matrix - loop over the number of interfaces
        for ifcIdx = 1:numInterfaces
            
            % relative indexs for where the field matricies are placed
            indFactor = ((ifcIdx - 1) * 4 );
            indUp1 = indFactor + 1;
            indUp2 = indFactor + 4;
            
            indLw1 = indFactor + 5;
            indLw2 = indFactor + 8;
            
            % upper side of each interface
            globalMatrix(indUp1:indUp2, indUp1:indUp2) = ...
                fieldMatrices(ifcIdx).upper;
            % lower side of the interface
            globalMatrix(indUp1:indUp2, indLw1:indLw2) = ...
                -fieldMatrices(ifcIdx).lower;
            
            % scale the stress rows
            globalMatrix([indUp1+2,indUp2],:) = ...
                globalMatrix([indUp1+2,indUp2],:) ./ scaleFm;
            
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
        knowns = -globalMatrix(:,[2, 4, end-3 ,end-1]) * ...
            [0; B_1; 0; 0];
        % build system matrix
        sysMat = globalMatrix(:,[1,3,5:end-4,end-2,end]);
        
        % inverse system of equations
        output = sysMat \ knowns;
        
        unnormalisedAmplitudes(fKIdx, :) = output;
        %             % partial wave amplitudes
        partialWaveAmplitudes(fKIdx, :) = ...
            zeros(size(output));
        
        % DEBUG direct comparison for  F - S - S
        %{
                        knowns2 = -global_matrix([1,3:end],[4]) * B_1;
            
            sys_mat2 = global_matrix([1,3:end],[3,5:end-4,end-2,end]);
            
            % inverse system of equations
            output2 = sys_mat2 \ knowns2;
        %}
        
        % DEBUG metrics for dispersion analysis
        %{
            % output metrics for dispersion analysis
            %             metrics.detr( freq_idx, angle_idx )     = det(  LHS);
            %             metrics.cond( freq_idx, angle_idx )     = cond( LHS);
            %             metrics.sysM( freq_idx, angle_idx ).S   = LHS       ;
            %             metrics.rank( freq_idx, angle_idx )     = rank( LHS);
        %}
        %             metrics( freq_idx, angle_idx ) = -abs(cond(sys_mat));
        metrics( fKIdx)     = (det(  sysMat));
        
        %{
              % FIND ME DEBUG
            % loop over each layer
            for layer_dx = 1:num_layers
                switch layer_dx
               
                    case 1
                        % first layer / reflection coefficient
                        partial_wave_amplitudes(freq_idx, kx_idx, 1) = ...
                            output(1) / B_1 / m_p(layer_dx).alpha(1);
                        partial_wave_amplitudes(freq_idx, kx_idx, 2) = ...
                            output(2) / B_1 ;
                        
                        
                          
                    case num_layers
                        output_idx = 4*(layer_dx - 2)+ [3,4];
                        % last layer/ transmission coefficient
                        partial_wave_amplitudes(freq_idx, kx_idx, output_idx(1)) = ...
                            output(output_idx(1)) / B_1 / m_p(layer_dx).alpha(1);
                        partial_wave_amplitudes(freq_idx, kx_idx, output_idx(2)) = ...
                            output(output_idx(2)) / B_1 ;
                                                    
                    otherwise
                        % intermediate coefficients
                        output_idx = 4*(layer_dx - 2)+ [3,4,5,6];
                        % shear outputs
                        partial_wave_amplitudes(freq_idx, kx_idx, output_idx(1)) = ...
                            output(output_idx(1)) / B_1 / m_p(layer_dx).alpha(1);
                        partial_wave_amplitudes(freq_idx, kx_idx, output_idx(2)) = ...
                            output(output_idx(2)) / B_1 / m_p(layer_dx).alpha(1);
                                                
                        % compressional outputs
                        partial_wave_amplitudes(freq_idx, kx_idx, output_idx(3)) = ...
                            output(output_idx(3)) / B_1 ;
                        partial_wave_amplitudes(freq_idx, kx_idx, output_idx(4)) = ...
                            output(output_idx(4)) / B_1 ;
                        
                end
            end
            
            % incident field is the B_1 column of the field matrix (3rd
            % row)
            % reflected field is output (1 + 2)
            % all field variables uppers
            % FIND ME DEBUG
            i_norml_stress = abs(field_matrices(1).upper(3,[4]) * B_1) ;
            r_norml_stress = abs(field_matrices(1).upper(3,[1 3 4]) * [output(1:2); B_1]);
            r_shear_stress = abs(field_matrices(1).upper(4,[1 3 4]) * [output(1:2); B_1]);
            t_norml_stress = abs(field_matrices(end).lower(3,[2,4]) * output([end-1, end]));
            t_shear_stress = abs(field_matrices(end).lower(4,[2,4]) * output([end-1, end]));
            
            RL = r_norml_stress / i_norml_stress;
            RS = r_shear_stress / i_norml_stress;
            TL = t_norml_stress / i_norml_stress;
            TS = t_shear_stress / i_norml_stress;
            
            temp(freq_idx, kx_idx, :) = [RL, RS, TL, TS] ;
            
            
            %
            %     field_variables(idx).upper(freq_idx, angle_idx, 1:4) = ...
            %       field_matrices(idx).upper(:,[1 3 4]) * [output(1:2) ; B_1 ];

                                
            %     % all field variables lower
            %     field_variables(idx).lower(freq_idx, angle_idx, 1:4) = ...
            %                  field_matrices(idx).lower(:,[2,4]) * output(choice+4:end);
                                
                                
            % =============================================================
            %   CALCULATE OUTPUT DISPLACEMENTS - FULL ELASTIC MATRIX
            % =============================================================
            
            if return_field_variable == 1;
                % loop over th enumber of interfaces and calcualte the dispalcement
                if num_of_interfaces == 1;
                    % for a single interface
                    idx = 1;
                    
                    % all field variables uppers
                    field_variables(idx).upper(freq_idx, kx_idx, 1:4) = ...
                        field_matrices(idx).upper(:,[1 3 4]) * [output(1:2) ; B_1 ];
                    
                    % all field variables lower
                    field_variables(idx).lower(freq_idx, kx_idx, 1:4) = ...
                        field_matrices(idx).lower(:,[2 4]) * output(3:4);
                else
                    % for more than one interface
                    for idx = 1:num_of_interfaces
                        choice = (idx - 2)*4 + 3;
                        
                        switch idx
                            case 1
                                % all field variables uppers
                                field_variables(idx).upper(freq_idx, kx_idx, 1:4) = ...
                                    field_matrices(idx).upper(:,[1 3 4]) * [output(1:2) ; B_1 ];
                                
                                % all field variables lower
                                field_variables(idx).lower(freq_idx, kx_idx, 1:4) = ...
                                    field_matrices(idx).lower(:,:) * output(3:6);
                                
                            case num_of_interfaces
                                % all field variables upper
                                field_variables(idx).upper(freq_idx, kx_idx, 1:4) = ...
                                    field_matrices(idx).upper(:,:) * output(choice:choice+3);
                                
                                % all field variables lower
                                field_variables(idx).lower(freq_idx, kx_idx, 1:4) = ...
                                    field_matrices(idx).lower(:,[2,4]) * output(choice+4:end);
                                
                            otherwise
                                % all field variables upper
                                field_variables(idx).upper(freq_idx, kx_idx, 1:4) = ...
                                    field_matrices(idx).upper(:,:) * output(choice:choice+3);
                                
                                % all field variables lower
                                field_variables(idx).lower(freq_idx, kx_idx, 1:4) = ...
                                    field_matrices(idx).lower(:,:) * output(choice+4:choice+7);
                        end
                    end
                end % if num_of_interface
            end % return displacemnts
            
        %}
        
        
    end
    
    
    
end

