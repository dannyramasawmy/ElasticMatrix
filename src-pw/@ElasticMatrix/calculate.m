function obj = calculate(obj)
    % calculate
    %
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    % The .calculate method runs the matrix method for 2 of 4
    % inputs, these are frequency, angle, phasespeed and wavenumber.
    % Currently, frequency must be defined and one other from either angle,
    % phasespeed and wavenumber. To define these use:
    %   obj.setFrequency( vector )
    %   obj.setAngle( vector )
    %   obj.setPhasespeed( vector )
    %   obj.setWavenumber( vector )
    % If more than two are defined the calculate function will sort the
    % inputs and use frequency, plus one more in the order of prefereance
    % from first to last:
    %  (1) frequency - (2) angle - (3) phasespeed - (4) wavenumber
    %
    % After calling the correct function, the .calculate method will assign
    % the output variables to attributes:
    %
    % the field variables are assigned to:
    %   obj.zDisplacement(layerIdx)
    %   obj.xDisplacement(layerIdx)
    %   obj.sigmaZZ(layerIdx)
    %   obj.sigmaXZ(layerIdx)
    %
    % The partial wave amplitudes are assigned to and organised as:
    %   obj.partialWaveAmplitudes (lengthFreqs X lengthVariable X amplitudes)
    %   - lengthVariable will be length of angles/wavenumber/phasespeed
    %   vector
    %   - amplitudes(1) = upward travelling in 1st layer (reflected) qSV
    %   - amplitudes(2) = upward travelling in 1st layer (reflected) qL
    %   - amplitudes(end) = downward travelling in last layer (transmitted) qL
    %   - amplitudes(end-1) = downward travelling in last layer
    %   (transmitted) qSV
    %   for layer n = {2,...end-1}
    %   - amplitudes(4(n - 2) + 3) = upwards qSV
    %   - amplitudes(4(n - 2) + 4) = downwards qSV
    %   - amplitudes(4(n - 2) + 5) = upwards qL
    %   - amplitudes(4(n - 2) + 6) = downwards qL
    %
    %   FUTURE
    %   - merge all matrix model calculations into a single function
    %   - explicit removal of fluid layers
    
    disp('... Calculating matrix method ... ')
    % calculate the partial wave method
    
    % sort input arguments
    [inputVector] = checkInputs(obj);
    
    if isnan(inputVector)
        warning('matrix model did not run, check input arguments')
        return;
    end
    
    % calculate over angles and frequncies
    if inputVector == [1 1 0 0]
        disp('... frequency-angle calculation ...')
        % for calculating the matrix model in terms of angle and frequency
        [~,fieldVariables, partialWaveAmplitudes, unnormalisedAmplitudes] ...
            = calculateMatrixModel(...
            obj.medium, obj.frequency, obj.angle, 1);
        
        % DEBUG
        temp = NaN;
    end
    
    % calculate over phasespeed and frequency
    if inputVector == [1 0 1 0]
        disp('... frequency-phasespeed calculation ...') 
        % for calculating the matrix model in terms of frequency-phasespeed
        [~,fieldVariables, partialWaveAmplitudes, unnormalisedAmplitudes] ...
            = calculateMatrixModelFCphWrapper(...
            obj.medium, obj.frequency, obj.phasespeed, 1);        
        % DEBUG
        temp = NaN;
    end
    
    if inputVector == [1 0 0 1]
        disp('... frequency-wavenumber calculation ...')
        % for calculating the model in terms of wavenumber and frequency
        
        [~,fieldVariables, partialWaveAmplitudes, unnormalisedAmplitudes] ...
            = calculateMatrixModelKFWrapper(...
            obj.medium, obj.frequency, obj.wavenumber, 1);
        
        % DEBUG
        temp = NaN;
    end
    
    
    % loop and assign field variables
    for idx = 1:length(fieldVariables)
        
        % assign normal displacment
        obj.zDisplacement(idx).upper = fieldVariables(idx).upper(:,:,1);
        obj.zDisplacement(idx).lower = fieldVariables(idx).lower(:,:,1);
        
        % assign tranvserse displacement
        obj.xDisplacement(idx).upper = fieldVariables(idx).upper(:,:,2);
        obj.xDisplacement(idx).lower = fieldVariables(idx).lower(:,:,2);
        
        % assign normal stress
        obj.sigmaZZ(idx).upper = fieldVariables(idx).upper(:,:,3);
        obj.sigmaZZ(idx).lower = fieldVariables(idx).lower(:,:,3);
        
        % assign shear stress
        obj.sigmaXZ(idx).upper = fieldVariables(idx).upper(:,:,4);
        obj.sigmaXZ(idx).lower = fieldVariables(idx).lower(:,:,4);
        
    end
    
    % for each partial wave amplitude
    obj.partialWaveAmplitudes = partialWaveAmplitudes;
    obj.unnormalisedAmplitudes = unnormalisedAmplitudes;
    
    % assign temporary variable for debugging
    obj.temp = temp;
    
    % exit message
    disp('... Done ... ')
    warning on
    
