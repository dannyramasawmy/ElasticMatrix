%% example_template_file 
%
% DESCRIPTION
%   A short description of the functionTemplate goes here
%
% ABOUT
%   author          - Danny Ramasawmy
%   contact         - dannyramasawmy+elasticmatrix@gmail.com
%   date            - DD - month - YYYY
%   last update     - DD - month - YYYY
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

%% Titles use a double comment
% Text proceeding titles only need a single comment.
% This line also appears as text.

% comments with a code block
for idx = 1:3
    % more comments
    disp( ['How many hello worlds? : ',num2str(idx)] )
end

%% Another section for figure plotting
% This section will plot a figure

% generate x-vector
xVector = linspace(-pi,pi,180);
yVector = sin(xVector);
% plot figure
plot(xVector, yVector, 'k.')
% labels
xlabel('x')
ylabel('y')





