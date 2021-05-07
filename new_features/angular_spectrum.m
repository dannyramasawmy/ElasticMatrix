%% Angular spectrum 
%
% Angular spectrum method for an arbitrary ultrasound source scaled to
% adapt for ElasticMatrix examples.
% 
% Dimensions X,Z range from -2 to +2 mm
% Frequency 1-5 MHz
% Different beam profiles, Gaussian, Rectangular, Point


clear all

% =========================================================================
%   PARAMETERS
% =========================================================================

% Field type
% G : Gaussian
% S : Square
% P : Point
field_type = 'S';

% Beam width
width = 5e-3;
% x, z dimesions
xdim = 10e-3;
zdim = 10e-3;

% wavelength/medium properties
frequency = 750000;
omega = 2*pi*frequency;
sound_speed = 1500;


% grid to sample output field over (i.e -> from ElasticMatrix)
samples = 256;
x_range = linspace(-xdim/2, xdim/2, samples);
z_range = linspace(0, zdim, samples/2);
[X, Z] = meshgrid(x_range, z_range);

% pad dimension
pad_dimension = 2^8;

% spatial coordinates
lambda = sound_speed / frequency;
dx = lambda/10;                   % [m]
spatial_sampling = 1/dx;    % [1/m]

% wave vectors
k = omega/sound_speed;
k_x = 2*pi * spatial_sampling...
    *(((-pad_dimension/2)):(pad_dimension/2)-1) ...
    /pad_dimension;
k_z = sqrt(k^2 - k_x.^2);



% switch 
x = linspace(-xdim, xdim, round(width/dx));
N = length(x);

% =========================================================================
%   CREATE SOURCE
% =========================================================================

% incident field
zpad = zeros(1, (pad_dimension-N));
switch field_type
    case 'G' % Gaussian
        incident_field = normpdf(x, 0, 1 ); 
    case 'S' % Square
        incident_field = ones(size(x));
%         incident_field(25:75) = 1;
        incident_field([1:5, end-4:end]) = [0:0.2:0.8, 0.8:-0.2:0];
    case 'P' % point
        incident_field = normpdf(x, 0,  dx);
end
padded_incident_field = [incident_field, zpad];

%==========================================================================
%   PLOTTING
%==========================================================================

% get fourier coefficients
fourier_coeff = fftshift(fft(padded_incident_field));



% sum plane waves to create wave field
field = zeros(size(X));

for idx = 1:length(k_x) 
    % wave field
    field = field + fourier_coeff(idx) ...
        * exp(1i * (k_x(idx).*X + k_z(idx).*Z));    
   
%     figure(3),
%     imagesc(real(exp(1i * (k_x(idx).*X + k_z(idx).*Z)))),
%     colorbar
end

% sum and normalise
field = field ./ pad_dimension;

% propogate field in k-space
prop_field = fourier_coeff .*exp(1i.*k_z*max(z_range));
field_ifft = ifft(ifftshift(prop_field));


% =========================================================================
%   TRY WITH ELASTIC MATRIX
% =========================================================================

% Medium class:
my_medium = Medium(...
    'water', Inf, 'glass', 0.001, 'water', Inf);

% Initialize an ElasticMatrix object:
my_model = ElasticMatrix(my_medium);

k = 2*pi*frequency ./ sound_speed;
kx = k * sin(5 * pi /180) ;

output_field = my_model.calculateField( ...
    frequency, kx, {z_range, x_range});

field_em = zeros(size(output_field.z_displacement));
for idx = 1:length(k_x) 
    % wave fiel
    disp(k_x(idx))
    
    output_field = my_model.calculateField( ...
        frequency, k_x(idx),  {z_range, x_range});

    field_em = field_em + fourier_coeff(idx) ...
        * (output_field.z_displacement./...
        max(abs(output_field.z_displacement(:)))) ;  
    
    figure(2), 
    imagesc(real(output_field.z_displacement) ./...
        max(abs(output_field.z_displacement(:))) ),
%     colorbar
end

figure(2), 
imagesc(abs(rot90((field_em)))),
axis xy
%==========================================================================
%   PLOTTING
%==========================================================================

% plot incident field
figure(1);

% incident field and reconstructed field
subplot(2,2,1)
hold off
plot(x, abs(incident_field),'b-')
hold on
plot(x_range-width, abs(field(1,:)),'r--')
xlabel('X [m]')
title('Beam Profile')
legend('Inital Field', 'Manual iFFT')

% FFT spectrum
subplot(2,2,2)
plot(k_x, abs(fourier_coeff),'b')
xlabel('kx [rad/m]')
title('FFT')
hold on
plot(k_x, angle(fourier_coeff), 'r')
hold off
xlabel('kx [rad/m]')
legend('Amp', 'Phase')

% reconstrcuted plane at Z
subplot(2,2,3)
hold off
plot(x_range-width, abs(field(end,:)),'r-')
hold on
plot((0:dx:(dx*(pad_dimension-1)))-width, abs(field_ifft), 'k.')
xlabel('X [m]')
legend('Manual iFFT', 'iFFT')
title('Field at z=10')
xlim([-5 5])

subplot(2,2,4)
imagesc(x_range-width, z_range, abs(field))
% caxis([-1 1])
xlabel('X [m]')
ylabel('Z [m]')
title('2D field')
% caxis([-1 1])



