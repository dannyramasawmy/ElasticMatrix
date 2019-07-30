function x_min = findClosestMinimum(funHand, x0, increment, maximum_range)
    %FINDCLOSESTMINIMUM Finds a local minimum of a function f(x) from x0.
    %
    % DESCRIPTION
    %   FINDCLOSESTMINIMUM finds the closest minimum in a function f(x)
    %   from a starting point x0. An increment value and maximum function
    %   range must also be provided. A 1 X 3 vector is created consisting
    %   of the starting point (x0) and a small perturbation around it,
    %   (increment), e.g., [x0-increment, x0, x0+increment]. The function
    %   x_out = f(x) is evaluated at these three points. If x_out(1) <
    %   x_out(2) < x_out(3) then the local minimum of f(x) is "to the left"
    %   of the starting point. If x_out(1) > x_out(2) > x_out(3) then the
    %   local minimum of f(x) is "to the right" of the starting point. The
    %   starting point and the small perturbations are updated to reflect
    %   this and f(x) is reevaluated. This continues until either: the
    %   maxRange limit is hit, the max number of iterations (1000) is hit
    %   or x_out(1) > x_out(2) < x_out(3). At this point fminbnd is used
    %   to find the minimum of the function within the range x_out(1) and
    %   x_out(3).
    %
    % USEAGE
    %   x_min = findClosestMinimum(@funHand, x0, increment, maximum_range)
    %
    % INPUTS
    %   funHand(x)      - A function handle that must accept a vector and
    %                     return a vector of the same length.   []
    %   x0              - Starting point, double.               []
    %   increment       - A perturbation to evaluate the
    %                     funHand[(x0-e, x0, x0+e]).            []
    %   maximum_range   - Limit when evaluating funHand.        []
    %
    % OPTIONAL INPUTS
    %   []              - There are no optional inputs.         []
    %
    % OUTPUTS
    %   x_min           - Minimum x-value of funHand.           []
    %
    % DEPENDENCIES
    %   fminbnd         - Find the minimum of a bounded function.
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - March    - 2019
    %   last update     - 30 - July     - 2019
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
    
    % vector of starting point plus and minus a small perturbation
    x_in = ...
        [x0 - increment, x0, x0 + increment ];
    
    % break function flag
    break_flag = 1;
    
    % maximum number of iterations
    max_iterations = 0;
    
    % initialize output vector
    x_out = [0, 0, 0];
    
    % loop
    while break_flag
        
        % evaluate funHand at three points
        for idx = 1:3
            x_out(idx) = abs(funHand(x_in(idx)));
        end
        
        % if x_out is increasing shift x_in 
        if x_out(1) < x_out(2) && x_out(2) < x_out(3)
            % shift values of x_in to the left
            x_in = [(x_in(1)-increment), x_in(1), x_in(2)];
        end
        
        % if x_out is decreasing shift x_in
        if x_out(1) > x_out(2) && x_out(2) > x_out(3)
            % shift values of x_in to the right
            x_in(1:3) = [x_in(2), x_in(3), (x_in(3)+increment) ];
        end
        
        % if x_out is the minimum break while loop
        if x_out(2) < x_out(1) && x_out(2) < x_out(3)
            % use fminbnd to find the minimum of the function between the
            % current range
            x_min = fminbnd(funHand, x_in(1), x_in(3));
            % set state of break to end while-loop
            break_flag = 0;
        end
        
        % break if the maximum range is hit
        if x_in(1) < (x0 - maximum_range)
            % set the minimum to the starting point
            x_min = x0;
            % set state of break to end while-loop
            break_flag = 0;
        end
        % break if the maximum range is hit       
        if x_in(3) > (x0 + maximum_range)
            % set the minimum to the starting point
            x_min = x0;
            % set state of break to end while-loop
            break_flag = 0;
        end
        
        % break if maximum number of iterations is hit
        if max_iterations > 1000
            x_min = x0;
            break_flag = 0;
            % disp('Limit reached')
        end
        
        % increment number of iterations
        max_iterations = max_iterations + 1;
    end
