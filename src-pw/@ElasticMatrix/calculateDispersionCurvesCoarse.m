function obj = calculateDispersionCurvesCoarse(obj)
    %CALCULATEDISPERSIONCURVESCOARSE Finds points on the dispersion curves.
    %
    % DESCRIPTION
    %   CALCULATEDISPERSIONCURVESCOARSE finds points on the the dispersion
    %   curves of the layered structure. This function should be used if
    %   .calculateDispersionCurves is not working correctly, for example if
    %   the tracing algorithm is giving incorrect results. Firstly, one
    %   parameter, for example frequency, is fixed and the determinant of
    %   the global-matrix is found over a range of wave-numbers. Close to
    %   dispersive solutions the determinant of the global-matrix tends to
    %   zero. Using these as starting points and taking a small limit
    %   either side, the exact frequency and wavenumber of the dispersive
    %   solution is found using a bisection algorithm. ElasticMatrix makes
    %   use of MATLAB's fmincon() function which finds the minimum within a
    %   fixed range. After the exact frequency-wavenumber pairs are found,
    %   the fixed value of frequency is increased and the search is
    %   performed again.
    %   
    %   The algorithm implemented in ElasticMatrix only searches in the
    %   real space which is a good-estimate for simple plate structures in
    %   a vacuum or liquid, however, it may be inaccurate for very leaky
    %   solutions, for example a plate embedded in soil.
    %
    %
    % USEAGE
    %   obj.calculateDispersionCurvesCoarse;
    %
    % INPUTS
    %   obj.frequency   - The range of frequencies (only the first and last
    %                     values are taken used).   [m/s]
    %
    % OPTIONAL INPUTS
    %   []              - There are no optional inputs. []
    %
    % OUTPUTS
    %   obj.dispersion_curves.      - A structure containing the  
    %                                 dispersion curve points.
    %       dispersion_curves.k     - Wavenumber vector.    [1/m]
    %       dispersion_curves.f     - Frequency vector.     [Hz, 1/s]
    %       dispersion_curves.c     - Phase-speed vector.   [m/s]
    %
    % DEPENDENCIES
    %   []              - There are no dependencies.     []
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - January  - 2019
    %   last update     - 22 - August   - 2019
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
    
    % the matrix will become singular at dispersion solutions
    warning off
    
    % =====================================================================
    %   FIND THE SOUND-SPEEDS OF EACH MATERIAL
    % =====================================================================
    % initialize
    lowest_cph = [];
    comp_speeds = [];
    shear_speeds = [];
    
    % material sorting
    for mat_idx = 1:length(obj.medium)
        
        % material state
        material_state = obj.medium(mat_idx).state;
        % identify state
        switch 1
            case strcmp(material_state,'Vacuum')
                stiff_coeff = NaN;
                
            case strcmp(material_state,'Liquid')
                stiff_coeff = [1,1];
                
            case strcmp(material_state,'Isotropic')
                stiff_coeff = [5,5];
                
            otherwise
                stiff_coeff = [5,5];
        end
        
        % if it is a NaN then skip
        if isnan(stiff_coeff)
            continue
        end
        
        % get sound speed
        tmp_cmp = sqrt(...
            obj.medium(mat_idx).stiffness_matrix(1, 1) / ...
            obj.medium(mat_idx).density);
        % get sound speed
        tmp_shr = sqrt(...
            obj.medium(mat_idx).stiffness_matrix(5, 5) / ...
            obj.medium(mat_idx).density);
        % assign bulk wave speeds
        comp_speeds = [comp_speeds, tmp_cmp];           %#ok<AGROW>
        shear_speeds = [shear_speeds, tmp_shr];         %#ok<AGROW>
        
        if mat_idx > 1
            % get sound speed
            tmp_v = sqrt(...
                obj.medium(mat_idx).stiffness_matrix(...
                stiff_coeff(1), stiff_coeff(2)) / ...
                obj.medium(mat_idx).density);
            
            % fluids are modeled with a small shear speed, these are
            % ignored
            if tmp_v > 100
                % store the lowest phase velocities (generally the shear speeds)
                lowest_cph = [lowest_cph, tmp_v];       %#ok<AGROW>
            end
        end
    end
    
    % remove small values
    shear_speeds = shear_speeds(shear_speeds > 100);
    
    % =====================================================================
    %   PLATE THICKNESS ESTIMATE (SANDWICHED LAYERS)
    % =====================================================================
    total_thickness = length(obj.medium(2:end-1));
    % only consider the middle layers
    for mat_dx = 2:length(obj.medium)-1
        total_thickness(mat_dx-1) = obj.medium(mat_dx).thickness;
    end
    total_thickness = sum(total_thickness);
    
    % =====================================================================
    %   SET PARAMETERS
    % =====================================================================
    
    % define ranges of frequency
    f_min = min(obj.frequency);
    f_int = 5 / total_thickness;                    % 5 is arbitrary 
    f_max = max(obj.frequency);                     % [1/s]
    
    % define kx ranges
    kx_min = 0.1; % [1/m]
    kx_max = (2*pi*f_max / (min(lowest_cph)*0.9) ); % Rayleigh v ~0.9
    kx_int = 0.1 / total_thickness;                 % [1/m] 

    % create a wavenumber and frequency vector  
    freq_range = f_min:f_int:f_max;
    kx_range   = kx_min:kx_int:kx_max;
    
    % =====================================================================
    %   RETURN ARGUMENTS
    % =====================================================================
    
    % create a function handle to calculate global matrix determinant
    h = @(freqs, wavenumber) ElasticMatrix.calculateMatrixModelKf(...
        obj.medium, freqs, wavenumber, 0);
    
    % for a fixed wavenumber calculate the det map over all the frequencies
    % preallocate
    det_fK = zeros(length(freq_range), length(kx_range));
    output_struct.f = [];
    output_struct.k = [];
    
    % =====================================================================
    %   FIND DISPERSION POINTS
    % =====================================================================
    
    disp('... calculating dispersion curves - coarse method ...')

    % loop over the frequency index
    for k_idx = 1:length(kx_range)
        
        % this can be updated
        freq_range = f_min:f_int:f_max;
        
        % get an array of frequencies to calculate over
        k_loop = kx_range(k_idx) * ones(1,length(freq_range));
        
        % metric
        score = h(freq_range, k_loop);
        
        % get the peaks
        [~, found_peaks] = findpeaks(-log10(abs(score)));
        
        % if there are peaks (dispersion solutions)
        if ~isempty(found_peaks)
            % loop over the found indices
            for idx = 1:length(found_peaks)
                % limits to minimize over
                lim1 = freq_range(found_peaks(idx))-1;
                lim2 = freq_range(found_peaks(idx))+1;
                
                % new handle for fminbnd
                h2 = @(frequency) h(frequency, kx_range(k_idx));
                
                % assign the outputs
                opts = optimset('Display','off');
                output_struct.k = ...
                    [output_struct.k, kx_range(k_idx)];
                output_struct.f = ...
                    [output_struct.f, fminbnd(h2, lim1, lim2, opts)];
            end
        end
        
        det_fK(:, k_idx) = score;
    end
    
    % =====================================================================
    %   CONVERT TO PHASESPEED AND ASSIGN OBJECT PROPERTY
    % =====================================================================
    
    % convert f-kx to phase-speed
    output_struct.c = (output_struct.f*2*pi) ./...
        output_struct.k;
    
    % filter bulk wave speeds from dispersion points
    filter_vels = [comp_speeds, shear_speeds];
    
    for idx = 1:length(filter_vels)
        % comparison velocity (bulk wave speeds)
        comp_v = filter_vels(idx);
        % error
        error = 10;
        % boolean of indices to remove
        tmp = ( abs(output_struct.c - comp_v) < error);
        % reduce output
        output_struct.c = output_struct.c(~tmp);
        output_struct.f = output_struct.f(~tmp);
        output_struct.k = output_struct.k(~tmp);
        
    end
    
    % if the first medium is not a vacuum filter all points below the
    % wave-speed of the lowest phase velocity
    if ~strcmp(obj.medium(1).state,'Vacuum')
        % filter for lowest phase velocity
        tmp = output_struct.c < min(filter_vels)+5;
        output_struct.c = output_struct.c(~tmp);
        output_struct.f = output_struct.f(~tmp);
        output_struct.k = output_struct.k(~tmp);
    end
    
    % assign object property
    obj.dispersion_curves = output_struct;
    
    % =====================================================================
    %   PLOT DETERMINANT MAP
    % =====================================================================
    
    % plot determinant map
    figure;
    imagesc(freq_range/1e6, kx_range/1000, log10(abs(det_fK))')
    % plot dispersion points over determinant map
    hold on     
    plot(output_struct.f/1e6, output_struct.k/1000, 'k.')
    % labels
    axis xy
    ylabel('Wavenumber [m^-^1]')
    xlabel('Frequency [MHz]')
    title('Determinant map - with dispersion curve points')
        
    disp('... finished calculating dispersion curves ...')
        
    % turn warnings back on
    warning on
    
     
end