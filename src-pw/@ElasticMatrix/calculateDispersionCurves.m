function obj = calculateDispersionCurves(obj)
    %CALCULATEDISPERSIONCURVES Calculates the dispersion curves.
    %
    % DESCRIPTION
    %   CALCULATEDISPERSIONCURVES calculates the dispersion curves of the
    %   layered structure using the method described in [1]. Firstly, one
    %   parameter, for example frequency, is fixed and the determinant of
    %   the global-matrix is found over a range of wavenumbers. Close to
    %   dispersive solutions the determinant of the global-matrix tends to
    %   zero. Using these as starting points and taking a small limit
    %   either side, the exact frequency and wavenumber of the dispersive
    %   solution is found using a bisection algorithm. ElasticMatrix makes
    %   use of MATLAB's fmincon() function which finds the minimum within a
    %   fixed range. After the exact frequency-wavenumber pairs are found,
    %   the fixed value of frequency is increased and the search is
    %   performed again. The algorithm then switches to using a linear
    %   interpolation scheme to estimate the location of the third and
    %   fourth points on the dispersion curve, similarly using a bisection
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
    %   obj.phasespeed  - The range of phasespeeds (only the first and last
    %                     values are taken into account).   [m/s] 
    %   obj.frequency   - The range of frequencies (only the first and last
    %                     values are taken into account).   [m/s]
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
    %   last update     - 14 - August   - 2019
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
    %   GET RANGE OF FREQUENCIES / WAVENUMBERS / PHASESPEEDS
    % =====================================================================
    
    % this function will search for singular matrices, MATLAB will throw
    % warnings
    warning off
    
    % set sample size
    n_samples = 1500;
    
    % check if phase speed is defined or not
    if isempty(obj.phasespeed)
        % message and define a value
        disp('.phasespeed is not defined, using predefined values')
        % set the phase speed
        obj.setPhasespeed(linspace(50,2000,2)); 
    end
    
    % up-sample frequency range too
    freq_range = linspace(obj.frequency(1), obj.frequency(end), n_samples);
    phase_range = linspace(obj.phasespeed(1), obj.phasespeed(end),n_samples);
    
    % create a function handle to calculate global matrix
    h = @(freqs, wavenumber) ElasticMatrix.calculateMatrixModelKf(...
        obj.medium, freqs, wavenumber, 0);
    
    % vector of frequency / phasespeed ranges
    % maximum phase speed
    max_phasespeed = max(obj.phasespeed) * ones(1,n_samples);
    % minimum frequency
    min_frequency = min(freq_range) * ones(1,n_samples);
    
    % constant frequency wavenumbers
    kx_const_f = (2 * pi * min_frequency) ./ phase_range ;    
    % constant cph wavenumber
    kx_const_cph = (2 * pi * freq_range(1)) ./ max_phasespeed ;
               
    % =====================================================================
    %   PLOT DETERMINANT MAP
    % =====================================================================
    
    % frequency and wavenumber determinant map
    kx_tmp     = linspace(kx_const_f(end), kx_const_f(1),   150);
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
    imagesc(kx_tmp, f_tmp/1e6, log10(abs(det_fK)))
    % labels
    axis xy
    xlabel('Wavenumber [m^-^1]')
    ylabel('Frequency [MHz]')
    title('Determinant map - with dispersion curve traces')
                    
    % =====================================================================
    %   FIND DISPERSION CURVES STARTING POINTS
    % =====================================================================
    % For the lowest frequency, or wavenumber, sweep over th other variable
    % and find the minimums in the determinant, these are the dispersion
    % curve starting positions.
    
    % calculate the determinant over each vector
    % phasespeed sweep
    cph_sweep   = h(min_frequency, kx_const_f);
    % frequency sweep
    f_sweep     = h(freq_range, kx_const_cph );
    
    % differentiate to find the gradient turning points
    d_cph_sweep = diff( log10(abs(cph_sweep))); 
    d_f_sweep   = diff(   log10(abs(f_sweep))); 
        
    % find crossing points
    cph_starting_idxs   = findZeroCrossing(d_cph_sweep);
    f_starting_idxs     = findZeroCrossing(d_f_sweep);
    
    % f starting points
    Fs = freq_range(f_starting_idxs);
    
    % cph starting points
    CPHs = kx_const_f(cph_starting_idxs);
    
    % length of different starting point vectors
    NFs = length(Fs);
    NCPHs = length(CPHs);

    % initialize struct
    mode_struct = struct;
    for mode_dx = 1:(NFs+NCPHs)
        
        % frequency starting points
        if mode_dx <= NFs
            mode_struct(mode_dx).startingPointsFs = Fs(mode_dx);
        end
        
        % phasespeed starting points
        if mode_dx > NFs
            mode_struct(mode_dx).startingPointsCPHs = CPHs(mode_dx-length(Fs));
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
    k_inc = kx_tmp(1):10:kx_tmp(end);
    
    % plot the curves at certain points
    plot_counter = round(linspace(1,length(k_inc),100));
    
    % initialize 
    current_mode = zeros(length(mode_struct),1);
            
    % for each k
    for counter_idx = 1:length(k_inc)-1
        
        % the chosen kx
        kx_chosen = k_inc(counter_idx);
           
        % create a function handle to loop over the phase speeds
        h = @(df) abs(ElasticMatrix.calculateMatrixModelKf(...
            obj.medium, df, kx_chosen, 0));
        
        % variation in delta / sensitivity, this parameter can be tuned
        delta_x = 1e4; 
        

        % for each dispersion curve
        for mode_idxs = 1:length(mode_struct)
            
            % check if it has a frequency starting point
            if mode_idxs > NFs
                
                if mode_struct(mode_idxs).startingPointsCPHs <= kx_chosen
                    % if the starting CPH is more than the chosen wavenumber
                    if isempty(mode_struct(mode_idxs).f)
                        current_mode(mode_idxs) = freq_range(1);               
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
            if current_mode(mode_idxs) > max(f_tmp)
                continue;
            end
            
            % condition on breaking the for-loop
            if current_mode(mode_idxs) < min(f_tmp)
                continue;
            end
            
            % check current length of the vector
            current_count = length(mode_struct(mode_idxs).f) + 1;
            
            % frequency where minimum occurs
            mode_struct(mode_idxs).f(current_count) = ...
                findClosestMinimum(h, current_mode(mode_idxs), 20 ,delta_x );
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
                plot( mode_struct(update_dx).k, ...
                    mode_struct(update_dx).f/1e6,'k-')
            end
        end
        
    end
    
    % =====================================================================
    %   CONVERT TO PHASESPEED AND ASSIGN OBJECT PROPERTY
    % =====================================================================
    
    % convert fK to phasespeed
    for idx = 1:length(mode_struct)
        mode_struct(idx).c = (mode_struct(idx).f*2*pi) ./...
            mode_struct(idx).k;
    end
    
    % assign object property
    obj.dispersion_curves = mode_struct;
   
end