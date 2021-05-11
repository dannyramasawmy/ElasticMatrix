%% Angular spectrum 
%
% Angular spectrum method for an arbitrary ultrasound source scaled to
% adapt for ElasticMatrix examples.
% 
%   DIAGRAM
% 
%  ----------------------------------------------- x dim
%  |        ==========
%  |        source_length
%  |
%  |
%  |
%  |
% z dim

% =========================================================================
%   CLEAN AND PATHS
% =========================================================================
AddElasticMatrix;
% cls;
clear all

% =========================================================================
%   PARAMETERS
% =========================================================================

global verbose_display;
verbose_display = true;

% Field type
% G : Gaussian
% S : Square
% P : Point
field_type = 'G';
steering_angle = -27;       % [deg]

% Beam width
source_length = 3e-3;       % [m] "transducer width"
% x, z dimesions
xdim = 15e-3;               % [m]
zdim = 10e-3;               % [m]

% wavelength/medium properties
frequency = 3e6;            % [Hz]
omega = 2*pi*frequency;     % [rad/s]
sound_speed = 1480;         % [m/s]


% grid to sample output field over (i.e -> from ElasticMatrix)
samples = 256;
x_range = linspace(-xdim, xdim, samples);
z_range = linspace(0, zdim, samples/2);
[X, Z] = meshgrid(x_range, z_range);

% spatial coordinates
lambda = sound_speed / frequency;
upsampling = 10;
dx = lambda/upsampling;                 % [m] 
spatial_sampling = 1/dx;                % [1/m]

% pad dimension
pad_dim = 2^8;
pad_dim = 2^nextpow2(xdim*2/dx);


% wave vectors
k = omega/sound_speed;
pd2 = pad_dim/2;
k_x = 2*pi * spatial_sampling * ( ((-pd2)):(pd2-1) ) ...
    /pad_dim;
k_z = sqrt(k^2 - k_x.^2);


% =========================================================================
%   CREATE SOURCE
% =========================================================================
% First create source, then pad 
N = round(source_length/dx);

% incident field
zpad = zeros(1, (pad_dim-N));
switch field_type
    case 'G' % Gaussian
        source_x = linspace(-pi, pi, N);
        incident_field = normpdf(source_x); 
    case 'S' % Square
        source_x = linspace(0, source_length, N);
        incident_field = ones(size(source_x));
        incident_field([1:5, end-4:end]) = [0:0.2:0.8, 0.8:-0.2:0];
    case 'P' % point
        source_x = linspace(0, source_length, N);
        incident_field = normpdf(source_x, source_length/2, dx);
end

% add phase offset
phase_offeset = 2 * pi * frequency * (0:N-1)*dx * sind(steering_angle) ...
    / sound_speed;
incident_field = incident_field .* exp(1i .* phase_offeset);

% pad field
padded_incident_field = [incident_field, zpad];
x_incident_field = (0:pad_dim-1)*dx;

% =========================================================================
%   FFT / MANUAL DFT / PROPOGATE IN K SPACE
% =========================================================================

% get fourier coefficients
fourier_coeff = fftshift(fft(padded_incident_field));

% sum plane waves to create wave field
field = zeros(size(X));

for idx = 1:length(k_x) 
    % wave field
    field = field + fourier_coeff(idx) ...
        * exp(1i * (k_x(idx).*X + k_z(idx).*Z));    
end

% sum and normalise
field = field ./ pad_dim;

% propogate field in k-space
prop_field = fourier_coeff .*exp(1i.*k_z*max(z_range));
field_ifft = ifft(ifftshift(prop_field));


% =========================================================================
%   TRY WITH ELASTIC MATRIX
% =========================================================================
% 
% % Medium class:
% my_medium = Medium(...
%     'water', Inf,   'water', 5e-3, 'glass', 3e-3, 'glass', Inf);

my_medium = Medium(...
    'water', Inf,   'water', 4e-3, 'glass', 3e-3, 'water', Inf);

% 
% my_medium = Medium(...
%     'water', Inf,   'water', 5e-3, 'water', 3e-3, 'water', Inf);
% 

% Initialize an ElasticMatrix object:
my_model = ElasticMatrix(my_medium);

k = 2*pi*frequency ./ sound_speed;
kx = k * sin(5 * pi /180) ;

