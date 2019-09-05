%% test_medium_class
%
% DESCRIPTION
%   test_medium_class runs through the main functions in the Medium class.
%   If when running this script there is a fail, it may not be compatible
%   with your version of MATLAB. This script will not check the accuracy of
%   the implementations, only if it will run.
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
%   TEST 1 : MEDIUM
% =========================================================================
% This section will test the methods in Medium.

%% ========================================================================
disp('Test: src')
try
    addpath('../src-pw/')
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;
%% ========================================================================
disp('Test: Medium.availableMaterials;')
try
    Medium.availableMaterials
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;
%% ========================================================================
disp('Test: med = Medium(...)')
try
    my_medium = Medium('water',0,'apatite',1e-3,'glass',1);
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;
%% ========================================================================
disp('Test: medium.disp;')
try
    my_medium.disp;
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;
%% ========================================================================
disp('Test: Medium.setName(layer_index, new_name)')
try
    my_medium.setName(1,'newWater');
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;
%% ========================================================================
disp('Test: [stiffness] = Medium.soundSpeedDensityConversion(c_l, c_s, rho)')
try
    stiffness_matrix = my_medium.soundSpeedDensityConversion(5600,3300,2400);
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;
%% ========================================================================
disp('Test: Medium.setStiffnessMatrix(layer_index, stiffness_matrix)')
try
    my_medium.setStiffnessMatrix(3, stiffness_matrix);
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;
%% ========================================================================
disp('Test: Medium.setDensity(layer_index, rho) ')
try
    my_medium.setDensity(3, 2400);
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;
%% ========================================================================
disp('Test: Medium.setThickness(layer_index, thickness)')
try
    my_medium.setThickness(2, 50e-6);
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;
%% ========================================================================
disp('Test: [stiffnessMatrix] = Medium.lameConversion(lambda, mu)')
try
    if stiffness_matrix == Medium.lameConversion(stiffness_matrix(1,2),stiffness_matrix(5,5))
        disp('pass')
        
        total_pass = total_pass + 1;
    else
        total_fail = total_fail + 1;
        disp('fail')
    end
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;

%% ========================================================================
disp('Test: Medium.calculateSlowness')
try
    my_medium.calculateSlowness;
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;
%% ========================================================================
disp('Test: [figHand] = Medium.plotSlowness')
try
    figHandle = my_medium.plotSlowness;
    close(figHandle)
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;

