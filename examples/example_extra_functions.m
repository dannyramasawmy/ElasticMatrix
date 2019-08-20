%% Example: Extra Functions
% Some additional functions are described here.

%% cls
% cls clears the workspace, command window and closes all open figures.

cls;

%% sfg
% sfg finds all open MATLAB figures, then distributes them across the
% full-screen like tiles.

for idx = 1:6
    figure
end

sfg;

%% findClosest
% findClosest finds the closest element in an array to an input x. The
% value x is taken away from the vector x_list, the absolute value is taken
% and the minimum value is found and returned. 

% Find the closest value in the list:
x_list = [6,5,4,3,2,1];
x = 2.1;
[closest_value, index] = findClosest(x_list, x);

% Display the results:
disp(closest_value)
disp(index)

%% About
%
%   author          - Danny Ramasawmy
%   contact         - dannyramasawmy+elasticmatrix@gmail.com
%   date            - 19 - August   - 2019
%   last update     - 19 - August   - 2019
%
% This file is part of the ElasticMatrix toolbox.
% Copyright (c) 2019 Danny Ramasawmy.
%
% This file is part of ElasticMatrix. ElasticMatrix is free software: you
% can redistribute it and/or modify it under the terms of the GNU Lesser
% General Public License as published by the Free Software Foundation,
% either version 3 of the License, or (at your option) any later version.
%
% ElasticMatrix is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser
% General Public License for more details.
%
% You should have received a copy of the GNU Lesser General Public License
% along with ElasticMatrix. If not, see <http://www.gnu.org/licenses/>.



