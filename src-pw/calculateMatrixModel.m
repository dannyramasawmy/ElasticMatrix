function [metrics, fieldVariables, partial_wave_amplitudes, unnormalised_amplitudes temp] = ...
        calculateMatrixModel( medium, frequencyVec, angleVec, returnFieldVariable, varargin )
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
    %
    %       INPUTS:
    %           medium - medium class
    %
    %       OUTPUTS
    %           displacements at each interface
    %
    % ERROR     :   2019 - 01 - 17
    %           :   FIND ME - need to check the first layer information
    %           :   2019 - 01 - 31 - some error in the reflection and
    %           transmisison coefficients
    %
    %
    % =====================================================================
    %   ALTERNATIVE FUNCTIONS
    % =====================================================================
    
    % the dispersion calculation will not return the field variables
    if returnFieldVariable ~= 1
        fieldVariables = 0;
    end
    
    % =====================================================================
    %   PRECALCULATIONS
    % =====================================================================
    
    % final phase velocity
    phaseVel = sqrt(medium(1).stiffness_matrix(1,1) / medium(1).density);
    
    % the number of layers
    numLayers = length(medium);
    
    % the number of interfaces
    numInterfaces = numLayers - 1;
    
    % INTERFACE LOCATIONS =================================================
    
    % get the position of each interface, 0 is at the bottom halfspace interface
    cumulativeThickness = 0e-6;
    itfcPosition(numLayers-1) = cumulativeThickness;
    % loop over layers in the medium and extract thickness
    for int_dx = numLayers-1:-1:2
        % sum thicknesses apart from the 1 & N layers  (halfspaces)
        cumulativeThickness = cumulativeThickness + medium(int_dx).thickness;
        % interface position
        itfcPosition(int_dx-1) = cumulativeThickness;
    end
    % set first boundary to be 0
    itfcPosition = itfcPosition - max(itfcPosition);
    
    % =====================================================================
    %   ANGLE - FREQUENCY LOOP
    % =====================================================================
    
    for freqIdx = 1:length(frequencyVec)
        % loop oover the different angles
        for angleIdx = 1:length(angleVec)
            
            % basis of phase speed from first layer
            % angle and phase velocity
            angle = angleVec(angleIdx);
            theta = angle * pi /180;
            
            cp = phaseVel / sin(theta);
            % frequency
            omega = 2* pi * frequencyVec(freqIdx);
            k = omega / cp ;
            
            % =============================================================
            %   MATERIAL PROPERTIES FOR EACH LAYER
            % =============================================================
            
            % loop over the medium layers and extract the important properties
            %   alpha - partial wave amplitudes
            %   stiffness matrix - stiffness matrix for each material
            %   p_vec - polarisation of each partial wave
            for layIdx = 1:length(medium)
                [ matProp(layIdx).alpha, matProp(layIdx).stiffness_matrix, matProp(layIdx).pVec ] = ...
                    calculateAlphaCoefficients(...
                    medium(layIdx).stiffness_matrix, cp, medium(layIdx).density );
            end
            
            
            
            % =================================================================
            %   CALCULATE FIELD MATRICIES AND BUILD GLOBAL MATRIX
            % =================================================================
            
            % initalise global matrix #### FIND ME ### check if liquid or soild
            %
            globalMatrixLength = numInterfaces * 4 - 1;
            sys_mat = zeros(globalMatrixLength);
            knowns = zeros(globalMatrixLength,1);
            
            % calculate field matrices for each layer with the relative
            % interface positions
            for ifcIdx = 1:numInterfaces
                % which material layer
                idx_up = ifcIdx;
                idx_lw = ifcIdx + 1;
                
                % upper field matrix of interface
                [fieldMatrices(ifcIdx).upper, itfcPhase(ifcIdx).up  ]   = ...
                    calculateFieldMatrixAnisotropic(...
                    matProp(idx_up).alpha, k, itfcPosition(ifcIdx), matProp(idx_up).stiffness_matrix, matProp(idx_up).pVec );
                
                % lower field matrix of interface
                [fieldMatrices(ifcIdx).lower, itfcPhase(ifcIdx).dw ]    = ...
                    calculateFieldMatrixAnisotropic(...
                    matProp(idx_lw).alpha, k, itfcPosition(ifcIdx), matProp(idx_lw).stiffness_matrix, matProp(idx_lw).pVec );
            end
            
            % scaling factor for the field matrices as the stress equations
            % are significantly larger, this is sometimes 1
            scaleFm = omega^2 * medium(2).density;
            
            
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
            sys_mat = globalMatrix(:,[1,3,5:end-4,end-2,end]);
            
            % inverse system of equations
            output = sys_mat \ knowns;
            
            unnormalised_amplitudes(freqIdx, angleIdx, :) = output;
            % partial wave amplitudes
            partial_wave_amplitudes(freqIdx, angleIdx, :) = ...
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
            metrics( freqIdx, angleIdx )     = (det(  sys_mat));
            
            % FIND ME DEBUG
            % loop over each layer
            for layerIdx = 1:numLayers
                switch layerIdx
                    
                    case 1
                        % first layer / reflection coefficient
                        partial_wave_amplitudes(freqIdx, angleIdx, 1) = ...
                            output(1) / B_1 / matProp(layerIdx).alpha(1);
                        partial_wave_amplitudes(freqIdx, angleIdx, 2) = ...
                            output(2) / B_1 ;
                        
                        
                        
                    case numLayers
                        output_idx = 4*(layerIdx - 2)+ [3,4];
                        % last layer/ transmission coefficient
                        partial_wave_amplitudes(freqIdx, angleIdx, output_idx(1)) = ...
                            output(output_idx(1)) / B_1 / matProp(layerIdx).alpha(1);
                        partial_wave_amplitudes(freqIdx, angleIdx, output_idx(2)) = ...
                            output(output_idx(2)) / B_1 ;
                        
                    otherwise
                        % intermediate coefficients
                        output_idx = 4*(layerIdx - 2)+ [3,4,5,6];
                        % shear outputs
                        partial_wave_amplitudes(freqIdx, angleIdx, output_idx(1)) = ...
                            output(output_idx(1)) / B_1 / matProp(layerIdx).alpha(1);
                        partial_wave_amplitudes(freqIdx, angleIdx, output_idx(2)) = ...
                            output(output_idx(2)) / B_1 / matProp(layerIdx).alpha(1);
                        
                        % compressional outputs
                        partial_wave_amplitudes(freqIdx, angleIdx, output_idx(3)) = ...
                            output(output_idx(3)) / B_1 ;
                        partial_wave_amplitudes(freqIdx, angleIdx, output_idx(4)) = ...
                            output(output_idx(4)) / B_1 ;
                        
                end
            end
            
            
            % incident field is the B_1 column of the field matrix (3rd
            % row)
            % reflected field is output (1 + 2)
            % all field variables uppers
            % FIND ME DEBUG
            %{
            iNormlStress = abs(fieldMatrices(1).upper(3,[4]) * B_1) ;
            rNormlStress = abs(fieldMatrices(1).upper(3,[1 3 4]) * [output(1:2); B_1]);
            rShearStress = abs(fieldMatrices(1).upper(4,[1 3 4]) * [output(1:2); B_1]);
            tNormlStress = abs(fieldMatrices(end).lower(3,[2,4]) * output([end-1, end]));
            tShearStress = abs(fieldMatrices(end).lower(4,[2,4]) * output([end-1, end]));
            
            RL = rNormlStress / iNormlStress;
            RS = rShearStress / iNormlStress;
            TL = tNormlStress / iNormlStress;
            TS = tShearStress / iNormlStress;
            
            temp(freqIdx, angleIdx, :) = [RL, RS, TL, TS] ;
            %}
            
            %
            %     field_variables(idx).upper(freq_idx, angle_idx, 1:4) = ...
            %       field_matrices(idx).upper(:,[1 3 4]) * [output(1:2) ; B_1 ];
            
            
            %     % all field variables lower
            %     field_variables(idx).lower(freq_idx, angle_idx, 1:4) = ...
            %                  field_matrices(idx).lower(:,[2,4]) * output(choice+4:end);
            
            
            % =============================================================
            %   CALCULATE OUTPUT DISPLACEMENTS - FULL ELASTIC MATRIX
            % =============================================================
            
            if returnFieldVariable == 1
                % loop over th enumber of interfaces and calcualte the dispalcement
                if numInterfaces == 1
                    % for a single interface
                    idx = 1;
                    
                    % all field variables uppers
                    fieldVariables(idx).upper(freqIdx, angleIdx, 1:4) = ...
                        fieldMatrices(idx).upper(:,[1 3 4]) * [output(1:2) ; B_1 ];
                    
                    % all field variables lower
                    fieldVariables(idx).lower(freqIdx, angleIdx, 1:4) = ...
                        fieldMatrices(idx).lower(:,[2 4]) * output(3:4);
                else
                    % for more than one interface
                    for idx = 1:numInterfaces
                        choice = (idx - 2)*4 + 3;
                        
                        switch idx
                            case 1
                                % all field variables uppers
                                fieldVariables(idx).upper(freqIdx, angleIdx, 1:4) = ...
                                    fieldMatrices(idx).upper(:,[1 3 4]) * [output(1:2) ; B_1 ];
                                
                                % all field variables lower
                                fieldVariables(idx).lower(freqIdx, angleIdx, 1:4) = ...
                                    fieldMatrices(idx).lower(:,:) * output(3:6);
                                
                            case numInterfaces
                                % all field variables upper
                                fieldVariables(idx).upper(freqIdx, angleIdx, 1:4) = ...
                                    fieldMatrices(idx).upper(:,:) * output(choice:choice+3);
                                
                                % all field variables lower
                                fieldVariables(idx).lower(freqIdx, angleIdx, 1:4) = ...
                                    fieldMatrices(idx).lower(:,[2,4]) * output(choice+4:end);
                                
                            otherwise
                                % all field variables upper
                                fieldVariables(idx).upper(freqIdx, angleIdx, 1:4) = ...
                                    fieldMatrices(idx).upper(:,:) * output(choice:choice+3);
                                
                                % all field variables lower
                                fieldVariables(idx).lower(freqIdx, angleIdx, 1:4) = ...
                                    fieldMatrices(idx).lower(:,:) * output(choice+4:choice+7);
                        end
                    end
                end % if num_of_interface
            end % return displacemnts
            
        end
    end
    
    
    
end

