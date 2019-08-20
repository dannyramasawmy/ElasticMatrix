%% Example: Reflection and Transmission 
% For a plane wave incident at an oblique angle on a multi-layered
% structure, the reflection and transmission coefficients determine the
% amplitude of the wave that is reflected and transmitted at each interface
% of the multi-layered structure. Knowing the reflection and transmission
% coefficients is useful for a number of applications. For example,
% selecting the appropriate launch angle when coupling energy into
% particular modes in a wave-guide, or determining the thickness and
% material properties of matching layers for ultrasonic transducers
% [1,2].
% 
% The angles of refraction at the interfaces between multi-layered media can
% be found by studying the slowness profiles. However, slowness profiles do
% not take into account the boundary conditions at the interfaces.
% Consequently, the magnitude of each of the refracted waves cannot be
% calculated directly using the slowness profiles. For a plane wave
% incident on a multi-layered structure, the magnitude of the reflection and
% transmission coefficients are found by normalizing the partial wave
% amplitudes by the incident plane wave amplitude. This is automatically
% calculated when using the .calculate method.
% 
% This example compares the reflection and transmission coefficients from
% the model with that from the analytical expressions given in [1] and [2].
%
% [1] Rose, Joseph L. Ultrasonic guided waves in solid media.
%   Cambridge university press, 2014.
% [2] Cheeke, J. David N. Fundamentals and applications of ultrasonic
%   waves. CRC press, 2016.

%% Comparing ElasticMatrix vs Rose
% An example of the reflection and transmission coefficients for a
% PVDF-Aluminium interface is given below. For a plane compressional wave
% incident on a PVDF-Aluminium interface, there are four resulting
% refracted waves. These are a reflected $R$ and transmitted $T$
% compressional $L$ and shear $S$ wave. The reflection and transmission
% coefficients have been compared to the analytical solutions for a
% two-layered elastic-medium from [1] and have an average error
% less than $1e^{-15}$ which is within numerical precision for a 64 bit
% floating point number.

%% Initialize ElasticMatrix Class

% Define the medium:
my_medium = Medium('PVDF2',Inf,'aluminium2',Inf);

% Initialize ElasticMatrix class:
my_model = ElasticMatrix(my_medium);

%% Setting Parameters
% Here only the angle-dependent coefficients are calculated. 

% Define an angle range:
angle_range = linspace(0.1, 89, 500);

% Set parameters:
my_model.setAngle(angle_range);
% Set an arbitrary frequency:
my_model.setFrequency(1e6);

%% Calculating Reflection and Transmission Coefficients
% The reflection and transmission coefficients are calculated when the
% .calculate method is used.

% Calculate reflection and transmission coefficients:
my_model.calculate;

% Calculate reflection and transmission coefficient using the analytical
% functions from [1] and [2]:
[RL, RS, TL, TS] = calculateReflectionTransmissionAnalytic(angle_range, my_medium);

%% Plotting Reflection and Transmission Coefficients
% The reflection and transmission coefficients can be plotted using the
% .plotRTCoefficients method. Here, the analytical expressions have also
% been plotted:

% Plots the reflection coefficients:
my_model.plotRTCoefficients;

% Add the analytic results:
title('ElasticMatrix with Rose solutions')
hold on
plot(angle_range, abs(RL), 'b.')
plot(angle_range, abs(RS), 'c.')
plot(angle_range, abs(TL), 'r.')
plot(angle_range, abs(TS), 'm.')
hold off
legend('|R_L| EM','|R_S| EM','|T_L| EM','|T_S| EM','|R_L| Rose','|R_S| Rose','|T_L| Rose','|T_S| Rose')

% Calculate normalized errors:
error_RL = (abs(RL) - abs(my_model.partial_wave_amplitudes(1, :, 2))) ./ abs(RL);
error_RS = (abs(RS) - abs(my_model.partial_wave_amplitudes(1, :, 1))) ./ abs(RS);
error_TL = (abs(TL) - abs(my_model.partial_wave_amplitudes(1, :, 4))) ./ abs(TL);
error_TS = (abs(TS) - abs(my_model.partial_wave_amplitudes(1, :, 3))) ./ abs(TS);

% Print Errors
disp('Mean errors for solid-solid medium')
disp(['Mean error RL : ', num2str(mean(error_RL))])
disp(['Mean error RL : ', num2str(mean(error_RS))])
disp(['Mean error TL : ', num2str(mean(error_TL))])
disp(['Mean error TS : ', num2str(mean(error_TS))])

%% Comparing ElasticMatrix vs Cheeke
% An example of the reflection and transmission coefficients for a
% water-Aluminium interface is given below. For a plane compressional wave
% incident on a water-Aluminium interface, there are three resulting
% refracted waves. These are a reflected $R$ and transmitted $T$
% compressional $L$ and wave and a transmitted shear $S$ wave. The
% reflection and transmission coefficients have been compared to the
% analytical solutions for a two-layered elastic-medium from [2].

%%  Initialize ElasticMatrix Class

% Define the medium:
my_medium = Medium('water',Inf,'aluminium2',Inf);

% Initialize ElasticMatrix class:
my_model = ElasticMatrix(my_medium);

%% Setting Parameters

% Define an angle range:
angle_range = linspace(0.1, 89, 500);

% Set parameters:
my_model.setAngle(angle_range);
% Set an arbitrary frequency:
my_model.setFrequency(1e6);


%% Calculating Reflection and Transmission Coefficients
% The reflection and transmission coefficients are calculated when the
% .calculate method is used.

% Calculate reflection and transmission coefficients:
my_model.calculate;

% Calculate reflection and transmission coefficient using the analytical
% functions from [1] and [2]:
[RL, ~, TL, TS] = calculateReflectionTransmissionAnalytic(angle_range, my_medium);

%% Plotting Reflection and Transmission Coefficients
% The reflection and transmission coefficients can be plotted using the
% .plotRTCoefficients method. Here, the analytical expressions have also
% been plotted:

% Plots the reflection coefficients:
my_model.plotRTCoefficients;

% Add the analytic results:
title('ElasticMatrix with Cheeke solutions')
hold on
plot(angle_range, abs(RL), 'b.')
plot(angle_range, abs(TL), 'r.')
plot(angle_range, abs(TS), 'm.')
hold off
legend('|R_L| EM','|T_L| EM','|T_S| EM','|R_L| Rose','|T_L| Rose','|T_S| Rose')

% Calculate normalized errors:
error_RL = (abs(RL) - abs(my_model.partial_wave_amplitudes(1, :, 2))) ./ abs(RL);
error_TL = (abs(TL) - abs(my_model.partial_wave_amplitudes(1, :, 4))) ./ abs(TL);
error_TS = (abs(TS) - abs(my_model.partial_wave_amplitudes(1, :, 3))) ./ abs(TS);

% Note: the errors for the case of a fluid first layer are larger as the
% partial wave method approximates the fluid layer as having a very low
% shear speed.

% Print errors:
disp('Mean errors for fluid-solid medium - no reflected shear')
disp(['Mean error RL : ', num2str(mean(error_RL))])
disp(['Mean error TL : ', num2str(mean(error_TL))])
disp(['Mean error TS : ', num2str(mean(error_TS))])

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






