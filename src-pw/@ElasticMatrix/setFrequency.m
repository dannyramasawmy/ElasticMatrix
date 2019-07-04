function obj = setFrequency(obj, frequencyRange)
    %% setFrequency v1 date:  2019-01-15
    % 
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %   Vector of frequencies in Hz to calculate the model.
    
    
    % to avoid zero errors
    frequencyRange(frequencyRange == 0) = 0.01;
    
    % set the frequency range
    obj.frequency = frequencyRange;
    
end