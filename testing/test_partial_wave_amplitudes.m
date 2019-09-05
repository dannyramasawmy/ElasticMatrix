%% test_partial_wave_amplitudes
%
% DESCRIPTION
%   test_partial_wave_amplitudes compares the output from the method
%   .getPartialWaveAmplitudes with the property .partial_wave_amplitudes to
%   check the correct values are given.
%
% ABOUT
%   author          - Danny Ramasawmy
%   contact         - dannyramasawmy+elasticmatrix@gmail.com
%   date            - 04 - September    - 2019
%   last update     - 22 - September    - 2019
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
%   CREATE A SIMPLE PROBLEM
% =========================================================================

% create the geometry
my_medium = Medium(...
    'PVDF', Inf, 'glass', 0.001, 'aluminium',0.001,'perspex',Inf);

% create the model
my_model = ElasticMatrix(my_medium);

% set the parameters
my_model.setFrequency(linspace(0.1e6,5e6,30));
my_model.setAngle(linspace(0,45,45));

% calculate
my_model.calculate;

% =========================================================================
%   COMPARE PARTIAL WAVE AMPLITUDES
% =========================================================================


% compare layer 1 =========================================================
% use built in method
layer_1 = my_model.getPartialWaveAmplitudes(1);
% calculate errors
err_L1_SU = layer_1.qS_up - my_model.partial_wave_amplitudes(:,:,1);
err_L1_LU = layer_1.qL_up - my_model.partial_wave_amplitudes(:,:,2);

% print errors (should be 0)
disp('Errors L1 (should be 0)')
disp(mean(err_L1_LU(:)))
disp(mean(err_L1_SU(:)))

% compare layer 2 =========================================================
% use built in method
layer_2 = my_model.getPartialWaveAmplitudes(2);

err_L2_SU = layer_2.qS_up - my_model.partial_wave_amplitudes(:,:,3);
err_L2_SD = layer_2.qS_dw - my_model.partial_wave_amplitudes(:,:,4);
err_L2_LU = layer_2.qL_up - my_model.partial_wave_amplitudes(:,:,5);
err_L2_LD = layer_2.qL_dw - my_model.partial_wave_amplitudes(:,:,6);

% print errors (should be 0)
disp('Errors L2 (should be 0)')
disp(mean(err_L2_SU(:)))
disp(mean(err_L2_SD(:)))
disp(mean(err_L2_LU(:)))
disp(mean(err_L2_LD(:)))

% compare layer 3 =========================================================
% use built in method
layer_3 = my_model.getPartialWaveAmplitudes(3);

err_L3_SU = layer_3.qS_up - my_model.partial_wave_amplitudes(:,:,7);
err_L3_SD = layer_3.qS_dw - my_model.partial_wave_amplitudes(:,:,8);
err_L3_LU = layer_3.qL_up - my_model.partial_wave_amplitudes(:,:,9);
err_L3_LD = layer_3.qL_dw - my_model.partial_wave_amplitudes(:,:,10);

% print errors (should be 0)
disp('Errors L3 (should be 0)')
disp(mean(err_L3_SU(:)))
disp(mean(err_L3_SD(:)))
disp(mean(err_L3_LU(:)))
disp(mean(err_L3_LD(:)))

% compare layer 4 =========================================================
% use built in method
layer_4 = my_model.getPartialWaveAmplitudes(4);

err_L4_SD = layer_4.qS_dw - my_model.partial_wave_amplitudes(:,:,11);
err_L4_LD = layer_4.qL_dw - my_model.partial_wave_amplitudes(:,:,12);

% print errors (should be 0)
disp('Errors L4 (should be 0)')
disp(mean(err_L4_SD(:)))
disp(mean(err_L4_LD(:)))








