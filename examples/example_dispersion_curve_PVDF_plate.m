%%  example_dispersion_curve_plate
%
% Author    :   Danny Ramasawmy
%               rmapdrr@ucl.ac.uk
%               dannyramasawmy@gmail.com
% Date      :   2019-  -   created
%
%
% Description
%   This script demonstrates how to plot dispersion curves using the
%   ElasticMatrix code and compares it with the output from Disperse [1].
%   The algorithm implemented is similar to that in [2] however does not 
%   calcualte the dispersion cuvres in the imaginary domain.
%
%   [1]B. Pavlakovic, M. Lowe, D. Alleyne, P. Cawley, Disperse: a general
%       purpose program for creating dispersion curves, in: Review of 
%       progress in quantitative nondestructive evaluation, Springer, 1997, 
%       pp. 185{192.
%   [2] M. Lowe, Matrix techniques for modeling ultrasonic waves in 
%       multilayered media, IEEE Trans. Ultrason. Ferroelect. Freq. Contr. 
%       42 (4) (1995) 525-542.

%
% =========================================================================
%   INITALISE ELASTIC MATRIX CLASS 
% =========================================================================
cls;
% Firstly the ElasticMatrix object should be initialised using a Medium
% object

% check what materials already exist with the available materials function
% Medium.Available_Materials;

% calcualte the medium geometry titanium
% plateMedium = Medium('vacuum',0,'titanium',0.001,'vacuum',1);
plateMedium = Medium('vacuum',0,'PVDF',0.001,'vacuum',1);

% initalise the model
model = ElasticMatrix(plateMedium);

% =========================================================================
%   SET THE MODEL PARAMETERS
% =========================================================================

% set the model parameters
model.setFrequency(linspace(0.1e6, 2.5e6, 300));
% model.setAngle(linspace(0, 45, 200));
model.setPhasespeed(linspace(47, 2000, 1500)); 

% =========================================================================
%   CALCULATE THE DISPERSION CURVES
% =========================================================================

% calcualte dispersion curves, the code will plot a map of the condition
% number and show the dispersion curves tracing, this indicates if any of
% them are not tracing the correct path.
model.calculateDispersionCurves;

% if the dispersion curves will not trace use the coarse method below, this
% will search for the minima in the determinant map
% model.calculateDispersionCurvesCoarse;

% plot the dispersion curves, note the function will pick up the critical
% angle as a dispersion curve
[figureHandles] = model.plotDispersionCurves;

% save the data
% model.save('TitaniumDipsersionData')

xlim([0.1 2.5])
ylim([0 10])
xlabel('Frequency [MHz]')
ylabel('Phase Velocity [km/s]')
% legend('ElasticMatrix','Disperse')
box on
title('ElasticMatrix (lines) + Disperse (points)')






