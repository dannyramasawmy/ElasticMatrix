function obj = calculateDispersionCurves(obj)
    %CALCULATEDISPERSIONCURVES Calculates the dispersion curves.
    %
    % DESCRIPTION
    %   CALCULATEDISPERSIONCURVES calculates the dispersion curves of the
    %   layered structure using the method described in [1]. Firstly, one
    %   parameter, for example frequency, is fixed and the determinant of
    %   the global-matrix is found over a range of wave-numbers. Close to
    %   dispersive solutions the determinant of the global-matrix tends to
    %   zero. Using these as starting points and taking a small limit
    %   either side, the exact frequency and wavenumber of the dispersive
    %   solution is found using a bisection algorithm. ElasticMatrix makes
    %   use of MATLAB's fmincon() function which finds the minimum within a
    %   fixed range. After the exact frequency-wavenumber pairs are found,
    %   the fixed value of frequency is increased and the search is
    %   performed again. The algorithm then switches to using a linear
    %   interpolation scheme to estimate the location of the third and
    %   fourth points on the dispersion curve, similarly, using a bisection
    %   algorithm to find the exact frequency-wavenumber pairs. After five
    %   points have been found, a higher-order polynomial interpolation
    %   scheme is used to more accurately predict points on the dispersion
    %   curve. 
    %
    %   The algorithm implemented in ElasticMatrix only searches in the
    %   real space which is a good-estimate for simple plate structures in
    %   a vacuum or liquid, however, it may be inaccurate for very leaky
    %   solutions, for example a plate embedded in soil. For the user to
    %   check if the dispersion curve tracing is working correctly a map of
    %   the determinant of the system matrix is plotted as the dispersion
    %   curves are trace. The minima in the determinant map indicate the
    %   location of dispersion curves, hence the user has a visual check if
    %   they are tracing correctly.
    %
    % References
    %   [1] M. Lowe, Matrix techniques for modeling ultrasonic waves in
    %       multilayered media, IEEE Trans. Ultrason. Ferroelect. Freq.
    %       Contr. 42 (4) (1995) 525-542.
    %
    %
    % USEAGE
    %   obj.calculateDispersionCurves;
    %
    % INPUTS
    %   obj.frequency   - The range of frequencies (only the first and last
    %                     values are used).   [m/s]
    %
    % OPTIONAL INPUTS
    %   []              - There are no optional inputs. []
    %
    % OUTPUTS
    %   obj.dispersion_curves(idx). - A structure containing the (idx)th 
    %                                 dispersion curves.
    %       dispersion_curves.k     - Wavenumber vector.    [1/m]
    %       dispersion_curves.f     - Frequency vector.     [Hz, 1/s]
    %       dispersion_curves.c     - Phase-speed vector.   [m/s]
    %
    % DEPENDENCIES
    %   findClosestMinimum      - Finds a local minimum of a function f(x)
    %                             from x0 
    %   findZeroCrossing        - Finds idxs where a 1D signal crosses the
    %                             x axis.
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - January  - 2019
    %   last update     - 22 - August   - 2019
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
    
    % the matrix will become singular at dispersion solutions
    warning off
    
    % =====================================================================
    %   FIND THE SOUND-SPEEDS OF EACH MATERIAL
    % =====================================================================
    % initialize
    lowest_cph = [];
    
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
                
        if mat_idx > 1
            % get sound speed
            tmp_v = sqrt(...
                obj.medium(mat_idx).stiffness_matrix(...
                stiff_coeff(1), stiff_coeff(2)) / ...
                obj.medium(mat_idx).density);
            
            % fluids are modeled with a small shear speed, these are
            % ignored
            if tmp_v > 100
                % store the lowest phase velocities 
                lowest_cph = [lowest_cph, tmp_v];       %#ok<AGROW>
            end
        end
    end
    
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
    % arbitrary scaling
    kx_int = 0.01 / total_thickness;                % [1/m] 

    % create a wavenumber and frequency vector 
    freq_range = f_min:f_int:f_max;
    kx_range   = kx_min:kx_int:kx_max;
    
    % create a function handle to calculate global matrix determinant
    h = @(freqs, wavenumber) ElasticMatrix.calculateMatrixModelKf(...
        obj.medium, freqs, wavenumber, 0);
              
    % =====================================================================
    %   PLOT DETERMINANT MAP
    % =====================================================================
    
    % frequency and wavenumber determinant map
    kx_tmp     = linspace(kx_range(1), kx_range(end),   150);
    f_tmp      = linspace(freq_range(1), freq_range(end),   150);
    
    % preallocate
    det_fK = zeros(length(f_tmp), length(kx_tmp));
    % loop over the frequency index
    for tmp_idx = 1:length(f_tmp)
        % get an array of frequencies to calculate over
        f_loop = f_tmp(tmp_idx) * ones(1,length(kx_tmp));
        det_fK(tmp_idx, :) = h(f_loop, kx_tmp);
    end
    
    % plot determinant map
    figure_handle = figure;
    imagesc(f_tmp/1e6, kx_tmp, log10(abs(det_fK))')
    % labels
    axis xy
    ylabel('Wavenumber [m^-^1]')
    xlabel('Frequency [MHz]')
    title('Determinant map - with dispersion curve traces')
          
    % =====================================================================
    %   FIND DISPERSION CURVES STARTING POINTS
    % =====================================================================
    % For the lowest frequency, or wavenumber, sweep over th other variable
    % and find the minimums in the determinant, these are the dispersion
    % curve starting positions.
    
    % calculate the determinant over each vector
    % wavenumber sweep    
    f_start_idx = 10; % set higher so fundamental modes do not fail
    f_tmp       = freq_range(f_start_idx)*ones(size(kx_range));
    kx_sweep    = h(f_tmp, kx_range);
    
    % frequency sweep
    kx_tmp      = kx_range(1)*ones(size(freq_range));
    f_sweep     = h(freq_range, kx_tmp );
    
    % differentiate to find the gradient turning points
    d_kx_sweep  = diff( log10(abs(kx_sweep))); 
    d_f_sweep   = diff( log10(abs(f_sweep))); 
        
    % find crossing points
    kx_starting_idxs    = findZeroCrossing(d_kx_sweep);
    f_starting_idxs     = findZeroCrossing(d_f_sweep);
    
    % f starting points
    Fs = freq_range(f_starting_idxs);
    
    % kx starting points
    KXs = kx_range(kx_starting_idxs);
    
    % length of different starting point vectors
    NFs = length(Fs);
    NKXs = length(KXs);

    % initialize struct
    mode_struct = struct;
    for mode_dx = 1:(NFs+NKXs)
        
        % frequency starting points
        if mode_dx <= NFs
            mode_struct(mode_dx).startingPointsFs = Fs(mode_dx);
        end
        
        % phase-speed starting points
        if mode_dx > NFs
            mode_struct(mode_dx).startingPointsKXs = KXs(mode_dx-length(Fs));
        end
        
        % initialize outputs
        mode_struct(mode_dx).f = [];
        mode_struct(mode_dx).k = [];
    end
    
    
    % =====================================================================
    %   TRACE MODES FROM EACH STARTING POINT
    % =====================================================================
    % Increment the wavenumber vector, use each of the starting positions
    % as the starting point for the next position in the dispersion curve.
    % After enough points have been gathered use a linear then polynomial
    % extrapolation scheme to more accurately predict the following
    % dispersion curve points.
    
    % increment in the k-wavenumber
    k_inc = kx_range(1):kx_int:kx_range(end);
    
    % plot the curves at certain points
    plot_counter = round(linspace(1,length(k_inc),100));
    
    % initialize 
    current_mode = zeros(length(mode_struct),1);
            
    disp('...calculating dispersion curves...')
    % for each k
    for counter_idx = 1:length(k_inc)-1
        
        % the chosen kx
        kx_chosen = k_inc(counter_idx);
           
        % create a function handle to loop over the phase speeds
        h = @(df) abs(ElasticMatrix.calculateMatrixModelKf(...
            obj.medium, df, kx_chosen, 0));
        
        % variation in delta / sensitivity, this parameter can be tuned
        delta_x = 2*f_int; 
        

        % for each dispersion curve
        for mode_idxs = 1:length(mode_struct)
            
            
            % check if it has a frequency starting point
            if mode_idxs > NFs
                
                if mode_struct(mode_idxs).startingPointsKXs <= kx_chosen
                    % if the starting CPH is more than the chosen wavenumber
                    if isempty(mode_struct(mode_idxs).f)
                        current_mode(mode_idxs) = freq_range(f_start_idx);               
                    end
                else
                    continue;
                end
                
            end
            
            % for the first counter use chosen point
            if counter_idx == 1
                current_mode(mode_idxs) = ...
                    mode_struct(mode_idxs).startingPointsFs;
            end
            
            % condition on breaking the for-loop
            if current_mode(mode_idxs) > max(freq_range)
                continue;
            end
            
            % condition on breaking the for-loop
            if current_mode(mode_idxs) < min(freq_range)
                continue;
            end
            
            % check current length of the vector
            current_count = length(mode_struct(mode_idxs).f) + 1;
            small_pert = delta_x * 0.002;
            % frequency where minimum occurs
            mode_struct(mode_idxs).f(current_count) = ...
                findClosestMinimum(h, current_mode(mode_idxs), small_pert ,delta_x );
            % assign kx values
            mode_struct(mode_idxs).k(current_count) = kx_chosen;
            
            % =============================================================
            %   ESTIMATE NEXT POINT POSITION
            % =============================================================
            
            % increment the k-step and find the next f point
            if current_count < 3
                % for first three dispersion curve points
                current_mode(mode_idxs) = ...
                    mode_struct(mode_idxs).f(current_count);

            elseif current_count > 2 && current_count < 6
                % between 3-5 points
                % linear interpolation
                current_mode(mode_idxs) = interp1(...
                    mode_struct(mode_idxs).k(:) , mode_struct(mode_idxs).f(:) , ...
                    k_inc(counter_idx + 1),'linear','extrap');
                
            elseif counter_idx >5
                % higher order interpolation for 6 points and above
                
                interp_vector = 1:current_count;
                if current_count > 10
                    interp_vector = round(linspace(1, current_count, 10));
                end
                
                % cubic interpolation
                current_mode(mode_idxs) = interp1( ...
                    mode_struct(mode_idxs).k(interp_vector),...
                    mode_struct(mode_idxs).f(interp_vector), ...
                    k_inc(counter_idx + 1),'pchip','extrap');
            end
            
        end
        
        % =================================================================
        %   PLOT DISPERSION CURVES OVER k-f DETERMINANT MAP
        % ================================================================= 
        
        % update figure every 100 kx points
        if sum(plot_counter == counter_idx)
            % plot of the determinant map
            figure(figure_handle)
            hold on
            
            % for each curve
            for update_dx = 1:length(mode_struct)
                % update plot with each dispersion curve
                plot( mode_struct(update_dx).f/1e6, ...
                    mode_struct(update_dx).k, 'k-')
            end
        end
        
    end
  
    % =====================================================================
    %   CONVERT TO PHASESPEED AND ASSIGN OBJECT PROPERTY
    % =====================================================================
    
    % convert f-kx to phase-speed
    for idx = 1:length(mode_struct)
        mode_struct(idx).c = (mode_struct(idx).f*2*pi) ./...
            mode_struct(idx).k;
    end
    
    % assign object property
    obj.dispersion_curves = mode_struct;
    
    % turn warnings back on
    warning on
   
end