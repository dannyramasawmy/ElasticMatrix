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
%
%% ========================================================================
%   REFLECTION COEFFICIENT FROM 2 - LAYER MODEL VS ROSE SOLUTION
% =========================================================================
cls
%% ========================================================================
%   MODEL
% =========================================================================

angle_range = linspace(0,89,500);
% 
% % sound speeds and density of medium
% % Medium 1
% rho_1 = 2700;   % 2700
% c_1L = 6250;    % 6350
% c_1T = 3100;    % 3100
% % Medium 2
% rho_2 = 1180;   % 1180
% c_2L = 2670;    % 2670
% c_2T = 1120;    % 1120


% % sound speeds and density of medium
% Medium 2
rho_2 = 2700;   % 2700
c_2L = 6250;    % 6350
c_2T = 3100;    % 3100
% Medium 1
rho_1 = 1180;   % 1180
c_1L = 2670;    % 2670
c_1T = 1120;    % 1120

% Sound Speed of the incident wave 
c_N = c_1L;



for idx = 1:length(angle_range)
    
    % incidence angle
    incidence_angle = angle_range(idx) * pi /180;
    omega = 2 * pi * 1e6;
    
    
    % angle of incidence/ reflectoin
    alpha_L = asin( sin(incidence_angle) * c_1L / c_N );
    alpha_T = asin( sin(incidence_angle) * c_1T / c_N );
    
    beta_L = asin( sin(incidence_angle) * c_2L / c_N );
    beta_T = asin( sin(incidence_angle) * c_2T / c_N );
    
    % define wavenumbers
    k_x = (omega / c_N) * sin(incidence_angle);
    
    k_1L = (omega / c_1L) ;% sqrt((omega / c_1L)^2 - k_x^2);
    k_2L = (omega / c_2L) ;%sqrt((omega / c_2L)^2 - k_x^2);
    
    k_1T = (omega / c_1T) ;%sqrt((omega / c_1T)^2 - k_x^2);
    k_2T = (omega / c_2T) ;% sqrt((omega / c_2T)^2 - k_x^2);
    
    % defin lame parameters
    mu_1        = rho_1 * (c_1T^2);
    lambda_1    = rho_1 * (c_1L^2) - 2*mu_1;
    
    mu_2        = rho_2 * (c_2T^2);
    lambda_2    = rho_2 * (c_2L^2) - 2*mu_2;
    
    factor_1 = k_1L * (lambda_1 + 2*mu_1);
    factor_2 = k_2L * (lambda_2 + 2*mu_2);
    
    % input vector
    a_L = [...
        -cos(alpha_L);
         sin(alpha_L);
         factor_1 * cos(2*alpha_T);
        -k_1L * mu_1 * sin(2 * alpha_L)];
    
    % system matrix
    M = [...
        -cos(alpha_L)               ,  sin(alpha_T)                 , -cos(beta_L)              , sin(beta_T);
        -sin(alpha_L)               , -cos(alpha_T)                 , sin(beta_L)               , cos(beta_T);
        -factor_1 * cos(2*alpha_T)  ,  k_1T * mu_1 * sin(2*alpha_T) , factor_2 * cos(2*beta_T)  , -k_2T * mu_2 * sin(2*beta_T);
        -k_1L*mu_1*sin(2*alpha_L)   , -k_1T*mu_1*cos(2*alpha_T)     , -k_2L*mu_2*sin(2*beta_L)  , -k_2T * mu_2 * cos(2 * beta_T)];
    
    % Solve with inverse
    output_amps = M \ a_L;
    RL(idx) = output_amps(1);
    RT(idx) = output_amps(2);
    SL(idx) = output_amps(3);
    ST(idx) = output_amps(4);
    
    
end

