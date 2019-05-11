function [ minimumK ] = fineSearchMinDet( matDetModel, freq, kIn , deltaK)
    %% fineSearchMinDet v1 date:  2019-01-15
    % 
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %       Finds the minimum determinant of a function.
    
    threshold = 1e-4;

    currentDeltak = 2 * deltaK;
    kMin = kIn;
    
    thresholdReached = 1;
    counter = 1;
    
    while thresholdReached
        
        % define a range of k values
        kRange = linspace( kMin - currentDeltak, kMin + currentDeltak, 100);
        
        % get the determinant for the minimum value
        det = matDetModel(freq, kRange);
        
        
        figure;
        plot(kRange, abs(det))
        
        % find minimum
        [~, minIdx] = min( abs(det));
        
        % update delta_k
        currentDeltak = (kRange(minIdx + 1) - kRange(minIdx));
        kMin = kRange(minIdx);
        
        % flag when the current_delta_k is smaller than the threshold
        if currentDeltak <= threshold
            thresholdReached = 0;
        end
        
        % ensure a break point after twenty iterations
        if counter > 20
            thresholdReached = 0;
        end
        
        % add to counter
        counter = counter + 1;
        
    end
    
    minimumK = kMin;
    
    
end

