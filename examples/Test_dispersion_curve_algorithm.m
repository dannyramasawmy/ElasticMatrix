%%  Test_dispersion_curve_algorithm - v1.0 Date: 2018-
%
% Author    :   Danny Ramasawmy
%               rmapdrr@ucl.ac.uk
%               dannyramasawmy@gmail.com
% Date      :   2019-  -   created
%
%
% Description
%   This script will implement a dispersion curve algorithm
%
% ERROR     :   2019-
%
%
%% ========================================================================
%   PATHS AND CLEAN
% =========================================================================
% add path
addpath(genpath('./mat_funcs'));
% AddKwave;
% clean workspaces
cls;

%% ========================================================================
%   MODEL
% =========================================================================

% find the available materials
% Medium.Available_Materials;

% calcualte the medium geometry
medium_geometry = Medium.generateLayeredMedium(...
    'vacuum',0,'aluminium',0.001,'vacuum',1);

% initalise the model
model = ElasticMatrix(medium_geometry);

% set the model parameters
model.setFrequency(linspace(0.1e6, 5e6, 300));
model.setAngle(linspace(0, 45, 200));
% model.Set_Phasespeed(linspace(300, 8000, 200)); % 5 m/s steps

% =========================================================================
%{
% check the wavenumber - frequency implementation
wavenumber_vec = linspace(3, 10000, 300);
[metrics] = ...
    Calculate_Matrix_Model_Kf(...
    medium_geometry, model.frequency, wavenumber_vec, 1 );

figure;
imagesc(wavenumber_vec, model.frequency ,log10(abs(metrics)));
axis xy

model.Calculate_Dispersion_Curves
phaseSpeed = 1500 ./sin(model.dispersion_curves(:,2) * pi/180);
kdisp = (2*pi*model.dispersion_curves(:,1) ./ phaseSpeed);

hold on
plot(kdisp, model.dispersion_curves(:,1), 'k.')

%}


% calcualte model
model.calculateDispersionNew;


% model.Calculate_Dispersion_Curves
% 
% figure;
% plot(model.dispersion_curves(:,1), model.dispersion_curves(:,2), '.')
% 
% phaseSpeed = 330 ./sin(model.dispersion_curves(:,2) * pi/180);
% 
% 
% figure;
% plot(model.dispersion_curves(:,1),phaseSpeed, '.')
% 

