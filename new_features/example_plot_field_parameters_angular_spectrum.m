%% Example: Plot Field Parameters
% Information about the wave-physics of multi-layered structures can be
% gained by plotting the displacement and stress fields at different
% points. In ElasticMatrix, the angle, frequency and x-z range over which
% to plot the displacement or stress fields must be specified. The
% .calculateField method uses the x-z ranges to define a grid, calculates
% the displacement and stress for each point on the grid for a plane wave
% at the specified angle and frequency and returns the field parameters in
% a structure. The values of the structure can be plotted independently or
% given as an argument to the .plotField method.

%% Initialize an ElasticMatrix Object
% Initialize an ElasticMatix object, in this example it will be an
% aluminium plate in water.

% Medium class:
my_medium = Medium(...
    'water', Inf, 'parylene_C', 0.001, 'water', Inf);

% Initialize an ElasticMatrix object:
my_model = ElasticMatrix(my_medium);

%% Setting Calculation Parameters
% In this example the aluminium plate is $1$mm thick, and the plotting
% ranges are set to be greater than this. The number of points in the
% plotting range vectors defines the plotting grid density. The Z-vector
% defines the plotting range across the thickness of each layer, and the X-
% vector is parallel to the interface of each layer. 

% Chosen angle and frequency:
% plot_angle      = 19.99;    % [degrees]
plot_frequency  = 750000*2;  % [MHz]

%Define plotting vectors, note the range of Z compared with the thickness
% of the aluminium plate:
sample_points = 128;
Z = linspace(-1.16e-3, 0.7e-3, sample_points); % [m]
X = linspace(-1.5e-3, 2.2e-3, sample_points); % [m]


for angles = -20:1:20
k = 2*pi*plot_frequency ./ 1500;
kx = k * sin(angles * pi /180) ;

output_field = my_model.calculateField( ...
    plot_frequency, kx, {Z, X});


figure(1)
imagesc( real(output_field.z_displacement))
pause(0.5)

disp(output_field)
end


% To plot the normal and transverse displacement along the line x=0 z=Z_hf:
fig_hand = my_model.plotField(output_field, 'displacement2D');

