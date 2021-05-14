function [ closest, idx, difference ] = findClosest(x_list,x)
    %FINDCLOSEST Find the closest element in an array X to an input x.
    %
    % DESCRIPTION
    %   FINDCLOSEST(x_list, x) finds the closest element in an array to an
    %   input x. The value x is taken away from the vector x_list, the
    %   absolute value is taken and the minimum value is found and
    %   returned.
    %
    % USEAGE
    %   [closest, index, difference] = fincClosest(x_list, x);
    %
    % INPUTS
    %   x_list          - An arbitrary sized vector, double.    []
    %   x               - A single value, double.               []
    %
    % OPTIONAL INPUTS
    %   []              - There are no optional inputs.         []
    %
    % OUTPUTS
    %   closest         - The closest value in x_list to input x.
    %   idx             - The index of the closest value in x_list.
    %   difference      - The difference between the closest value and x.
    %
    % DEPENDENCIES
    %   []              - There are no dependencies.    []
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 29 - March    - 2017
    %   last update     - 30 - July     - 2019
    %
    % This file is part of the ElasticMatrix toolbox.
    % Copyright (c) 2021 Danny Ramasawmy.
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
    
    
    % take x away from x_list, find the difference and the index
    [difference, idx] = min(abs((x_list - x)));
    % find the closest value
    closest = x_list(idx);
    
end

