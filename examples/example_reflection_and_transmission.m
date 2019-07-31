%% example_reflection_and_transmission
%
% Author    :   Danny Ramasawmy
%               rmapdrr@ucl.ac.uk
%               dannyramasawmy@gmail.com
% Date      :   2019-01-25  -   created
%
% This function compares the reflection and transmission coefficients from
% the model with that from the analytical expressions given in [1] and [2].
%
% [1] Rose, Joseph L. Ultrasonic guided waves in solid media.
%   Cambridge university press, 2014.
% [2] Cheeke, J. David N. Fundamentals and applications of ultrasonic
%   waves. CRC press, 2016.
%
% =========================================================================
%   DEFINE MEDIUM GEOMETRY AND PARMETERS ELASTICMATRIX VS ROSE
% =========================================================================
cls;
% angle range
angleRange = linspace(0.1, 89, 500);

% define medium
myMedium = Medium('PVDF2',Inf,'aluminium2',Inf);

% initialize elastic matrix
myModel = ElasticMatrix(myMedium);
% set parameters
myModel.setAngle(angleRange);
% set an arbitrary frequency
myModel.setFrequency(1e6);

% run the model
myModel.calculate;

% this method plots the reflection coefficients
myModel.plotRTCoefficients;

% calculate reflection and transmission coefficient using the analytical
% functions from [1] and [2]
[RL, RS, TL, TS] = calculateReflectionTransmissionAnalytic(angleRange, myMedium);

% plot analytical results
title('ElasticMatrix with Rose solutions')
hold on
plot(angleRange, abs(RL), 'b.')
plot(angleRange, abs(RS), 'c.')
plot(angleRange, abs(TL), 'r.')
plot(angleRange, abs(TS), 'm.')
hold off
legend('|R_L| EM','|R_S| EM','|T_L| EM','|T_S| EM','|R_L| Rose','|R_S| Rose','|T_L| Rose','|T_S| Rose')
% errors
errorRL = (abs(RL) - abs(myModel.partial_wave_amplitudes(1, :, 2))) ./ abs(RL);
errorRS = (abs(RS) - abs(myModel.partial_wave_amplitudes(1, :, 1))) ./ abs(RS);
errorTL = (abs(TL) - abs(myModel.partial_wave_amplitudes(1, :, 4))) ./ abs(TL);
errorTS = (abs(TS) - abs(myModel.partial_wave_amplitudes(1, :, 3))) ./ abs(TS);

% print errors
disp('Mean errors for solid-solid medium')
disp(['Mean error RL : ', num2str(mean(errorRL))])
disp(['Mean error RL : ', num2str(mean(errorRS))])
disp(['Mean error TL : ', num2str(mean(errorTL))])
disp(['Mean error TS : ', num2str(mean(errorTS))])

% =========================================================================
%   ELASTICMATRIX VS CHEEKE
% =========================================================================

% define medium
myMedium = Medium('water',Inf,'aluminium2',Inf);

% initialize elastic matrix
myModel = ElasticMatrix(myMedium);
% set parameters
myModel.setAngle(angleRange);
% set an arbitrary frequency
myModel.setFrequency(1e6);

% run the model
myModel.calculate;

% this function plots the reflection coefficients
myModel.plotRTCoefficients;

% calculate reflection and transmission coefficient using the analytical
% functions from [1] and [2]
[RL, ~, TL, TS] = calculateReflectionTransmissionAnalytic(angleRange, myMedium);

% plot analytical results
title('ElasticMatrix with Cheeke solutions')
hold on
plot(angleRange, abs(RL), 'b.')
plot(angleRange, abs(TL), 'r.')
plot(angleRange, abs(TS), 'm.')
hold off
legend('|R_L| EM','|T_L| EM','|T_S| EM','|R_L| Rose','|T_L| Rose','|T_S| Rose')

% errors
errorRL = (abs(RL) - abs(myModel.partial_wave_amplitudes(1, :, 2))) ./ abs(RL);
% errorRS = (abs(RS) - abs(myModel.partial_wave_amplitudes(1, :, 1))) ./ abs(RS);
errorTL = (abs(TL) - abs(myModel.partial_wave_amplitudes(1, :, 4))) ./ abs(TL);
errorTS = (abs(TS) - abs(myModel.partial_wave_amplitudes(1, :, 3))) ./ abs(TS);

% print errors
disp('Mean errors for fluid-solid medium - no reflected shear')
disp(['Mean error RL : ', num2str(mean(errorRL))])
% disp(['Mean error RS : ', num2str(mean(errorRS))])
disp(['Mean error TL : ', num2str(mean(errorTL))])
disp(['Mean error TS : ', num2str(mean(errorTS))])
disp(['Note, the errors for the case of a fluid first layer are larger as'... 
    ,' the partial wave method approximates the fluid layer as having a'...
    ,' very low shear speed.'])




