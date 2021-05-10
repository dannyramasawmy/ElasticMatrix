%% Angular spectrum 
%
% Angular spectrum method for an arbitrary ultrasound source scaled to
% adapt for ElasticMatrix examples.
% 
% 
%


clear all

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
%   PARAMETERS
% =========================================================================

% Field type
% G : Gaussian
% S : Square
% P : Point
field_type = 'G';
steering_angle = -27;       % [deg]

% Beam width
source_length = 3e-3;       % [m]
% x, z dimesions
xdim = 20e-3;               % [m]
zdim = 20e-3;               % [m]

% wavelength/medium properties
frequency = 3e6;            % [Hz]
omega = 2*pi*frequency;     % [rad/s]
sound_speed = 1500;         % [m/s]


% grid to sample output field over (i.e -> from ElasticMatrix)
samples = 128;
x_range = linspace(-xdim, xdim, samples);
z_range = linspace(0, zdim, samples/2);
[X, Z] = meshgrid(x_range, z_range);

% pad dimension
pad_dim = 2^10;

% spatial coordinates
lambda = sound_speed / frequency;
upsampling = 10;
dx = lambda/upsampling;                 % [m] 
spatial_sampling = 1/dx;                % [1/m]

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

source_x = linspace(-xdim, xdim, round(source_length/dx));
N = length(source_x);

% incident field
zpad = zeros(1, (pad_dim-N));
switch field_type
    case 'G' % Gaussian
        incident_field = normpdf(source_x, 0, 1 ); 
    case 'S' % Square
        incident_field = ones(size(source_x));
        incident_field([1:5, end-4:end]) = [0:0.2:0.8, 0.8:-0.2:0];
    case 'P' % point
        incident_field = normpdf(source_x, 0,  dx);
end

% add phase offset
phase_offeset = 2 * pi * frequency * (0:N-1)*dx * sind(steering_angle) ...
    / sound_speed;
incident_field = incident_field .* exp(1i .* phase_offeset);

% pad field
padded_incident_field = [incident_field, zpad];

%==========================================================================
%   PLOTTING
%==========================================================================

% get fourier coefficients
fourier_coeff = fftshift(fft(padded_incident_field));
fourier_coeff_cnj = fftshift(fft(conj(padded_incident_field)));


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

% Medium class:
my_medium = Medium(...
    'water', Inf,   'water', 7e-3, 'water', 3e-3, 'glass', Inf);

% Initialize an ElasticMatrix object:
my_model = ElasticMatrix(my_medium);

k = 2*pi*frequency ./ sound_speed;
kx = k * sin(5 * pi /180) ;

output_field = my_model.calculateField( ...
    frequency, kx, {z_range, x_range});

field_em = zeros(size(output_field.sigma_zz));

%%%
%%% X FIELD !!!
parfor idx = 1:length(k_x) 
%     if k_x == 0
%         continue
%     end
    % wave fiel
    disp(k_x(idx))
    
    output_field = my_model.calculateField( ...
        frequency, k_x(idx),  {-z_range, x_range});
% 
    tmp_field = (output_field.sigma_zz./...
        max(abs(output_field.sigma_zz(:))));
    
%         tmp_field = (output_field.z_displacement);
    
    field_em = field_em + fourier_coeff(idx) ...
        *  tmp_field;  
%     
%     figure(2), 
%     imagesc(real(tmp_field))
%     colorbar
end

%%
abs_field_em = (rot90((field_em))) / length(k_x);

figure(2), 
imagesc(abs(abs_field_em)),
axis xy


%==========================================================================
%   PLOTTING
%==========================================================================

% plot incident field
figure(1);

% incident field and reconstructed field
subplot(2,2,1)
hold off
plot(source_x, abs(incident_field),'b-')
hold on
plot(x_range-source_length, abs(field(1,:)),'r--')
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
plot(x_range-source_length, abs(field(end,:)),'r-')
hold on
plot((0:dx:(dx*(pad_dim-1)))-source_length, abs(field_ifft), 'k.')
xlabel('X [m]')
legend('Manual iFFT', 'iFFT')
title('Field at z=10')
xlim([-5 5])

subplot(2,2,4)
imagesc(x_range-source_length, z_range, abs(field))
% caxis([-1 1])
xlabel('X [m]')
ylabel('Z [m]')
title('2D field')
% caxis([-1 1])

figure(4)
subplot(1, 3, 1)
imagesc(100*(abs(field)-abs(flipud(abs_field_em)))./ max(abs(field(:))))

subplot(1, 3, 2)
imagesc(abs(field))

subplot(1, 3, 3)
sgtitle('Water-Glass ')
imagesc(x_range, -z_range, abs(flipud(abs_field_em)))
axis xy
title('Mag')

figure(5)
subplot(1, 2, 1)
sgtitle('Water-Glass ')
imagesc(x_range, -z_range, abs(flipud(abs_field_em)))
axis xy image
title('Mag')

subplot(1, 2, 2)
imagesc(x_range, -z_range, real(flipud(abs_field_em)))
axis xy image
title('Real')


