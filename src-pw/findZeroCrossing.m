function [ idx_crossing ] = findZeroCrossing( signal )
    %FINDZEROCROSSING Finds idxs where a 1D signal crosses the x axis.
    %
    % DESCRIPTION
    %   FINDZEROCROSSING finds indices where a 1D signal crosses the axis
    %   y=0. This is found when the signal changes from positive to negative
    %   or from negative to positive. As this function is used by
    %   calculateDispersionCurves, only the indices where the signal
    %   transitions from negative to positive are taken.
    %
    % USEAGE
    %   [ idx_crossing ] = findZeroCrossing( signal )
    %
    % INPUTS
    %   signal          - 1D vector, double, real          []
    %
    % OPTIONAL INPUTS
    %   []              - there are no optional inputs      []
    %
    % OUTPUTS
    %   idx_crossing    - indices of the crossing points    []
    %
    % DEPENDENCIES
    %   []              - there are no dependencies         []
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - January  - 2019
    %   last update     - 25 - July     - 2019
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
    
    % check inputs
    inputCheck(signal);
    
    % max turning points
    zero_vector = zeros(1,length(signal));
    
    % loop over the length of the signal
    for idx = 1:length(signal)-1
        if signal(idx) > 0 && signal(idx+1) < 0
            % if the signal transitions from positive to negative
            %idx_crossing = [idx_crossing, idx];        % DEBUG
            
        elseif signal(idx) < 0 && signal(idx+1)> 0
            % if the signal transitions from negative to positive
            zero_vector(idx) = 1;
        end
    end
    
    % get all non zero elements
    idx_crossing = find(zero_vector);
end

function inputCheck(signal)
    %INPUECHECK Checks the inputs for the current function.
    %
    % DESCRIPTION
    %   INPUTCHECK(frequency_range) checks the inputs for the function
    %   setFrequency(...). If any of the inputs are not valid, the
    %   function will break and print errors to screen.
    %
    % USAGE
    %   inputChecks(frequency_range);
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 20 - July - 2019
    %   last update     - 21 - July - 2019
    
    % define attributes
    attributes = {'real'};
    
    % validate the attributes for input 1
    validateattributes(signal, {'numeric'}, attributes,...
        'findZeroCrossing', 'signal', 1);
    
end