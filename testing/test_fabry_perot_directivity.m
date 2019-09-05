%% test_fabry_perot_directivity
%
% DESCRIPTION
%   test_fabry_perot_directivity models the directional response of an
%   air-backed glass plate Fabry-Perot sensor and compares with measurement
%   data taken on the same sensor.
%
% ABOUT
%   author          - Danny Ramasawmy
%   contact         - dannyramasawmy+elasticmatrix@gmail.com
%   date            - 15 - January  - 2019
%   last update     - 22 - August   - 2019
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

   
% =========================================================================
%   INITALISE MEDIUM AND FABRYPEROT SENSOR CLASS
% =========================================================================
cls;
% Firstly the geometry of the Fabry-Perot sensor needs to be defined 
my_sensor_geometry = Medium('water',Inf, 'glass',175.9e-6, 'air',Inf);

% the sensor geometry can be used to initialize the Fabry-perot class
sensor = FabryPerotSensor( my_sensor_geometry );

% =========================================================================
%   SET PARAMETERS
% =========================================================================
% as the FabryPerotSensor inherits the ElasticMatrix, all of the functions
% available to ElasticMatrix are also available to FabryPerotSensor
% set the range of angles and frequencies
sensor.setAngle( linspace(0, 45, 200) );
sensor.setFrequency( linspace(0.1e6, 50e6, 200) );

% set the interrogating beam spot diameter of the Fabry-Perot sensor
sensor.setSpotDiameter( 10e-6 );

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

% to plot the directivity normalized to 1
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
    %       - linear        - normalized to normal incidence response obj.directivity
    %       - decibel       - decibel of previous
    %       - normalise     - normalized to maximum value of normal incidence
    %       - normal        - normal incidence response
    

% to get the data normalized between 0 and 1
my_dir_data = sensor.getDirectivity('normalise');

% =========================================================================
%   PLOTTING THE DIRECTIVITY
% =========================================================================

load('../testing_data/glassEtalonFabryPerotDirectivityData.mat')

h = figure;
% subplot(1,2,1)
imagesc(angles,freqs/1e6,normDirL /(max(normDirL(:,162))))

% labels
ylim([0 50])
axis xy
xlabel('Angle [\circ]')
ylabel('Frequency [MHz]')
colormap parula

% subplot(1,2,2)
hold on
imagesc(-sensor.angle,sensor.frequency/1e6, sensor.getDirectivity('normalise'))
hold off
% labels
ylim([0 50])
axis xy
xlabel('Angle [\circ]')
ylabel('Frequency [MHz]')
colormap parula
caxis([0 1])
colorbar
axis square

% =========================================================================
%   CALCULATE DISPERSION CURVES
% =========================================================================
% Here the dispersion curves are calculated for a glass plate in a vacuum
% which is a good approximation for this sensor. The points for each mode
% are converted from phase-speed to an angle using the bulk wave-speed of
% the first layer in the sensor geometry (water) and plotted on a map of
% directivity.

% Geometry of the glass plate:
model_geometry = Medium('vacuum',Inf, 'glass',175.9e-6, 'vacuum',Inf);
model = FabryPerotSensor(model_geometry);

% Set properties
model.setFrequency( linspace(0.1e6, 50e6, 150) );

% Calculate dispersion curves:
model.calculateDispersionCurves;

figure(h)
hold on
% Loop over each guided mode curve:
for idx = 1:length(model.dispersion_curves)
    
    % Retrieve dispersion curve points:
    cph_points  = model.dispersion_curves(idx).c;
    f_points    = model.dispersion_curves(idx).f;
    
    % Convert phase-speed to angle using the sound-speed in the first layer
    % (water):
    angle_points = real(asin(1480 ./ cph_points)) * 180/pi;
    
    % Plot dispersion points over a directivity map:
    plot(angle_points, f_points/1e6, 'k--')
    plot(-angle_points, f_points/1e6, 'k--')

end


