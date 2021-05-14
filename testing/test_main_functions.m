%% test_main_functions
%
% DESCRIPTION
%   test_main_functions runs through the main functions in the
%   ElasticMatrix software. If when running this script there is a fail, it
%   may not be compatible with your version of MATLAB. This script will not
%   check the accuracy of the implementations, only if it will run.
%
% ABOUT
%   author          - Danny Ramasawmy
%   contact         - dannyramasawmy+elasticmatrix@gmail.com
%   date            - 15 - January  - 2019
%   last update     - 22 - August   - 2019
%
% This file is part of the ElasticMatrix toolbox.
% Copyright (c) 2021 Danny Ramasawmy.
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

% =========================================================================
%  RUN CLASS TEST SCRIPTS
% =========================================================================

% counters
total_counter = 0;
total_pass = 0;
total_fail = 0;

% test the Medium class
test_medium_class;

% test the ElasticMatrix class
test_elasticmatrix_class;

% test the FabryPerotSensor class
test_fabryperotsensor_class;

% =========================================================================
%  RESULTS
% =========================================================================
printLineBreaks;
disp(['Total number of tests    : ',num2str(total_counter)])
disp(['Total passed             : ',num2str(total_pass)])
disp(['Total failed             : ',num2str(total_fail)])
printLineBreaks;

