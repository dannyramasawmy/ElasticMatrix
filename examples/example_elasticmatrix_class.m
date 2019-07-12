%% example_medium_class
%
% Author    :   Danny Ramasawmy
%               rmapdrr@ucl.ac.uk
%               dannyramasawmy@gmail.com
% Date      :   2019-01-25  -   created
%
%   This script will run through the different functionalities of the
%   ElasticMatrix class. An ElasticMatrix object is initalised by a Medium
%   object (see: example_medium_class for more details). 


% =========================================================================
%   INTIALISE MEDIUM AND ELASTICMATRIX
% =========================================================================
cls;
% Firstly a Medium object needs to be created. For more details see the
% example script : example_medium_class

% initalise the medium
myMedium = Medium('water',Inf,'aluminium',0.001,'water',Inf);

% ElasticMatrix can now be initalised, the ElasticMatrix class takes the
% Medium object as an input argument.
myModel = ElasticMatrix( myMedium );

% The .disp method prints the class to the command window, note the medium
% geometry is printed below the attributes of the class
myModel.disp;

% Alternatively the default constructor can be used, and the medium
% geometry set using the .setMedium function
myModel = ElasticMatrix;
myModel.setMedium( myMedium );

% =========================================================================
%   SETTING CALCULATION PARAMETERS
% =========================================================================
% The paramaters to calculate over are the frequency, angle, wavenumber and
% phasespeed. Only two need to be set, if more than two are set the code
% will calculate over only two in the order angle -> frequency ->
% wavenumber -> phasespeed.

% set a range of angles in [deg]
myModel.setAngle( linspace(0,45,100) );

% set a range of frequencies in [Hz]
myModel.setFrequency( linspace(0.1e6, 5e6, 100) );

% set a range of wavenumbers in [1/m]
myModel.setWavenumber( linspace(1, 100, 100) );

% set phasespeeds
myModel.setPhasespeed( linspace(50, 1000,100) )

% =========================================================================
%   RUNNING THE MATRIX METHOD
% =========================================================================

% to run the matrix method for the case of an incident compressional wave
% in the first layer use .calcualte, as mentioned previously, this will
% first sort the inputs and calculate using the first two parameters in the
% order anlge -> frequency -> wavenumber -> phasespeed
myModel.calculate;

% there are other methods that can be run:
% For estimating dispersion curves:
% .calculateDispersionCurves        
% .calculateDispersionCurvesCoarse 
% .plotDispersionCurves             
% Plotting the displacement and stress fields:
% .calculateField                             
% .plotField                        
% .plotInterfaceParameters          
% Plotting reflection coefficients
% .plotRCoefficients
% these are discussed in other example scripts

% =========================================================================
%   SAVING THE OBJECT
% =========================================================================
% After performing the analysis the object can be saved. This may be
% desirable if the calculation was particularly large

% firstly set a filename for the object
myModel.setFilename( 'myElasticMatrixObject' );

% the object can then be saved using the save method
myModel.save;