output_field = my_model.calculateField( ...
    frequency, kx, {z_range, x_range});

% initialise fields
field_em_sig_zz = zeros(size(output_field.sigma_zz));
field_em_sig_xz = zeros(size(output_field.sigma_xz));
field_em_disp_z = zeros(size(output_field.z_displacement));
field_em_disp_x = zeros(size(output_field.x_displacement));

for idx = 1:length(k_x) 
    % calculate field
    output_field = my_model.calculateField( ...
        frequency, k_x(idx),  {-z_range, x_range});

    % replace with a function that adds these things together, or create a
    % public class and override the + operator
    tmp_field_zz = (output_field.sigma_zz./...
        max(abs(output_field.sigma_zz(:))));
    tmp_field_xz = (output_field.sigma_xz./...
        max(abs(output_field.sigma_xz(:))));
    tmp_field_zz = (output_field.sigma_zz./...
        max(abs(output_field.sigma_zz(:))));
    tmp_field_xz = (output_field.sigma_xz./...
        max(abs(output_field.sigma_xz(:))));
    
    
    
%         tmp_field = (output_field.z_displacement);
    
    field_em_sig_zz = field_em_sig_zz + fourier_coeff(idx) ...
        *  tmp_field_zz;  

end

field_em_sig_zz = flipud(rot90((field_em_sig_zz))) / length(k_x);


%% =========================================================================
%   PLOTTING
% ==========================================================================

% PLOT FFT ===========================

figure(1);

% incident field and reconstructed field
subplot(3,1,1)
hold off
% input field
plot(x_incident_field, abs(padded_incident_field),'b-')
hold on
% manual fft
plot(x_range, abs(field(1,:)),'r--')
% elastic matrix
plot(x_range, (abs(field_em_sig_zz(1, :))), 'k.')
% labels
xlabel('X [m]')
title('Beam Profile')
legend('Inital Field', 'Manual iFFT', 'ElasticMatrix')
xlim([0 source_length])

% FFT spectrum
subplot(3,1,2)
plot(k_x, abs(fourier_coeff),'b')
xlabel('kx [rad/m]')
title('FFT')
hold on
plot(k_x, angle(fourier_coeff), 'r')
hold off
xlabel('kx [rad/m]')
legend('Amp', 'Phase')

% reconstrcuted plane at Z
subplot(3,1,3)
hold off
plot(x_incident_field, abs(field_ifft), 'b')
hold on
plot(x_range, abs(field(end,:)),'r--')
plot(x_range, abs(field_em_sig_zz(end,:)),'k.')
xlabel('X [m]')
legend('iFFT', 'Manual iFFT', 'ElasticMatrix')
title('Field at z = z_m_a_x')
xlim([0 source_length])



% PLOT FIELDS ===========================

figure(2)
% plot 2D field manual fft
subplot(3,1,1)
imagesc(x_range, z_range, abs(field))
% labels
xlabel('X [m]')
ylabel('Z [m]')
title('2D field')
axis image
colorbar

subplot(3,1,2)
imagesc(x_range, z_range, abs(field_em_sig_zz))
% labels
xlabel('X [m]')
ylabel('Z [m]')
title('2D field ElasticMatrix')
axis image
colorbar

% calculate error
difference_field =  100 * (((abs(field_em_sig_zz) -  abs(field))) ...
    ./ max(abs(field(:))));

subplot(3,1,3)
imagesc(x_range, z_range, abs(difference_field))
% labels
xlabel('X [m]')
ylabel('Z [m]')
title('% Error')
axis image
colorbar



% JUST ELASTIC MATRIX =============

figure(3)
subplot(2, 1, 1)
sgtitle('ElasticMatrix')
imagesc(x_range, z_range, abs(field_em_sig_zz))
axis image
title('Magnitude')

subplot(2, 1, 2)
imagesc(x_range, z_range, real(field_em_sig_zz))
axis image
title('Real')



% JUST SUM =================

figure(4)
subplot(2, 1, 1)
sgtitle('Manual Sum')
imagesc(x_range, z_range, abs(field))
axis image
title('Magnitude')

subplot(2, 1, 2)
imagesc(x_range, z_range, angle(field))
axis image
title('Phase')


