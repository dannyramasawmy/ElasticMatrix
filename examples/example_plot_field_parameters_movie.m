%% Example Plot Field Parameters - Movie
% This example continues from example_plot_field_parameters.m, and
% demonstrates how to create a movie of a stress or displacement field.

%% Initialize ElasticMatrix Class
% Initialize the ElasticMatix object, in this example it will be an
% aluminium plate in water.

% Medium class:
medium = Medium(...
    'water',Inf, 'aluminium',0.001, 'water',Inf);

% Initialize ElasticMatrix class:
model = ElasticMatrix(medium);

%% Setting Parameters
% The model can be run over a single pair or vector of angles and
% frequencies. Ensure that the angle-frequency pair you wish to plot are
% included within the calculations.

% Chosen angle and frequency:
% Symmetric Lamb mode:
angle_s = 18.17;
freq_s = 6.092e6;

% Antisymmetric Lamb mode:
angle_a = 19.99;
freq_a = 4.425e6;

% Calculate the angle and frequency:
model.setFrequency([freq_s, freq_a]);
model.setAngle([angle_a, angle_s]);

% Run model:
model.calculate;

%% Define Z and X Vectors For the Plotting Mesh 
% In this example the aluminium plate is 1 mm thick, and the plotting
% ranges will be set to be greater than this. The number of points in the
% plotting range vectors defines the plotting grid density. The Z vector
% defines the plotting range across the thickness of each layer, and the X
% vector is parallel to the interface of each layer. 

% Define plotting vectors:
sample_points = 64;
Z = linspace( -1.5e-3, 0.5e-3, sample_points);
X = linspace( -1.5e-3, 1.5e-3, sample_points);

%% Loop and Write Movie

% uncomment lines below to initialize and open video writer class
vS = VideoWriter('TestAlPlateSmode.mp4','MPEG-4'); % VideoWriter class  
open(vS) 
vA = VideoWriter('TestAlPlateAmode.mp4','MPEG-4'); % VideoWriter class
open(vA)  

% create time array
t_vec =  linspace(0e-6, 0.5e-6, 200);

for tdx = 1:length(t_vec)
    
    % calculate fields for a symmetric and anti-symmetric mode
    field_s = model.calculateField(freq_s, angle_s, {Z, X}, t_vec(tdx));
    field_a = model.calculateField(freq_a, angle_a, {Z, X}, t_vec(tdx));
    
    % for the first loop - use a plotting argument
    if tdx == 1
        % mesh plotting style
        [fig_h1] = model.plotField(field_s, 'mesh');
        [fig_h2] = model.plotField(field_a, 'mesh');
    else
        
        % for the remaining loops pass the figure handle 
        % plot the symmetric mode
        model.plotField(field_s, fig_h1);
        
        % force plot
        frame_s = getframe(gcf);   
        writeVideo(vS, frame_s); 
        
        % plot the anti symmetric mode
        model.plotField(field_a, fig_h2);
        
        % update plot
        frame_a = getframe(gcf); 
        writeVideo(vA, frame_a); 
        
    end     
end

% close files
close(vS)  
close(vA)  
    
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



