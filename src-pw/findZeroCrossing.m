function [ idxCrossing ] = findZeroCrossing( signal )
    %% findZeroCrossing v1 date:  2019-01-15
    % 
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %       
    % Algorithm to find the zero crossing points of a signal
    % compares neighbouring indicies to find a change in gradient
    
    % dummy signal
    %     signal = sin(pi/8+linspace(-2*pi, 2*pi, 300)); ## DEBUG
    
    % the numbe rof points of the signal
    nPoints = length(signal);
    
    % max turning points
    idxCrossing = [];
    
    % loop over the length of the signal
    for idx = 1:length(signal)-1
        % if the signal transitions from positive to negative
        if signal(idx) > 0 && signal(idx+1) < 0
            %idx_crossing = [idx_crossing, idx];
            
            % if the signal transitions from negative to positive
        elseif signal(idx) < 0 && signal(idx+1)> 0
            idxCrossing = [idxCrossing, idx];
        end
    end
    
    %
    
    
end

