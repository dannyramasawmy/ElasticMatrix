%%
%
%

% AddKwave;
clear all

% pad dimension
pad_dimension = 2^9;

% spatial coordinates
dx = 0.1;                   % [m]
spatial_sampling = 1/dx;    % [1/m]

% switch 
width = 5;
x = -5:dx:5; % [m]
N = length(x);

% incident field
zpad = zeros(1, (pad_dimension-N));
field_type = 'G';
switch field_type
    case 'G' % Gaussian
        incident_field = normpdf(x, 0,  1); 
    case 'S' % Square
        incident_field = zeros(size(x));
        incident_field(25:75) = 1;
%         incident_field([1:5, end-4:end]) = [0:0.2:0.8, 0.8:-0.2:0];
    case 'P' % point
        incident_field = normpdf(x, 0,  dx);
end
padded_incident_field = [incident_field, zpad];
padded_incident_field = padded_incident_field .* exp(1i *...
linspace(-10*pi, 10*pi, length(padded_incident_field)));

%==========================================================================
%   PLOTTING
%==========================================================================

% get fourier coefficients
fourier_coeff = fftshift(fft(padded_incident_field));

% wavelength/medium properties
frequency = 1;
omega = 2*pi*frequency;
sound_speed = 1;

k = omega/sound_speed;
k_x = 2*pi * spatial_sampling...
    *(((-pad_dimension/2)):(pad_dimension/2)-1) ...
    /pad_dimension;
k_z = sqrt(k^2 - k_x.^2);

% grid to sample output field over (i.e -> from ElasticMatrix)
samples = 256;
x_range = linspace(-5+width, 5+width, samples);
z_range = linspace(0,10, samples/2);
[X, Z] = meshgrid( x_range, z_range);

% sum plane waves to create wave field
field = zeros(size(X));

for idx = 1:length(k_x) 
    % wave field
    field = field + fourier_coeff(idx) ...
        * exp(1i * (k_x(idx).*X + k_z(idx).*Z));    
end

% sum and normalise
field = field ./ pad_dimension;

% propogate field in k-space
prop_field = fourier_coeff .*exp(1i.*k_z*max(z_range));
field_ifft = ifft(ifftshift(prop_field));

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
imagesc(x_range-width, z_range, real(field))
% caxis([-1 1])
xlabel('X [m]')
ylabel('Z [m]')
title('2D field')
% caxis([-1 1])



