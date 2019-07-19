function obj = calculateDispersionCurvesCoarse(obj)
    %% calculateDispersionCurves v1 date:  2019-01-15
    % 
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %       Calculates the dispersion curves - quick method.
    disp('...coarse dispersion curve function...')
    % this function calculates dispersion curves
    warning off
    
    % get the maximum and minimum values for the angle and frequency range   
    [maxF, minF] = deal(max(obj.frequency), min(obj.frequency));
    [maxA, minA] = deal(max(obj.angle),     min(obj.angle));
    
    % calculate values to sweep over
    sampleRange = 50;
    freqSweep  = linspace(minF, maxF, sampleRange * 10);
    angSweep   = linspace(minA, maxA, sampleRange);
    myMin = [];
      
    %
    % loop over the angles
    for angle_dx = 1:length(angSweep)
    
        % calculate the partial wave method
        h = @(freq) abs(calculateMatrixModel(...
            obj.medium, freq, angSweep(angle_dx), 0));
                
        % using the condition number metric (peaks are bad)
        score = h(freqSweep);
        
        % get the peaks
        [~, foundPeaks] = findpeaks(-score); 
        
        % loop over the found indicies
        for idx = 1:length(foundPeaks)
            % limits to minimise over
            lim1 = freqSweep(foundPeaks(idx))-1;
            lim2 = freqSweep(foundPeaks(idx))+1;
            
            % set counter
            counter = length(myMin) +1;
            
            % assign the outputs
            myMin(counter) = fminbnd(h, lim1, lim2);
            myAngles(counter) = angSweep(angle_dx);
            
            
        end
    end
    try
        disp('Sucess1')
      output = [myMin', myAngles'];
    catch
    end
    %}
    
    freqSweep  = linspace(minF, maxF, sampleRange);
    angSweep   = linspace(minA, maxA, sampleRange * 10);
    
    % loop over the frequencies
    for freqIdx = 1:length(freqSweep)
        
        % calculate the partial wave method
        h = @(ang) abs(calculateMatrixModel(...
            obj.medium, freqSweep(freqIdx), ang, 0));
                
        % using the condition number metric (peaks are bad)
        score = h(angSweep);
        
        % get the peaks
        [~, foundPeaks] = findpeaks(-score); 
        
        % loop over the found indicies
        for idx = 1:length(foundPeaks)
            % limits to minimise over
            lim1 = angSweep(foundPeaks(idx))-1;
            lim2 = angSweep(foundPeaks(idx))+1;
            
%             disp('part 2')
            % set counter
            counter = length(myMin) +1;
            
            % assign the outputs
            myMin(counter) = freqSweep(freqIdx);
            myAngles(counter) = fminbnd(h, lim1, lim2); 
            
            
        end
    end
    try
        disp('Sucess2')
      output = [myMin', myAngles'];
    catch
    end
    
    % assign object
    obj.dispersionCurves.x = output(:,1);
    obj.dispersionCurves.y = output(:,2);
    obj.dispersionCurves.c = output(:,1);
    
    
    warning on
end