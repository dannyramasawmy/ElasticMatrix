%% Example: Dispersion Curves - PVDF Plate
% This example follows the same format as: Example: Dispersion Curves -
% Titanium Plate.

%% Initialize an ElasticMatrix Object
% Initialize an ElasticMatrix object with a Medium object.

% A PVDF plate:
my_medium = Medium('vacuum', 0, 'PVDF', 0.001, 'vacuum', 1);

% Initialize the object:
my_model = ElasticMatrix(my_medium);

%% Setting Calculation Parameters
% Set a range of frequencies:
my_model.setFrequency(linspace(0.1e6, 2.5e6, 2)); % [Hz]

%% Calculating Dispersion Curves
% Calculate the dispersion curves:
my_model.calculateDispersionCurves;

%% Plotting Dispersion Curves
% The dispersion curves can be plotted using the .plotDispersionCurves
% method. Note: the algorithm will occasionally identify the critical angle
% as a dispersion curve.

% Plot dispersion curves:
figure_handles = my_model.plotDispersionCurves;







