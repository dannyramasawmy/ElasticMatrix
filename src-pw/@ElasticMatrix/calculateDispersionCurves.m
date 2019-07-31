function obj = calculateDispersionCurves(obj)
    %FUNCTIONTEMPLATE - one line description
    %
    % DESCRIPTION
    %   A short description of the functionTemplate goes here.
    %
    % USEAGE
    %   outputs = functionTemplate(input, another_input)
    %   outputs = functionTemplate(input, another_input, optional_input)
    %
    % INPUTS
    %   input           - The first input.   [units]
    %
    % OPTIONAL INPUTS
    %   []              - There are no optional inputs. []
    %
    % OUTPUTS
    %   outputs         - The outputs.       [units]
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
    
    %% calculateDispersionCurves v1 date:  2019-01-15
    %
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %       Calculates the dispersion curves using the method described in
    %       [1].
    %
    %   Errors:
    %       There are a few issues that need correcting:
    %           - robustness to leaky modes
    %           - robustness to user inputs
    %           - calculation in the imaginary space for attenuation
    %           - group velocity
    %
    %   [1] M. Lowe, Matrix techniques for modeling ultrasonic waves in
    %       multilayered media, IEEE Trans. Ultrason. Ferroelect. Freq. Contr.
    %       42 (4) (1995) 525-542.
    
    
    %% ====================================================================
    %   CHECKS
    % =====================================================================
    warning off
    
    % check if phase speed is defined or not
    if isempty(obj.phasespeed)
        % message and define a value
        disp('.phasespeed is not defined, using predefined values')
        % set the phase speed
        obj.setPhasespeed(linspace(50,2000,1500)); % 50?
    end
    
    % set sample size
    nSamples = length(obj.phasespeed);
    
    % upsample frequency range too
    freqRange = linspace(obj.frequency(1), obj.frequency(end), nSamples);
    phasespeedRange = obj.phasespeed;
    
    
    %% ====================================================================
    %   sweep over frequency and sweep over phasespeed
    % =====================================================================
    % create a function handle to loop over the phase speeds
    h = @(freqs, wavenumber) ElasticMatrix.calculateMatrixModelKf(...
        obj.medium, freqs, wavenumber, 0);
    
    
    % fix frequency - find determinant over the phase speed
    % fixed frequency point
    % find maximum phase speed
    maxPhasespeed = max(obj.phasespeed) * ones(1,nSamples);
    % minimum frequency
    minFrequency = min(freqRange) * ones(1,nSamples);
    
    % =====================================================================
    % constant frequency wavenumbers
    kxWavenumberConstF = (2 * pi * minFrequency) ./ phasespeedRange ;
    % constant cph wavenumber
    kxWavenumberConstCP = (2 * pi * freqRange(1)) ./ maxPhasespeed ;
    
    
    % phsespeed sweep
    cphSweep   = h(minFrequency, kxWavenumberConstF);
    
    % frequency sweep
    fSweep     = h(freqRange, kxWavenumberConstCP );
    
    %     % add an imaginary component of wavenumber
    %     k_x_att = 1i * 0.001;
    %     k_x_wavenumber_constCP_att = k_x_wavenumber_constCP + k_x_att ;
    %     f_sweep_att     = h(freq_range, k_x_wavenumber_constCP_att );
    
    
    % differentiate to find the gradient turning points
    dCphSweep = diff( log10(abs(cphSweep))); % for debug
    dFSweep = diff(   log10(abs(fSweep))); % for debug
    
    % attenuation of guided modes (logic can be used later)
    %{
%     d_f_sweep_att = diff(   log10(abs(f_sweep_att)));
    
    % lets check what happens across frequencies
    N_of_att_vec = 100;
    IDX = 1440 ;%, 681,
    f_coonst = freq_range(IDX) * ones(1,N_of_att_vec) ;
        k_x_wavenumber_at_a_minima = (2 * pi * freq_range(1)) ./ max_phasespeed(1) ;
    % just coppy the variable for a second
    tmp_kx = k_x_wavenumber_at_a_minima;
    % make the vector of the attenuating term
    
    kx_attenuation_factor_vector = tmp_kx + 1i * tmp_kx * linspace(0.001,1,N_of_att_vec);
    % imaginary part sweep
    f_sweep_im     = h(f_coonst, kx_attenuation_factor_vector );
       figure,
    plot(1:N_of_att_vec,abs(f_sweep_im))
    %}
    
    % find crossing points
    cphStartingIdxs   = findZeroCrossing(dCphSweep);
    fStartingIdxs     = findZeroCrossing(dFSweep);
    
    
    % temp frequency and wavenumber range to view the determinant over
    kxTmp     = linspace(kxWavenumberConstF(end), kxWavenumberConstF(1),  150) ;
    fTmp       = linspace(freqRange(1), freqRange(end), 150);
    
    
    % just for visualisation purposes =====================================
    % loop over the frequency index
    for tmpLoopIdx = 1:length(fTmp)
        % get an array of frequencies to calcualte over
        fArrayLoop = fTmp(tmpLoopIdx) * ones(1,length(kxTmp));
        detfK(tmpLoopIdx, :) = h(fArrayLoop, kxTmp);
    end
    
    figure(10),
    imagesc(kxTmp, fTmp/1e6, log10(abs(detfK)))
    axis xy
    %     caxis([-15 5])
    % =====================================================================
    
    % f starting points
    Fs = freqRange(fStartingIdxs);
    
    %     figure,
    %     plot(freqRange, log10(abs(fSweep)),'b')
    %     hold on
    % %     plot(freq_range, log10(abs(f_sweep_att)),'r--')
    %     plot(Fs,-7*ones(1,length(Fs)),'*')
    %     hold off
    
    % starting points for phase speed
    % create a structure where the index of the structure is the point of
    % starting
    
    % cph starting points
    CPHs = kxWavenumberConstF(cphStartingIdxs);
    
    % length of different starting point vectors
    NFs = length(Fs);
    NCPHs = length(CPHs);
    
    a = figure(10);
    
    %     set(a,'Position',[-1056 345 560 420]);
    
    %     disp('Check - auto image position set')
    
    % minimum k_x to start
    kxMinStart = min(kxTmp);
    for modeLoopDx = 1:(NFs+NCPHs)
        % number of modes = assign starting point
        % for frequency starting points
        %         mode_loop_dx
        if modeLoopDx <= NFs
            myModes(modeLoopDx).startingPointsFs = Fs(modeLoopDx);
        end
        % for phase speed starting points
        if modeLoopDx > NFs
            myModes(modeLoopDx).startingPointsCPHs = CPHs(modeLoopDx-length(Fs));
        end
        
        myModes(modeLoopDx).f = [];
        myModes(modeLoopDx).k = [];
    end
    
    % increment in the k-wavenumber
    kIncrement = [kxTmp(1):10:kxTmp(end)];
    
    % plotting indicies
    plottingCounter = round(linspace(1,length(kIncrement),100));
    
    for counterIdx = 1:length(kIncrement)-1
        
        % the chosen y_point
        kChosen = kIncrement(counterIdx);
        
        % use fmincon of something to find the true minima
        %         h = @(dx) determinant_function( dx, y_chosen);
        
        % create a function handle to loop over the phase speeds
        h = @(df) abs(ElasticMatrix.calculateMatrixModelKf(...
            obj.medium, df, kChosen, 0));
        
        % varation in telta
        deltaX = 1e4; % some sensitiviity into this function [0.01] (of frequency)
        
        % to check if all the modes have completed tracing
        modeCompletion = zeros(1, length(myModes));
        
        % for each peak
        for peakIdxs = 1:length(myModes)
            
            % check if it has a frequency starting point
            if peakIdxs > NFs
                
                if myModes(peakIdxs).startingPointsCPHs <= kChosen
                    % if the starting CPH is more than the chosen wavenumber
                    if isempty(myModes(peakIdxs).f)
                        disMode(peakIdxs) = freqRange(1);
                        
                        % disp('DEBUG : Empty Mode')
                        
                        
                    end
                else
                    continue;
                end
                
            end
            
            
            %             current_counter =
            % for the first counter use chosen point
            if counterIdx == 1
                disMode(peakIdxs) = myModes(peakIdxs).startingPointsFs;
            end
            
            % condition on breaking the forloop
            if disMode(peakIdxs) > max(fTmp)
                % to make sure the code does not break
                continue;
            end
            
            % condition on breaking the forloop
            if disMode(peakIdxs) < min(fTmp)
                % to make sure the code does not break
                continue;
            end
            
            % check current length of the vector
            currentCount = length(myModes(peakIdxs).f) + 1;
            
            % find the minimum x_1 point
            %             myModes(peak_idxs).x(current_count) = ...
            %                 fminbnd(h, dis_mode(peak_idxs) - delta_x, dis_mode(peak_idxs) + delta_x);
            %             myModes(peak_idxs).y(current_count) = k_chosen;
            %
            myModes(peakIdxs).f(currentCount) = ...
                findClosestMinimum(h, disMode(peakIdxs), 20 ,deltaX );
            myModes(peakIdxs).k(currentCount) = kChosen;
            
            
            if currentCount < 3
                % increment the y step and find the next x_vector point
                disMode(peakIdxs) = myModes(peakIdxs).f(currentCount);
                
            elseif currentCount > 2 && currentCount < 6
                %
                % disp('Linear') % DEBUG
                
                % linear interpolation
                disMode(peakIdxs) = interp1(...
                    myModes(peakIdxs).k(:) , myModes(peakIdxs).f(:) , ...
                    kIncrement(counterIdx + 1),'linear','extrap');
                
            elseif counterIdx >5
                % disp('Poly') % DEBUG
                % higher order interpolation
                %                 mv_st    = counter_idx - 4;
                %                 mv_en      = counter_idx;
                
                interpVector = 1:currentCount;
                if currentCount > 10
                    interpVector = round(linspace(1, currentCount, 10));
                end
                
                % cubic interpolation of next point based on previous four points
                disMode(peakIdxs) = interp1( ...
                    myModes(peakIdxs).k(interpVector) , myModes(peakIdxs).f(interpVector), ...
                    kIncrement(counterIdx + 1),'pchip','extrap');
            end
            
        end
        
        % to speed up the calculation only force drawing the figure 100 times
        if sum(plottingCounter == counterIdx)
            % plot of the determinant map
            figure(10)
            hold on
            for tmptmpdx = 1:length(myModes)
                % find lenghth (plot less)
                plotIxs = round(linspace(1,numel(myModes(tmptmpdx).k),15));
                plot( myModes(tmptmpdx).k, myModes(tmptmpdx).f/1e6,'k-')
            end
            
            if counterIdx == 1
                xlabel('Wavenumber [m^-^1]')
                ylabel('Frequency [MHz]')
                title('Determinant map - with dispersion curve traces')
            end
            drawnow
        end
        
    end
    
    % get the phase speed
    for idx = 1:length(myModes)
        myModes(idx).c = (myModes(idx).f*2*pi) ./ myModes(idx).k;
    end
    
    
    %     myModes.y
    obj.dispersion_curves = myModes;
    
    % attenuation search % FUTURE
    % disp('Calculating mode attenuation')
    
    
    return
    % DEBUG ===============================================================
    %{
    % compare the results with the indices
    cph_starts = 1;
    
    % rejection threshold? - to reject critical angles
    reject_threshold = 0.0; % as in if within 98 percent of the bulk wave speed
    
    % indices of the cph_starts to reject( if match bulk wave)
    reject_vector = ones(length(cph_starts), 1);
    
    % calculate bulk wave speeds in the materials
    % filter starting points to avoid solutions matching bulk-wave speeds
    for idx = 1:length(obj.medium)
        % temp effective compressional wave speeds
        tmp_cl(idx) = sqrt(obj.medium(idx).C_mat(1,1) / obj.medium(idx).Density); % compression
        
        % temp shear speeds
        tmp_cs(idx) = sqrt(obj.medium(idx).C_mat(5,5) / obj.medium(idx).Density); % shear
        
        % loop over starting points
        for jdx = 1:length(reject_vector)
            
            % compare to compression bulk wave speed
            if (abs(tmp_cl(idx) - cph_starts(jdx)) / tmp_cl(idx)) < reject_threshold
                reject_vector(jdx) = 0;
            end
            
            % compare to shear bulk wave speed
            if (abs(tmp_cs(idx) - cph_starts(jdx)) / tmp_cs(idx)) < reject_threshold
                reject_vector(jdx) = 0;
            end
        end
    end
    
    % get rid of bulk wave starting points
    cph_starting_idxs = cph_starting_idxs(reject_vector == 1);
    
    cph_starts = cph_starts(reject_vector == 1);
    cph_starts2 = min_phase_vel ./ sin(angle_range(cph_starting_idxs +1) * pi/180);
    
    %% ====================================================================
    %    STARTING POINTS - FINE SEARCH
    % =====================================================================
    % two vectors of starting points - cph_starting_idxs and f_starting_idxs
    
    % keeping frequency - fixed and varying wavenumber ====================
    % real wavenumber fine search
    
    % create a function handle for the fine search
    h2 = @(freqs, wavenumber) Calculate_Matrix_Model_Kf(...
        obj.medium, freqs, wavenumber, 0);
    
    % fixed frequency
    f_fixed = f_min;
    kx_wavenumber_starts = 2 * pi * f_fixed ./ cph_starts;
    kx_wavenumber_starts2 = 2 * pi * f_fixed ./ cph_starts2;
    
    % find the delta_k
    delta_k =  abs(kx_wavenumber_starts2 - kx_wavenumber_starts);
    
    % for each strting point
    for kx_dxs = 1:length(kx_wavenumber_starts)
        
        % check the temporary output
        k_min(kx_dxs) = Fine_Search_Min_Det(h2, f_fixed, kx_wavenumber_starts(kx_dxs), delta_k(kx_dxs));
        
    end

    % DEBUG code / check the angle conversion is ok
    % angles_maybe_tmp = asin(min_phase_vel ./ cph_starts) * 180/pi;
    
    
    % keeping cph fixed and varying frequency =============================
    %     wavenumber = a_min;
    
    
    disp('working so far')
    
    obj.dispersion_curves = [1 1];
    
    
  
    
    warning on
    %}
end