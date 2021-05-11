%% example_plot_field_parameters_angular_spectrum
%
% A simple script to check if the wavefields can be plotted using f-K
% inputs.
cls;

% Medium class:
my_medium = Medium(...
    'water', Inf, 'water', 0.001, 'glass', Inf);

% Initialize an ElasticMatrix object:
my_model = ElasticMatrix(my_medium);

% Chosen frequency:
plot_frequency  = 750000*2;  % [MHz]

%Define plotting vectors, use odd cordinates to make it asymetrical:
sample_points = 128;
Z = linspace(-1.16e-3, 0.7e-3, sample_points); % [m]
X = linspace(-1.5e-3, 2.2e-3, sample_points); % [m]

% choose wavenumber
k = 2*pi*plot_frequency ./ 1500;
plot_angle = 35;
kx = k * sin(plot_angle * pi /180) ;

% use global flag to avoid uncessary printing
global verbose_display

verbose_display = false;
% get output field
output_field = my_model.calculateFieldKf( ...
    plot_frequency, kx, {Z, X});
verbose_display = true;

% plot the displacement field
fig_hand = my_model.plotField(output_field, 'displacement2D');

