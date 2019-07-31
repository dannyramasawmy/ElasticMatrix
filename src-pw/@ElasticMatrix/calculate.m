function obj = calculate(obj)
    %CALCULATE Partial wave method for an incident wave problem.
    %
    % DESCRIPTION
    %   CALCULATE runs the partial wave method over a range of frequencies,
    %   angles, wave-numbers or phase-speeds.
    %
    %   The partial wave method, represents the stress and displacement
    %   fields within a material as a sum of partial waves. For an
    %   isotropic material, each partial wave describes an upward or
    %   downward traveling compressional or shear wave. For anisotropic
    %   materials these are quasi-compressional and quasi-shear waves. The
    %   stresses and displacements must be continuous at the interfaces
    %   between rigidly-bonded adjacent layers. By invoking these boundary
    %   conditions at every interface, the partial wave amplitudes and
    %   field properties of the first layer can be related to the last in
    %   the form of a ‘global’ matrix.
    %
    %   The resulting matrix equation can be used in two different ways.
    %   Firstly, the roots of the equation can be found which give the
    %   modal solutions or dispersion curves (see
    %   .calculateDispersionCurves). Secondly, a subset of partial-wave
    %   amplitudes can be defined and the remaining amplitudes solved for.
    %   This is the method employed in this function. See [1,2,3] for more
    %   detail.
    %
    %   Firstly a range of frequencies must be defined using .setFrequency.
    %   Then at least one of angle, wavenumber or phase-speed must be
    %   defined using their respective set functions. If more than two of
    %   these properties are defined, .calculate sort the inputs and use
    %   frequency, plus one other property in the order of preference from
    %   first to last: (1) angle - (2) phase-speed - (3) wavenumber.
    %   .calculate will call the .calculateMatrixModel static method and
    %   assign the outputs to the appropriate properties. These are the
    %   stresses and displacements at the interfaces of the layers and the
    %   partial wave amplitudes.
    %
    %   References:
    %   [1] Ramasawmy, Danny R., et al. "ElasticMatrix: A MATLAB Toolbox
    %       for Anisotropic Elastic Wave Propagation in Layered Media.",
    %       (2019).
    %
    %   [2] Lowe, Michael JS. "Matrix techniques for modeling ultrasonic
    %       waves in multilayered media." IEEE transactions on ultrasonics,
    %       ferroelectrics, and frequency control, (1995).
    %
    %   [3] Nayfeh, Adnan H. "The general problem of elastic wave
    %       propagation in multilayered anisotropic media." The Journal of
    %       the Acoustical Society of America (1991).
    %
    %
    % USEAGE
    %   obj.calculate;
    %
    % INPUTS
    %   obj.frequency           - A vector of frequencies.      [Hz]
    %   obj.angle               - A vector of angles.           [degree]
    %   obj.wavenumber          - A vector of wave-numbers.     [1/m]
    %   obj.phasespeed          - A vector of phase-speeds.     [m/s]
    %   obj.medium              - A Medium object.
    %
    % OPTIONAL INPUTS
    %   []              - There are no optional inputs. []
    %
    % OUTPUTS
    %   obj.x_displacement             - x-displacement at each interface.
    %   obj.z_displacement             - z-displacement at each interface.
    %   obj.sigma_zz                   - Normal stress at each interface.
    %   obj.sigma_xz                   - Shear stress at interface.
    %   obj.partial_wave_amplitudes    - See below.
    %
    %   The partial wave amplitudes are of size [n_freqs X n_other X
    %   amplitude], where n_other is the number of angles, frequencies or
    %   wave-numbers. Amplitudes is of length 4*(N-1) where N is the number
    %   of layers.
    %   The partial wave amplitude order:
    %       - amplitudes(1)     - Upwards qSV in 1st layer (reflected).
    %       - amplitudes(2)     - Upward qL in 1st layer (reflected).
    %       - amplitudes(end)   - Downward qSV in last layer (transmitted).
    %       - amplitudes(end-1) - Downward qL in last layer (transmitted).
    %
    %   ... for layer n = {2,...end-1}
    %       - amplitudes(4(n - 2) + 3) - Upwards qSV.
    %       - amplitudes(4(n - 2) + 4) - Downwards qSV.
    %       - amplitudes(4(n - 2) + 5) - Upwards qL.
    %       - amplitudes(4(n - 2) + 6) - Downwards qL.
    %
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
    % calculate
    
    % =====================================================================
    %   CHECK INPUTS AND SORT ARGUMENTS (PROPERTIES)
    % =====================================================================
    disp('... calculating matrix method ... ')
    
    % sort input arguments
    [input_vector] = checkInputs(obj);
    
    % throw an error if the input_vecotr returns a nan
    if isnan(input_vector)
        error('.calculate failed, check input arguments.')
    end
    
    % =====================================================================
    %   SELECT APPROPRIATE STATIC METHOD AND CALCULATE
    % =====================================================================
    
    % calculate over a range of angles and frequencies
    if sum(input_vector == [1 1 0 0]) == 4
        disp('... frequency-angle calculation ...')
        % for calculating the matrix model in terms of angle and frequency
        [~,field_variables, partial_wave_amplitudes, unnorm_amplitudes] ...
            = ElasticMatrix.calculateMatrixModel(...
            obj.medium, obj.frequency, obj.angle, 1);
    end
    
    % calculate over a range of phase-speeds and frequencies
    if sum(input_vector == [1 0 1 0]) == 4
        disp('... frequency-phasespeed calculation ...')
        % for calculating the matrix model in terms of frequency-phase-speed
        [~,field_variables, partial_wave_amplitudes, unnorm_amplitudes] ...
            = calculateMatrixModelFCphWrapper(...
            obj.medium, obj.frequency, obj.phasespeed, 1);
    end
    
    % calculate over a range of phase-speeds and frequencies
    if sum(input_vector == [1 0 0 1]) == 4
        disp('... frequency-wavenumber calculation ...')
        % for calculating the model in terms of wavenumber and frequency
        [~,field_variables, partial_wave_amplitudes, unnorm_amplitudes] ...
            = calculateMatrixModelKFWrapper(...
            obj.medium, obj.frequency, obj.wavenumber, 1);
    end
    
    % =====================================================================
    %   DISSEMINATE OUTPUTS
    % =====================================================================
    
    % loop and assign field variables
    for idx = 1:length(field_variables)
        
        % assign normal displacement
        obj.z_displacement(idx).upper = field_variables(idx).upper(:,:,1);
        obj.z_displacement(idx).lower = field_variables(idx).lower(:,:,1);
        
        % assign transverse displacement
        obj.x_displacement(idx).upper = field_variables(idx).upper(:,:,2);
        obj.x_displacement(idx).lower = field_variables(idx).lower(:,:,2);
        
        % assign normal stress
        obj.sigma_zz(idx).upper = field_variables(idx).upper(:,:,3);
        obj.sigma_zz(idx).lower = field_variables(idx).lower(:,:,3);
        
        % assign shear stress
        obj.sigma_xz(idx).upper = field_variables(idx).upper(:,:,4);
        obj.sigma_xz(idx).lower = field_variables(idx).lower(:,:,4);
        
    end
    
    % for each partial wave amplitude
    obj.partial_wave_amplitudes = partial_wave_amplitudes;
    obj.unnormalised_amplitudes = unnorm_amplitudes;
    
    % exit message
    disp('... done ... ')
    
    warning on
    
