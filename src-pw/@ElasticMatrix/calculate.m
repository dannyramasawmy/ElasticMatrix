function obj = calculate(obj)
    % Calcualte method runs the partial wave implementation
    warning off % sometimes it will spit out a warning
    
    disp('... Calculating matrix method ... ')
    % calculate the partial wave method
    
    [~,fieldVariables, partialWaveAmplitudes, unnormalisedAmplitudes, temp ] ...
        = calculateMatrixModel(...
        obj.medium, obj.frequency, obj.angle, 1);
    
    % DEBUG / FUTURE CODE - have everything in terms of the K-f matrix
    % model
    %      [~,field_variables, partial_wave_amplitudes, unnormalised_amplitudes, temp ] ...
    %         = Calculate_Matrix_Model_Kf(...
    %         obj.medium, obj.frequency, obj.angle, 1);
    
    
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