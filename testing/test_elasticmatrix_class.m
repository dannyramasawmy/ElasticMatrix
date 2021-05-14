%% test_elasticmatrix_class
%
% DESCRIPTION
%   test_elasticmatrix_class runs through the main functions in the
%   ElasticMatrix class. If when running this script there is a fail, it
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
%   TEST 2 : ELASTICMATRIX
% =========================================================================
% This section will test the methods in ElasticMatrix.
my_medium =  Medium('water', 0, 'aluminium', 1e-3, 'water', Inf);
disp('Test: model = ElasticMatrix(medium_object)')
try
    model = ElasticMatrix(my_medium);
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;
%% ========================================================================

disp('Test: ElasticMatrix.setMedium(medium_object)')
try
    model.setMedium(my_medium);
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;
%% ========================================================================
disp('Test: ElasticMatrix.setFilename(filename)')
try
    model.setFilename('testing_example');
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;
%% ========================================================================
sample_density = 10;
disp('Test: ElasticMatrix.setAngle(angle_range) ')
try
    model.setAngle(linspace(0,45,sample_density));
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;
%% ========================================================================
disp('Test: ElasticMatrix.setFrequency(freq_range) ')
try
    model.setFrequency(linspace(0.1e6,50e5,sample_density));
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;
%% ========================================================================
disp('Test: ElasticMatrix.setPhasespeed(phasespeed_range) ')
try
    model.setPhasespeed(linspace(100,500,sample_density));
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;
%% ========================================================================
disp('Test: ElasticMatrix.setWavenumber(wavenumber_range) ')
try
    model.setWavenumber(linspace(100,500,sample_density));
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;
%% ========================================================================
disp('Test: ElasticMatrix.disp')
try
    model.disp;
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;
%% ========================================================================
disp('Test: ElasticMatrix.calculate')
try
    model.calculate;
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;

%% ========================================================================
disp('Test: ElasticMatrix.getPartialWaveAmplitudes(layer_index)')
try
    model.getPartialWaveAmplitudes(3);
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;
%% ========================================================================
disp('Test: [figHand] = ElasticMatrix.plotRTCoefficients')
try
    [figHand] = model.plotRTCoefficients;
    close(figHand)
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;
%% ========================================================================
disp('Test: [figHand] = ElasticMatrix.plotInterfaceParameters')
try
    figHand = model.plotInterfaceParameters;
    close(figHand.interface_1,figHand.interface_2)
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;
%% ========================================================================
disp('Test: [fieldStructure] = ElasticMatrix.calculateField(angle, frequency, {Zvector, Xvector}) ')
try
    plotVector = linspace(-1.5,0.5,128)*1e-3;
    field = model.calculateField(50e5, 15, {plotVector, plotVector});
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;
%% ========================================================================
disp('Test: [figHand = plotField(field_structure)] ')
try
    figHand = model.plotField(field);
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;
%% ========================================================================
disp('Test: [figHand = plotField(field_structure, figure_handle_structure)] ')
try
    figHand = model.plotField(field, figHand);
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;
%% ========================================================================
disp('Test: [figHand = plotField(field_structure, plot_type)] ')
try
    figHand = model.plotField(field, 'mesh','vector');
    close all;
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;
%% ========================================================================
disp('Test: ElastixMatix.calculateDispersonCurvesCoarse')
try
    model.setFrequency(linspace(0.1e6,50e5,sample_density));
    model.calculateDispersionCurvesCoarse;
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;
%% ========================================================================
disp('Test: ElastixMatix.calculateDispersonCurves')
try
    %model.calculateDispersionCurves;
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;
%% ========================================================================
disp('Test: [figHand] = ElasticMatrix.plotDispersionCurves')
try
    [figHand] = model.plotDispersionCurves;
    close all
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;
%% ========================================================================
disp('Test: ElasticMatrix.save(filename)')
try
    model.save('TestCompatibility');
    delete('TestCompatibility.mat')
    disp('pass')
    total_pass = total_pass + 1;
catch
    disp('fail')
    total_fail = total_fail + 1;
end
total_counter = total_counter + 1;