end


function [input_vector] = checkInputs(obj)
    %INPUTCHECK Checks the inputs for the current function.
    %
    % DESCRIPTION
    %   INPUTCHECK(obj) checks the inputs for the function .calculate(...).
    %   If any of the inputs are not valid, the function will break and
    %   print errors to screen.
    %
    % USAGE
    %   inputChecks(obj);
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 20 - July - 2019
    %   last update     - 31 - July - 2019
    
    warning on
    
    % initialize vector
    input_vector = [0 0 0 0];
    
    % check input frequency, this must be defined
    if isempty(obj.frequency)
        warning('obj.frequency must be defined')
        input_vector = NaN;
        return;
    else
        input_vector(1) = 1;
    end
    
    % check input angles
    if ~isempty(obj.angle)
        input_vector(2) = 1;
    end
    
    % check input phase speed
    if ~isempty(obj.phasespeed)
        input_vector(3) = 1;
    end
    
    % check input wavenumber
    if ~isempty(obj.wavenumber)
        input_vector(4) = 1;
    end
    
    % check correct number of inputs
    if sum(input_vector) < 2
        % only one input argument defined
        input_vector = NaN;
        warning(['Incorrect number of inputs, please define 2 of 4 from ',...
            'frequency (must include), angle, phasespeed, wavenumber']);
        
    elseif sum(input_vector) > 2
        % take the first two non-zero elements (frequency should already be
        % a 1 from the first input check
        nonZeroIdxs = find(input_vector);
        % reset input vector
        input_vector = [0 0 0 0];
        input_vector(nonZeroIdxs(1:2)) = 1;
    end
    
    warning off
end

function [metrics, field_variables, partial_wave_amplitudes, unnormalised_amplitudes]...
        = calculateMatrixModelKFWrapper(medium, frequency, wavenumber, flag)
    %CALCULATEMATRIXMODELKFWRAPPER calculateMatrixModelKf.
    %
    % DESCRIPTION
    %   CALCULATEMATRIXMODELKFWRAPPER(...) uses calculateMatrixModelKf,
    %   this function ensures the inputs and outputs of .calculate are
    %   in the correct format.
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 20 - July - 2019
    %   last update     - 31 - July - 2019
    
    % initialize outputs
    metrics = 0;
    n_interfaces = length(medium)-1;
    amp_length = (n_interfaces)*4;
    % partial wave amplitudes
    partial_wave_amplitudes = ...
        zeros(length(frequency), length(wavenumber),amp_length ) ;
    unnormalised_amplitudes = zeros(size(partial_wave_amplitudes));
    % field variables
    field_variables(n_interfaces).upper = [];
    field_variables(n_interfaces).lower = [];
    
    % run frequency wavenumber
    for idx = 1:length(wavenumber)
        
        % run calculations
        [~, tmp_field_variables, tmp_p_w_a, tmp_u_amplitudes] = ...
            ElasticMatrix.calculateMatrixModelKf(...
            medium, frequency, wavenumber(idx)*ones(1,length(frequency)),...
            flag);
        
        % assign outputs
        partial_wave_amplitudes(:, idx, :) = tmp_p_w_a;
        unnormalised_amplitudes(:, idx, :) = tmp_u_amplitudes;
        
        % assign field variables
        for layerDx = 1:length(tmp_field_variables)
            field_variables(layerDx).upper(:,idx,:) = ...
                tmp_field_variables(layerDx).upper;
            field_variables(layerDx).lower(:,idx,:) = ...
                tmp_field_variables(layerDx).lower;
        end
        
    end
    
    
    
end

function [metrics, field_variables, partial_wave_amplitudes, unnormalised_amplitudes]...
        = calculateMatrixModelFCphWrapper(medium, frequency, phasespeed, flag)
    %CALCULATEMATRIXMODELFCphWRAPPER calculateMatrixModelKf.
    %
    % DESCRIPTION
    %   CALCULATEMATRIXMODELFCphWRAPPER(...) uses calculateMatrixModelKf,
    %   this function ensures the inputs and outputs of .calculate are
    %   in the correct format.
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 20 - July - 2019
    %   last update     - 31 - July - 2019
    
    % initialize outputs
    metrics = 0;
    n_interfaces = length(medium)-1;
    amp_length = (n_interfaces)*4;
    % partial wave amplitudes
    partial_wave_amplitudes = ...
        zeros(length(frequency), length(phasespeed),amp_length ) ;
    unnormalised_amplitudes = zeros(size(partial_wave_amplitudes));
    % field variables
    field_variables(n_interfaces).upper = [];
    field_variables(n_interfaces).lower = [];
    
    % run frequency wavenumber
    for idx = 1:length(phasespeed)
        % for calculating the model in terms of wavenumber and frequency
        wavenumber = 2*pi*frequency / phasespeed(idx);
        
        % run calculations
        [~, tmp_field_variables, tmp_p_w_a, tmp_u_amplitudes] = ...
            ElasticMatrix.calculateMatrixModelKf(...
            medium, frequency, wavenumber, flag);
        
        % assign outputs
        partial_wave_amplitudes(:, idx, :) = tmp_p_w_a;
        unnormalised_amplitudes(:, idx, :) = tmp_u_amplitudes;
        
        % assign field variables
        for layerDx = 1:length(tmp_field_variables)
            field_variables(layerDx).upper(:,idx,:) = ...
                tmp_field_variables(layerDx).upper;
            field_variables(layerDx).lower(:,idx,:) = ...
                tmp_field_variables(layerDx).lower;
        end
        
    end
    
end



