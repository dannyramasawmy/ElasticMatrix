%% Example: ElasticMatrix Class 
% A Medium class is used to initialize an ElasticMatrix object which
% solves the partial-wave method over a range of frequencies, wavenumbers,
% phasespeeds and angles. Additionally, this class contains methods for
% calculating dispersion curves, plotting field parameters and reflection
% and transmission coefficients.

%% Initialize an ElasticMatrix Object
% Initialize an ElasticMatrix object with a Medium object. For more details
% about the Medium class see: Example - Medium Class.

% Initialize the medium:
my_medium = Medium('water', Inf, 'aluminium', 0.001, 'water', Inf);

% An ElasticMatrix object can now be initialized, the ElasticMatrix class
% takes a Medium object as an input argument.
my_model = ElasticMatrix(my_medium);

% The .disp method prints the class to the command window, note the medium
% geometry is printed below the attributes of the class. Additionally, just
% typing my_model into the command window will call the .disp method
% automatically.
my_model.disp;

% An alternative way to initialize an ElasticMatrix object is to use the
% default constructor and set the medium geometry using the .setMedium
% function.
my_model = ElasticMatrix;
my_model.setMedium(my_medium);

%% Setting Calculation Parameters
% The parameters to calculate over are the frequency, angle, wavenumber and
% phase-speed. Firstly a range of frequencies must be defined using
% .setFrequency. Then at least one of angle, wavenumber or phasespeed must
% be defined using their respective set functions. If more than two of
% these properties are defined, .calculate will sort the inputs and use
% frequency, plus one other property in the order of preference from first
% to last: (1) angle - (2) phase-speed - (3) wavenumber. To clear the one
% of the object properties, call the respective set function with empty
% brackets, for example, my_model.setAngle([]);. If more than two of the
% properties are set, the redundant properties are not used.

% Set a range of angles:
my_model.setAngle(linspace(0, 45, 100));            % [degrees]

% Set a range of frequencies:
my_model.setFrequency(linspace(0.1e6, 5e6, 100));   % [Hz]

% Set a range of wave-numbers:
my_model.setWavenumber(linspace(1, 10000, 101));    % [1/m]

% Set a range of phasespeeds:
my_model.setPhasespeed(linspace(50, 1000, 101))     % [m/s]

%% Running the Model
% To run the partial-wave method for the case of a downward-traveling
% compressional wave in the first layer use .calculate.
my_model.calculate;
disp(my_model)

%% Additional Methods
% There are other methods that are available:
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
% To return the partial-wave amplitudes:
% - .getPartialWaveAmplitudes
% these are discussed in other example scripts


%% Saving the ElasticMatrix Object
% After performing the analysis the object can be saved. This may be
% desirable if the calculation was particularly large.

% Firstly set a filename for the object:
my_model.setFilename('my_elastic_matrix_object');

% The object can then be saved using the save method:
my_model.save;