end


function [inputVector] = checkInputs(obj)
    % checkInputs
    %
    % This function checks the inputs to the calculate function and returns
    % an output which chooses which calculation will be used.
    %
    warning on
    
    % initalise vector
    inputVector = [0 0 0 0];
    
    % check input frequency, this must be defined
    if isempty(obj.frequency)
        warning('obj.frequency must be defined')
        inputVector = NaN;
        return;
    else
        inputVector(1) = 1;
    end
    
    % check input angles
    if ~isempty(obj.angle)
        inputVector(2) = 1;
    end
    
    % check input phase speed
    if ~isempty(obj.phasespeed)
        inputVector(3) = 1;
    end
    
    % check input wavenumber
    if ~isempty(obj.wavenumber)
        inputVector(4) = 1;
    end
    
    % check correct number of inputs
    if sum(inputVector) < 2
        % only one input argument defined
        inputVector = NaN;
        warning(['Incorrect number of inputs, please define 2 of 4 from ',...
            'frequency (must include), angle, phasespeed, wavenumber']);
        
    elseif sum(inputVector) > 2
        % take the first two non-zero elements (frequency should already be
        % a 1 from the first input check
        nonZeroIdxs = find(inputVector);
        % reset input vector
        inputVector = [0 0 0 0];
        inputVector(nonZeroIdxs(1:2)) = 1;
    end
    
    
    % the calculate model might give a warning for badly scaled matrices
    warning off
end

function [metrics, fieldVariables, partialWaveAmplitudes, unnormalisedAmplitudes]...
        = calculateMatrixModelKFWrapper(medium, frequency, wavenumber, fieldVariableFlag)
    % calculateMatrixModelKFWrapper
    %
    % as the implementation of the matrix model for KF is currently in a
    % different format to that of the angle-frequency, this function acts
    % as a wrapper to ensure the inputs and outputs are the same. In future
    % code all of the matrix model implementation will be in a single file
    
    % for calculating the model in terms of wavenumber and frequency
    
    
    % run frequency waveumner
    for idx = 1:length(wavenumber)
        
        % run calculations
        [tmpMetrics, tmpFieldVariables, tmpPartialWaveAmplitudes, tmpUnnormalisedAmplitudes] = ...
            calculateMatrixModelKf(...
            medium, frequency, wavenumber(idx)*ones(1,length(frequency)), fieldVariableFlag);
        
        metrics(:, idx) = transpose(tmpMetrics);
        partialWaveAmplitudes(:, idx, :) = tmpPartialWaveAmplitudes;
        unnormalisedAmplitudes(:, idx, :) = tmpUnnormalisedAmplitudes;
        
        % assign field variables
        for layerDx = 1:length(tmpFieldVariables)
            fieldVariables(layerDx).upper(:,idx,:) = tmpFieldVariables(layerDx).upper;
            fieldVariables(layerDx).lower(:,idx,:) = tmpFieldVariables(layerDx).lower;
        end
        
    end
    
end

function [metrics, fieldVariables, partialWaveAmplitudes, unnormalisedAmplitudes]...
        = calculateMatrixModelFCphWrapper(medium, frequency, phasespeed, fieldVariableFlag)
    % calculateMatrixModelFCphWrapper
    %
    % as the implementation of the matrix model for F-Cph is currently in a
    % different format to that of the angle-frequency, this function acts
    % as a wrapper to ensure the inputs and outputs are the same. In future
    % code all of the matrix model implementation will be in a single file
    
    % run frequency waveumner
    for idx = 1:length(phasespeed)
        % for calculating the model in terms of wavenumber and frequency
        wavenumber = 2*pi*frequency / phasespeed(idx);
        
        % run calculations
        [tmpMetrics, tmpFieldVariables, tmpPartialWaveAmplitudes, tmpUnnormalisedAmplitudes] = ...
            calculateMatrixModelKf(...
            medium, frequency, wavenumber, fieldVariableFlag);
        
        metrics(:, idx) = transpose(tmpMetrics);
        partialWaveAmplitudes(:, idx, :) = tmpPartialWaveAmplitudes;
        unnormalisedAmplitudes(:, idx, :) = tmpUnnormalisedAmplitudes;
        
        % assign field variables
        for layerDx = 1:length(tmpFieldVariables)
            fieldVariables(layerDx).upper(:,idx,:) = tmpFieldVariables(layerDx).upper;
            fieldVariables(layerDx).lower(:,idx,:) = tmpFieldVariables(layerDx).lower;
        end
        
    end
    
end



