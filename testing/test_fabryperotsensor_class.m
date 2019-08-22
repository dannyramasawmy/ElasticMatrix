%% test_fabryperotsensor_class
%
% DESCRIPTION
%   test_fabryperotsensor_class runs through the main functions in the
%   FabryPerotSensor class. If when running this script there is a fail, it
%   may not be compatible with your version of MATLAB. This script will not
%   check the accuracy of the implementations, only if it will run.
%
% ABOUT
%   author          - Danny Ramasawmy
%   contact         - dannyramasawmy+elasticmatrix@gmail.com
%   date            - 22 - August   - 2019
%   last update     - 22 - August   - 2019
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

% =========================================================================
%  PASS/FAIL COUNTERS
% =========================================================================

% if this script is called as part of test_main_functions these variables
% will be assigned prior to running this script
if ~exist('total_counter','var')
    total_counter = 0;
    total_pass = 0;
    total_fail = 0;
end

% =========================================================================
%  TEST 3 : FABRYPEROTSENSOR
% =========================================================================
% The fabry-perot class inherits the elastic matrix class, this section
% will test the additional methods of this class

disp('Test: model = FabryPerotSensor(mediumObject)')
try
    % make the example medium
    sensor_medium      = Medium(...
        'water',Inf,'glass',200e-6,'water',Inf);
    sensor = FabryPerotSensor(sensor_medium);
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;
%% ========================================================================
disp('Test: FabryperotSensor.setSpotType(spotType)')
try
    sensor.setSpotType('collimated');
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;
%% ========================================================================
disp('Test: FabryperotSensor.setSpotDiameter(spotDiameter) ')
try
    sensor.setSpotDiameter(50e-6);
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;
%% ========================================================================
disp('Test: FabryperotSensor.setMirrorLocations([interfaceIndex, interfaceIndex]) ')
try
    sensor.setMirrorLocations([1 2]);
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;
%% ========================================================================
disp('Test: FabryperotSensor.calculateDirectivity;')
try
    sensor.setAngle(linspace(0, 50,50));
    sensor.setFrequency(linspace(0.1e6,50e6,50))
    sensor.calculateDirectivity;
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;
%% ========================================================================
disp('Test: [figHand] = FabryperotSensor.plotDirectivity;')
try
    [figHand] = sensor.plotDirectivity;
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;
%% ========================================================================
disp('Test: FabryperotSensor.getDirectivity')
try
    myDirectivity = sensor.getDirectivity;
    close all
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;