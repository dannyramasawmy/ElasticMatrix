function [obj] = calculateDispersionCurvesR(obj)
    %% calculateDispersionCurvesR v1 date:  2019-01-15
    % 
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %       
    
    % this function calculates dispersion curves
    warning off
    
    % get the maximum and minimum values for the angle and frequency range
    [maxF, minF] = deal(max(obj.frequency), min(obj.frequency));
    [maxA, minA] = deal(max(obj.angle),     min(obj.angle));
    
    % calculate values to sweep over
    sampleRange = 150;
    freqSweep  = linspace(minF, maxF, sampleRange);
    angSweep   = linspace(minA, maxA, sampleRange);
    myMin = [];
    
    % loop over the angles
    for angleIdx = 1:length(angSweep)
        
        % calculate the partial wave method
        h = @(freq) abs(calculateMatrixModel(...
            obj.medium, freq, angSweep(angleIdx), 0));
        
        % using the condition number metric (peaks are bad)
        score = h(freqSweep);
        
        % get the peaks
        [~, foundPeaks] = findpeaks(-(score));
        
        % loop over the found indicies
        for idx = 1:length(foundPeaks)
            % limits to minimise over
            lim1 = freqSweep(foundPeaks(idx))-1;
            lim2 = freqSweep(foundPeaks(idx))+1;
            
            % set counter
            counter = length(myMin) +1;
            
            % assign the outputs
            myMin(counter) = fminbnd(h, lim1, lim2);
            myAngles(counter) = angSweep(angleIdx);
            
            
        end
    end
    try
        output = [myMin', myAngles'];
    catch
    end
    
    
    obj.dispersionCurves = output;
    
    warning on
end