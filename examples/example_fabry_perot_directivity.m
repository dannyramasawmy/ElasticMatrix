%% example_fabry_perot_directivity
%
% Author    :   Danny Ramasawmy
%               rmapdrr@ucl.ac.uk
%               dannyramasawmy@gmail.com
% Date      :   2019-01-25  -   created
%
% This script demonstrates the Fabry-Perot Class and how it can model the
% directional response of the sensor. See [1] for more details.
%
%   [1] Ramasawmy, D. R., et al. "Analysis of the Directivity of Glass 
%       Etalon Fabry-Pérot Ultrasound Sensors." IEEE transactions on 
%       ultrasonics, ferroelectrics, and frequency control (2019).
%   
% =========================================================================
%   INITALISE MEDIUM AND FABRYPEROT SENSOR CLASS
% =========================================================================
cls;
% Firstly the geometry of the Fabry-Perot sensor needs to be defined 
mySensorGeometry = Medium('water',Inf, 'glass',175.9e-6, 'air',Inf);

% the sensor geometry can be used to initalise the Fabry-perot class
sensor = FabryPerotSensor( mySensorGeometry );

% =========================================================================
%   SET PARAMETERS
% =========================================================================
% as the FabryPerotSensor inherits the ElasticMatrix, all of the functions
% available to ElasticMatrix are also available to FabryPerotSensor
% set the range of angles and frequencies
sensor.setAngle( linspace(0, 45, 200) );
sensor.setFrequency( linspace(0.1e6, 50e6, 200) );

% set the interrogating beam spot diameter of the Fabry-Perot sensor
sensor.setSpotSize( 10e-6 );

% set the interrogating laser beam profile of the Fabry-Perot sensor, this
% can be either 'collimated' or 'gaussian'
sensor.setSpotType('gaussian');

% set the locations of the Fabry-Perot mirrors, these are defined as the
% location of the interfaces, for example between layer index 1 and layer 
% index 2 is interface 1 and between layer index 2 and layer index 3 is
% interface 2
interface1 = 1;
interface2 = 2;
sensor.setMirrorLocations([interface1, interface2])

% =========================================================================
%   CALCULATE AND PLOT THE MODEL
% =========================================================================
% calculate the directivity
sensor.calculateDirectivity;

% to plot the directivity on the decibel scale
[figureHandle(1)] = sensor.plotDirectivity('decibel');

% to plot the sensors frequency response 
[figureHandle(2)] = sensor.plotDirectivity('normal');

% to plot the directivity normalised to 1
[figureHandle(3)] = sensor.plotDirectivity('normalise');

% to plot the directivity on a linear scale
[figureHandle(4)] = sensor.plotDirectivity('linear');

% to plot the wrapped phase of the directivity
[figureHandle(4)] = sensor.plotDirectivity('linear');

% to plot all of the above
[figureHandle(6:10)] = sensor.plotDirectivity;
 
% to distribute the figures on the screen
sfg;

% =========================================================================
%   GETTING THE DIRECTIVITY
% =========================================================================
% to process the directional response in a different way the raw
% directivity data can be taken using the .getDirectivity function.
    % with these input arguments
    %       - raw           - calculated obj.directivity
    %       - real          - imaginary part of obj.directivity
    %       - imag          - real part of obj.directivity
    %       - phase         - phase of obj.directivity
    %       - abs           - obj.directivity
    %       - linear        - normalised to normal incidence respose obj.directivity
    %       - decibel       - decibel of previous
    %       - normalise     - normalised to maximum value of normal incidence
    %       - normal        - normal incidence response
    

% to get the data normalised between 0 and 1
myDirData = sensor.getDirectivity('normalise');

% =========================================================================
%   ADD DISPERSION CURVE DATAS
% =========================================================================

% calculate the dispersion curves
sensor.calculateDispersionCurvesCoarse;

% plot the dispersion curve data
hold on
plot(-sensor.dispersion_curves.y, sensor.dispersion_curves.x/1e6,'k.')
plot(sensor.dispersion_curves.y, sensor.dispersion_curves.x/1e6,'k.')
hold off



