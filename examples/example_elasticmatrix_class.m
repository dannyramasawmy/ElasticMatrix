%% Example: ElasticMatrix Class 
% The medium class is used to initialize the ElasticMatrix class which
% solves the partial-wave method over a range of frequencies, wave-numbers,
% phase-speeds and angles. Additionally, this class contains methods for
% calculating dispersion curves, plotting field parameters and reflection
% and transmission coefficients.

%% Initialize a Medium and ElasticMatrix Object
% Firstly a Medium object needs to be created. For more details see the
% Medium Class help page.

% Initialize the medium:

my_medium = Medium('water',Inf,'aluminium',0.001,'water',Inf);

% ElasticMatrix can now be initialized, the ElasticMatrix class takes the
% Medium object as an input argument.

my_model = ElasticMatrix( my_medium );

% The .disp method prints the class to the command window, note the medium
% geometry is printed below the attributes of the class

my_model.disp;

% Alternatively, the default constructor can be used, and the medium
% geometry set using the .setMedium function

my_model = ElasticMatrix;
my_model.setMedium( my_medium );

%% Setting Calculation Parameters
% The parameters to calculate over are the frequency, angle, wavenumber and
% phase-speed. Only two need to be set, if more than two are set the code
% will calculate over only two in the order frequency -> angle ->
% phase-speed -> wavenumber .

% Set a range of angles in [deg]:
my_model.setAngle( linspace(0,45,100) );

% Set a range of frequencies in [Hz]:
my_model.setFrequency( linspace(0.1e6, 5e6, 100) );

% Set a range of wave-numbers in [1/m]:
my_model.setWavenumber( linspace(1, 10000, 101) );

% Set phase-speeds:
my_model.setPhasespeed( linspace(50, 1000, 101) )

%% Running the Model
% To run the partial-wave method for the case of an incident compressional
% wave in the first layer use .calculate, as mentioned previously, this
% will first sort the inputs and calculate using the first two parameters
% in the order frequency -> angle -> phase-speed -> wavenumber

my_model.calculate;
my_model.disp;

%% Additional Methods
% There are other methods that can be run:
% For estimating dispersion curves:
% - .calculateDispersionCurves        
% - .calculateDispersionCurvesCoarse 
% - .plotDispersionCurves             
% Plotting the displacement and stress fields:
% - .calculateField                             
% - .plotField                        
% - .plotInterfaceParameters          
% Plotting reflection coefficients
% - .plotRCoefficients
% these are discussed in other example scripts

%% Saving the ElasticMatrix Object
% After performing the analysis the object can be saved. This may be
% desirable if the calculation was particularly large

% Firstly set a filename for the object:
my_model.setFilename( 'myElasticMatrixObject' );

% The object can then be saved using the save method:
my_model.save;

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



