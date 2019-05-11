%% TestScript
%
% Author    :   Danny Ramasawmy
%               rmapdrr@ucl.ac.uk
%               dannyramasawmy@gmail.com
% Date      :   2019-01-25  -   created
%
%
% Description
%   This is a test script for the partial wave multilayer matrix code
%
% ERROR     :   d

%% ========================================================================
%   PLOT SLOWNESS PROFILES
% =========================================================================
addpath('./mat_funcs/')
cls
% ParCA

% ParCA  beryl CubicInAs0 CubicInAs45 parylene_C graphiteEpoxy

% generate a medium
medium = Medium.generateLayeredMedium('water',0,'graphiteEpoxy',10e-6);
N = 1000;
angle_vec = linspace(-90,90,N);

% precalculated factors
freq = 1e6;
phase_vel = 1000; sqrt(medium(1).cMat(1,1) / medium(1).density);

for angle_idx = 1:length(angle_vec)
    
    % basis of phase speed from first layer
    % angle and phase velocity
    angle = angle_vec(angle_idx);
    theta = angle * pi /180;
    
    cp = phase_vel / sin(theta);
    % frequency
    omega = 2* pi * 1e6;
    k = omega / cp ;
    
    % =============================================================
    %   MATERIAL PROPERTIES FOR EACH LAYER
    % =============================================================
    
    % loop over the medium layers and extract the important properties
    %   alpha - partial wave amplitudes
    %   C_mat - stiffness matrix for each material
    %   p_vec - polarisation of each partial wave
    for lay_dx = 1:length(medium)
        [ m_p(lay_dx).alpha, m_p(lay_dx).cMat, m_p(lay_dx).pVec, m_p(lay_dx).sh_coeff ] = ...
            calculateAlphaCoefficients(...
            medium(lay_dx).cMat, cp, medium(lay_dx).density );
    end

%     pvec(angle_idx) = omega / sqrt(k^2 + (k * m_p(2).alpha(4))^2);
    kz_1(angle_idx) = k * m_p(1).alpha(4) /omega;
    kz_2(angle_idx) = k * m_p(2).alpha(4) /omega;
    
    kz_2n(angle_idx) = k * m_p(2).alpha(3) /omega;
    
kzt_2(angle_idx) = k * m_p(2).alpha(2) /omega;
    kzt_2n(angle_idx) = k * m_p(2).alpha(1) /omega;
    
    ksht(angle_idx) = k * m_p(2).sh_coeff /omega;
%     
%     kz_3(angle_idx) = k * m_p(3).alpha(4) /omega;
%     kzt_3(angle_idx) = k * m_p(3).alpha(2) /omega;
    
    
    kx(angle_idx) = k /omega;
    
%     angle_to_plot(angle_idx) = real(m_p(2).alpha(2)); 
end



figure(1)
hold on
plot(kx, abs(kz_1),'k-')
plot(kx, -abs(kz_1),'k-')

plot(kx, abs(kz_2),'r-')
plot(kx, -abs(kz_2),'r-')

plot(kx, abs(kzt_2),'b.')
plot(kx, -abs(kzt_2),'b.')

plot(kx, abs(ksht), 'm--')
plot(kx, -abs(ksht), 'm--')
axis equal
hold off

xlim([-1e-3 1e-3])
ylim([-1e-3 1e-3])


figure(2)



hold on
plot(kx(1:N/2), real(kz_2(1:N/2)),'k-')
plot(kx(1:N/2), real(kzt_2(1:N/2)),'k-.')
plot(kx(1:N/2), real(ksht(1:N/2)), 'k--')

plot(kx(N/2+1:end), fliplr(real(kz_2(1:N/2))),'k-')
plot(kx(N/2+1:end), fliplr(real(kzt_2(1:N/2))),'k-.')
plot(kx(N/2+1:end), fliplr(real(ksht(1:N/2))), 'k--')

% plot(kx(1:N/2), real(kz_1(1:N/2)),'r-')
% plot(kx(N/2+1:end), fliplr(real(kz_1(1:N/2))),'r-')

% labels

axis equal
hold off
box on
title('Beryl')
xlabel('k_x / \omega')
ylabel('k_z / \omega')

% legend('L','SV','SH','L-water')

legend('qL','qSV','qSH')
xlim([-8e-4 8e-4])
ylim([1e-5 8e-4])