% plotting
figure(1)
hold on
plot(angle_range, (             abs(RL)), 'b')
plot(angle_range, (c_1T/c_1L *  abs(RT)), 'c')
plot(angle_range, (c_2L/c_1L *  abs(SL)), 'r')
plot(angle_range, (c_2T/c_1L *  abs(ST)), 'm')
hold off
title('corrected')
ylim([0 2])
legend('RL','RT','SL','ST')


% figure(3)
% % hold on
% % 
% % plot(angle_range, (  abs(RL)), 'b')
% % plot(angle_range, (  abs(RT)), 'c')
% % plot(angle_range, (  abs(SL)), 'r')
% % plot(angle_range, (  abs(ST)), 'm')
% hold off
% title('book')
% ylim([0 2])
% legend('RL','RT','SL','ST')

%% ========================================================================
%   PARTIAL WAVE MODEL
% =========================================================================
% generate blank medium
medium = Medium.generateLayeredMedium(...
    'blank',0,'blank',1);




rho_2 = 2700;   % 2700
c_2L = 6250;    % 6350
c_2T = 3100;    % 3100
% Medium 1
rho_1 = 1180;   % 1180
c_1L = 2670;    % 2670
c_1T = 1120;    % 1120

medium.setDensity([1 2], [rho_1, rho_2]);

c_mat_1 = medium.soundSpeedDensityConversion(c_1L, c_1T, rho_1);
c_mat_2 = medium.soundSpeedDensityConversion(c_2L, c_2T, rho_2);

medium.setCMatrix(1, c_mat_1);
medium.setCMatrix(2, c_mat_2);

medium.disp;

model = ElasticMatrix(medium);
model.setAngle(angle_range);
model.setFrequency([1e6]);
model.calculate;

pwa = model.partialWaveAmplitudes;

figure(1),
hold on
plot(angle_range, abs(pwa(1,:,2)),'b.') % comp R
plot(angle_range, abs(pwa(1,:,1)),'c.') % shear R
plot(angle_range, abs(pwa(1,:,4)),'r.') % comp T
plot(angle_range, abs(pwa(1,:,3)),'m.') % shear T
hold off

return

layer = generateMaterialStructure('blank',0,'blank',100e-6,'blank',1e-6,'blank',1);
sensor = SensorFP(layer);
sensor.freqs = 1e6;
sensor.angles = angle_range;
sensor.SetCompSpeed([1,2,3 4],[c_1L,c_1L, c_2L, c_2L ]);
sensor.SetShearSpeed([1 2 3 4], [c_1T, c_1T, c_2T, c_2T ]);
sensor.SetDensity([1 2 3 4], [rho_1, rho_1, rho_2, rho_2]);

sensor.CalcDir;
sensor.BulkWaveAmps;
mbw = sensor.myBulkWaveAmps;


figure(1),
hold on
plot(angle_range, abs(mbw(1,:,1)),'k--') % comp R
plot(angle_range, abs(mbw(1,:,2)),'k--') % shear R
plot(angle_range, abs(mbw(1,:,11)),'k--') % comp T
plot(angle_range, abs(mbw(1,:,12)),'k--') % shear T
hold off


% 
% pwa2 = model.temp;
% figure
% hold on
% plot(angle_range, abs(pwa2(1,:,2)),'b.') % comp R
% plot(angle_range, abs(pwa2(1,:,1)),'c.') % shear R
% plot(angle_range, abs(pwa2(1,:,4)),'r.') % comp T
% plot(angle_range, abs(pwa2(1,:,3)),'m.') % shear T
% hold off

%% Plot figure for journal
figure(2),
hold on
plot(angle_range, abs(pwa(1,:,2)),'k-') % comp R
plot(angle_range, abs(pwa(1,:,1)),'k-') % shear R
plot(angle_range, abs(pwa(1,:,4)),'k-') % comp T
plot(angle_range, abs(pwa(1,:,3)),'k-') % shear T
hold off
box on
xlabel('Angle [\circ]')
% ylabel('Magnitude')
legend('|R_L|','|R_S|','|T_L|','|T_S|')





