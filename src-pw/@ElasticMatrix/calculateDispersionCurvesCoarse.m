function obj = calculateDispersionCurvesCoarse(obj)
    %CALCULATEDISPERSIONCURVESCOARSE Finds points on the dispersion curves.
    %
    % DESCRIPTION
    %   CALCULATEDISPERSIONCURVESCOARSE finds points on the the dispersion
    %   curves of the layered structure. This function should be used if
    %   .calculateDispersionCurves is not working correctly, for example if
    %   the tracing algorithm is giving incorrect results. Firstly, one
    %   parameter, for example frequency, is fixed and the determinant of
    %   the global-matrix is found over a range of wavenumbers. Close to
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
    %   obj.phasespeed  - The range of phasespeeds (only the first and last
    %                     values are taken into account).   [m/s] 
    %   obj.frequency   - The range of frequencies (only the first and last
    %                     values are taken into account).   [m/s]
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
    %   last update     - 15 - August   - 2019
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
    
    % the matrix will become singular
    warning off
    
    % =====================================================================
    %   FIND PHASESPEED AND FREQUENCY RANGES
    % =====================================================================
    
    % find maximum and minimum frequency and phasespeed
    [min_cph, max_cph] = deal(min(obj.phasespeed), max(obj.phasespeed));
    [min_f, max_f]     = deal(min(obj.frequency), max(obj.frequency));
    
    % convert phasespeed to wavenumber
    kx_min = (2 * pi * min_f) ./ max_cph ;   
    kx_max = (2 * pi * min_f) ./ min_cph ;
    
    % create a wavenumber and frequency vector  - up-sampled
    samples = 500;
    freq_range = linspace(min_f, max_f, samples);
    kx_range   = linspace(kx_min, kx_max, samples);
    

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
    
    % loop over the frequency index
    for f_idx = 1:10:length(freq_range)
        % get an array of frequencies to calculate over
        f_loop = freq_range(f_idx) * ones(1,length(kx_range));
        
        % metric
        score = h(f_loop, kx_range);
        
        % get the peaks
        [~, found_peaks] = findpeaks(-log10(abs(score)));
        
        % if there are peaks (dispersion solutions)
        if ~isempty(found_peaks)            
            % loop over the found indices
            for idx = 1:length(found_peaks)
                % limits to minimize over
                lim1 = kx_range(found_peaks(idx))-1;
                lim2 = kx_range(found_peaks(idx))+1;
                
                % new handle
                h2 = @(wavenumber) h(freq_range(f_idx), wavenumber);
                
                % assign the outputs
                output_struct.k = ...
                    [output_struct.k, fminbnd(h2, lim1, lim2)];
                output_struct.f = ...
                    [output_struct.f, freq_range(f_idx)];          
            end
        end
        
        det_fK(f_idx, :) = score;
    end
    

    % =====================================================================
    %   CONVERT TO PHASESPEED AND ASSIGN OBJECT PROPERTY
    % =====================================================================
    
    % convert fK to phasespeed
    output_struct.c = (output_struct.f*2*pi) ./...
        output_struct.k;
    
    % assign object property
    obj.dispersion_curves = output_struct;
    
    % turn warnings back on
    warning on
    
     
end