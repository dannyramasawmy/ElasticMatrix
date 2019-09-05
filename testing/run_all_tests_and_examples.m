%% run_all_tests_and_examples
%
% DESCRIPTION
%   run_all_tests_and_examples will run all examples scripts in the
%   ./examples folder and the examples in the ./testing folder. The
%   examples in the testing folder uses data which is unavailable on the
%   github link. 
%
% ABOUT
%   author          - Danny Ramasawmy
%   contact         - dannyramasawmy+elasticmatrix@gmail.com
%   date            - 15 - January      - 2019
%   last update     - 04 - September    - 2019
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
%   ADDPATHS
% =========================================================================
addpath('../src-pw/');
addpath('../examples')
addpath('../data')

% =========================================================================
%   RUN ALL SCRIPTS
% =========================================================================

if exist('../testing_data/','dir')
    % compatibility (MATLAB version)
    test_main_functions;
    pause(2);
    cls;
    
    % check getPartialWaveAmplitudes gives the right output
    test_partial_wave_amplitudes;
    pause(2)
    cls;
    
    % comparison script
    test_comparison_with_GMM;
    pause(2);
    cls;
    
    % test the fabry perot directivity
    test_fabry_perot_directivity;
    pause(2);
    cls
    
    % test fabry perot frequency response
    test_fabry_perot_frequency_response;
    pause(2);
    cls;
    
    % calculation vs number of layers
    test_n_layers_vs_calculation_time;
    pause(2);
    cls;
    
else
    warning('... testing data is not included ...')
    
end

% test the medium class
example_medium_class;  
pause(2);
cls;

% plotting the slowness profiles
example_slowness_profiles;
pause(2);
cls;

% test elastic matrix class
example_elasticmatrix_class;
pause(2);
cls;

% plotting the reflection coefficient
example_reflection_and_transmission; 
pause(2);
cls;

% plotting displacement and stress at the interface
example_interface_parameters;
pause(2);
cls;

% plotting a displacement and stress field
example_plot_field_parameters;        
pause(2);
cls;

% plotting a displacement and stress field
example_plot_field_parameters_movie;        
pause(2);
cls;

% dispersion curve calculation comparison with disperse
example_dispersion_curve_titanium_plate;  
pause(2);
cls;

% PVDF plate
example_dispersion_curve_PVDF_plate   
pause(2);
cls;

% trest the fabry perot directivity
example_fabry_perot_directivity;   
pause(2);
cls;

% test fabry perot frequency response
example_fabry_perot_frequency_response;    
pause(2);
cls;

% finish / delete saved files and objects
delete('*.mat')
delete('*.mp4')

clc; close all;
disp('... finished, all scripts have run ...')
