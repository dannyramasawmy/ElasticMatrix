%% example_plot_field_parameters
%
% Author    :   Danny Ramasawmy
%               rmapdrr@ucl.ac.uk
%               dannyramasawmy@gmail.com
% Date      :   2019-01-25  -   created
%
% This script demonstrates how to plot the displacement and stress fields
% for the layered medium. This is calculated for a certain angle and
% frequency. Currently the first layer cannot be a vacuum or air;

% ========================================================================
%   MODEL
% =========================================================================
% firstly run the model over a range or single pair of angle(s) and 
% frequencie(s). Ensure that the angle-frequency pair you wish to plot the
% fields for are included within the calculations. 

% initalise the medium
medium = Medium(...
    'water',Inf, 'aluminium',0.001, 'water',Inf);

% initalise ElasticMatrix class
model = ElasticMatrix(medium);
% set some properties
model.setFrequency(linspace(0.1e6, 10e6, 100));
model.setAngle(linspace(0,89,100));
% run model to calcualte the partial wave coefficients, these are used to
% plot the field values
model.calculate;

% =========================================================================
%   DEFINE THE Z AND X VECTORS THAT THE PLOTTING MESH WILL USE
% =========================================================================

% 19.99, 4.425e6
% 18.17, 6.092e6

% vectors range and number of points
samplePoints = 128;
Zhf = linspace( -1.5e-3, 0.5e-3, samplePoints);
Xhf = linspace( -1.5e-3, 1.5e-3, samplePoints);

% choose the angle and frequency to plot
chosenAngle = 19.99; 
chosenFrequency = 4.425e6;

% run calculate field
disp('[outputField] = model.calculatedField(angle, frequency, chosenFrequency, {Z_hf, X_hf})')
[outputField] = model.calculateField( ...
    chosenFrequency, chosenAngle, {Zhf, Xhf});

% output field is a structure that contains
%   - z - normal displacement field
%   - x - transverse displacement field
%   - sigma zz normal stress field
%   - sigma xz shear stress field
%   - vector of x-range
%   - vector of z-range
disp( 'outputfield...' );
disp( outputField );

% =========================================================================
%   PLOTTING THE FIELD
% =========================================================================
% The field can be plotted by passing the outputField structure to the plot
% field function. Different types of plot can be 
% '1DDisplacement'
% '2DDisplacement'
% '1DStress'
% '2DStress'
% 'Vector'
% 'Mesh'
% 'Surf'
% 'All'

disp('[figHand] = model.plotField(outputField, vararginPlottingInputs );')
disp('Note: Z = 0 is the interface between the first and second layer')

% to plot the normal and transverse displacement along the line x=0 z=Z_hf
[figHand] = model.plotField(outputField, '1DDisplacement');

% to plot the normal and transverse displacement along the line x=0 z=Z_hf
[figHand] = model.plotField(outputField, '1DStress');

% to plot the 2D fields for displacement and stress
[figHand] = model.plotField(outputField, '2DDisplacement', '2DStress');

% to plot a mesh and surf plot of the displacement
[figHand] = model.plotField(outputField, 'Mesh', 'Surf');

% to plot everything
[figHand] = model.plotField(outputField, 'All');

% =========================================================================
%   USING A FIGURE HANDLE STUCTURE AS THE INPUT ARGUMENT
% =========================================================================
% For some cases, like when creating a movie of the displacement field, the
% user may require the next figure is plotted over the same figure axes.
% The .plotField method can take an input argument of a figure handle in
% this case

% calcualte the field at a certain time
timeIndex = 0e-6;
[outputField] = model.calculateField(...
    chosenFrequency, chosenAngle, {Zhf, Xhf}, timeIndex);

% plot the figure with the input argument for the first step - this creates
% two new figures where the handles are assigned to
% newFigureHandle.mesh and newFigureHandle.surf
newFigureHandle = model.plotField( outputField, 'Mesh', 'Surf');

% create the new / updated field
timeIndex = 0.1e-6;
[updatedField] = model.calculateField(...
    chosenFrequency, chosenAngle, {Zhf, Xhf}, timeIndex);

% plot a new figure, but instead of giving plotting figure input arguments
% give the figure handle from the previous plotting step - this will update
% the two figures and not create two new figures
newFigureHandle = model.plotField( updatedField, newFigureHandle);

disp('Note: for CubicInAs part of the qSV curve is represented in the qL curve')





