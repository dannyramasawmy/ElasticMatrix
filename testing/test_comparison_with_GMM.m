%% example_comparison_with_GMM
%
% DESCRIPTION
%   example_comparison_with_GMM compares an implementation of the global
%   matrix model as described in (Lowe, 1995) with the partial wave
%   implementation.
%
%   As the GMM implementation has not been included with the toolbox, this
%   script loads the data for comparison. The GMM implementation will be
%   included in a future release of ElasticMatrix.
%   An arbitrary 4-layered medium has been chosen to test the four boundary
%   conditions hold at every interface.
%
%   There are three tests in this script: 
%   (1) Interface partial wave boundary conditions check (displacement and 
%       stress).
%   (2) Comparison of BC's between the GMM and PW models.
%   (3) Comparison of partial wave amplitudes between GMM and PW.
%
%   Note: there is excellent agreement between the two models and the
%   normalized error is (or very close to) machine precision. The error is
%   angle and frequency dependent. At some pairs of angle and frequency
%   the system matrix becomes singular and is ill conditioned, at these
%   points the error is larger.
%
% ABOUT
%   author          - Danny Ramasawmy
%   contact         - dannyramasawmy+elasticmatrix@gmail.com
%   date            - 25 - January  - 2019
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
%   INITALISE AND RUN PARTIAL WAVE MODEL
% =========================================================================
cls; % clear variables, close figures, clean command window
% path to toolbox functions
addpath('../src-pw/')

% initialize the medium class with four layers
medium = Medium('PET',Inf, 'aluminium',50e-6,'PMMA',20e-6,'glass',Inf);

% initialize the elastic matrix class
model = ElasticMatrix(medium);

% define frequency and angle vector
frequency_range = linspace(0.1e6, 50e6, 100);
angle_range = linspace(0, 89, 100);

% set calculation parameters
model.setFrequency( frequency_range );
model.setAngle( angle_range );
model.setFilename('testing_example');

% run partial wave model and calculate
model.calculate

% =========================================================================
%   TEST 1 : CHECK PARTIAL WAVE INTERFACE CONDITIONS
% =========================================================================
% The displacement and stress at the interface between layers can be
% calculated from the material field matrix in each layer above and below the
% interface. This part of the script checks that the boundary conditions at
% the interface are being matched.
%

figure(1);
% check for every interface
for idx = 1:length(medium) - 1
    
    % extract uz
    uzUp = model.z_displacement(idx).upper;
    uzDw = model.z_displacement(idx).lower;
    
    % extract ux
    uxUp = model.x_displacement(idx).upper;
    uxDw = model.x_displacement(idx).lower;
    
    % extract sigma_zz
    sigZZup = model.sigma_zz(idx).upper;
    sigZZdw = model.sigma_zz(idx).lower;
    
    % extract sigma_xz
    sigXZup = model.sigma_xz(idx).upper;
    sigXZdw = model.sigma_xz(idx).lower;
    
    % plot uz
    subplot(length(medium) - 1,4,4*(idx - 1) + 1 )
    tmp = normMe(abs(uzUp)) - normMe(abs(uzDw));
    imagesc(angle_range, frequency_range/1e6, tmp)
    % labels
    title(['uz error : ',num2str(mean(tmp(:)))])
    xlabel('Angle [\circ]')
    ylabel('Frequency [MHz]')
    colorbar
    axis square
    
    % plot ux
    subplot(length(medium) - 1,4,4*(idx - 1) + 2)
    tmp = normMe(abs(uxUp)) - normMe(abs(uxDw));
    imagesc(angle_range, frequency_range/1e6,  tmp)
    % labels
    title(['ux error : ',num2str(mean(tmp(:)))])
    xlabel('Angle [\circ]')
    ylabel('Frequency [MHz]')
    colorbar
    axis square
    
    % plot sigma zz
    subplot(length(medium) - 1,4,4*(idx - 1) + 3)
    tmp = normMe(abs(sigZZup)) - normMe(abs(sigZZdw));
    imagesc(angle_range, frequency_range/1e6, tmp)
    % labels
    title(['\sigma_z_z error ',num2str(mean(tmp(:)))])
    xlabel('Angle [\circ]')
    ylabel('Frequency [MHz]')
    colorbar
    axis square
    
    % plot sigma xz
    subplot(length(medium) - 1,4,4*(idx - 1) + 4)
    tmp = normMe(abs(sigXZup)) - normMe(abs(sigXZdw));
    imagesc(angle_range, frequency_range/1e6,tmp)
    % labels
    title(['\sigma_x_z error ',num2str(mean(tmp(:)))])
    xlabel('Angle [\circ]')
    ylabel('Frequency [MHz]')
    colorbar
    axis square
    
end

try
    sgtitle('Interface test partial-wave boundary conditions')
catch
end

% =========================================================================
%  LOAD GMM MODEL DATA
% =========================================================================
% the global matrix method has been implemented by the author but has not
% been included with the ElasticMatrix software. This will be in a future
% release. Here the data from the equivalent model is loaded and sorted

load('../testingData/gmmIsotropicModelData.mat')
% displacement
XDisplacements_1 = gmmIsotropicModelData.XDisplacements_1 ;
ZDisplacements_1 = gmmIsotropicModelData.ZDisplacements_1 ;
XDisplacements_2 = gmmIsotropicModelData.XDisplacements_2 ;
ZDisplacements_2 = gmmIsotropicModelData.ZDisplacements_2 ;
% stress
sigzz_2 = gmmIsotropicModelData.sigzz_2 ;
sigxz_2 = gmmIsotropicModelData.sigxz_2 ;
sigzz_1 = gmmIsotropicModelData.sigzz_1 ;
sigxz_1 = gmmIsotropicModelData.sigxz_1 ;
% bulk wave amplitudes
gmmMatrix = gmmIsotropicModelData.bulkWaveAmplitudes;

% sort data from GMM - ux displacement for three interfaces
gmm_ux_1 = sum(XDisplacements_1(:,:,[3 4]),3); % ux int 1
gmm_ux_2 = sum(XDisplacements_1(:,:,[1 2]),3); % ux int 2
gmm_ux_3 = sum(XDisplacements_2(:,:,[1 2]),3); % ux int 3

% sort data from GMM - uz displacement for three interfaces
gmm_uz_1 = sum(ZDisplacements_1(:,:,[3 4]),3); % uz int 1
gmm_uz_2 = sum(ZDisplacements_1(:,:,[1 2]),3); % uz int 2
gmm_uz_3 = sum(ZDisplacements_2(:,:,[1 2]),3); % uz int 3

% sort data from GMM - stress for three interfaces
gmm_szz_1 = sigzz_1(:,:,2); % normal stress interface 1
gmm_szz_2 = sigzz_1(:,:,1); % normal stress interface 2
gmm_szz_3 = sigzz_2(:,:,1); % normal stress interface 3

% sort data from GMM - shear stress for three interfaces
gmm_sxz_1 = sigxz_1(:,:,2); % shear stress interface 1
gmm_sxz_2 = sigxz_1(:,:,1); % shear stress interface 2
gmm_sxz_3 = sigxz_2(:,:,1); % shear stress interface 3

% ========================================================================
%   TEST 2 : INTERFACE CHECK GMM VS PARTIAL WAVE
% =========================================================================

figure(2);

% ux - 1
subplot(3,4,1)
plot(angle_range, normMe(abs(gmm_ux_1(25,:))),'b')
hold on
plot(angle_range, normMe(abs(model.x_displacement(1).lower(25,:))),'r.')
hold off
% errors
yyaxis right
error = normMe(abs(gmm_ux_1(25,:))) ...
    - normMe(abs(model.x_displacement(1).lower(25,:)));
plot(angle_range,error,'k')
% labels
ylabel('Error')
title('u_x - int 1')
xlabel('Angle [\circ]')
legend('GMM','Partial-wave','Error')

% ux - 2
subplot(3,4,5)
plot(angle_range,normMe(abs(gmm_ux_2(25,:))),'b')
hold on
plot(angle_range,normMe(abs(model.x_displacement(2).lower(25,:))),'r.')
hold off
% errors
yyaxis right
error = normMe(abs(gmm_ux_2(25,:))) ...
    - normMe(abs(model.x_displacement(2).lower(25,:)));
plot(angle_range,error,'k')
% labels
ylabel('Error')
title('u_x - int 2')
xlabel('Angle [\circ]')

% ux - 3
subplot(3,4,9)
plot(angle_range,normMe(abs(gmm_ux_3(25,:))),'b')
hold on
plot(angle_range,normMe(abs(model.x_displacement(3).lower(25,:))),'r.')
hold off
% errors
yyaxis right
error = normMe(abs(gmm_ux_3(25,:))) ...
    - normMe(abs(model.x_displacement(3).lower(25,:)));
plot(angle_range,error,'k')
% labels
ylabel('Error')
title('u_x - int 3')
xlabel('Angle [\circ]')

% uz - 1
subplot(3,4,2)
plot(angle_range,normMe(abs(gmm_uz_1(25,:))),'b')
hold on
plot(angle_range,normMe(abs(model.z_displacement(1).lower(25,:))),'r.')
hold off
% errors
yyaxis right
error = normMe(abs(gmm_uz_1(25,:))) ...
    - normMe(abs(model.z_displacement(1).lower(25,:)));
plot(angle_range,error,'k')
ylabel('Error')
title('u_z - int 1')
xlabel('Angle [\circ]')


% uz - 2
subplot(3,4,6)
plot(angle_range,normMe(abs(gmm_uz_2(25,:))),'b')
hold on
plot(angle_range,normMe(abs(model.z_displacement(2).lower(25,:))),'r.')
hold off
% errors
yyaxis right
error = normMe(abs(gmm_uz_2(25,:))) ...
    - normMe(abs(model.z_displacement(2).lower(25,:)));
plot(angle_range,error,'k')
% labels
ylabel('Error')
title('u_z - int 2')
xlabel('Angle [\circ]')

% uz - 3
subplot(3,4,10)
plot(angle_range,normMe(abs(gmm_uz_3(25,:))),'b')
hold on
plot(angle_range,normMe(abs(model.z_displacement(3).lower(25,:))),'r.')
hold off
% errors
yyaxis right
error = normMe(abs(gmm_uz_3(25,:))) ...
    - normMe(abs(model.z_displacement(3).lower(25,:)));
plot(angle_range,error,'k')
% labels
ylabel('Error')
title('u_z - int 3')
xlabel('Angle [\circ]')

% sigma zz - 1
subplot(3,4,3)
plot(angle_range,normMe(abs(gmm_szz_1(25,:))),'b')
hold on
plot(angle_range,normMe(abs(model.sigma_zz(1).lower(25,:))),'r.')
hold off
% errors
yyaxis right
error = normMe(abs(gmm_szz_1(25,:))) ...
    - normMe(abs(model.sigma_zz(1).lower(25,:)));
plot(angle_range,error,'k')
% labels
ylabel('Error')
title('\sigma_z_z - int 1')
xlabel('Angle [\circ]')

% sigma zz - 2
subplot(3,4,7)
plot(angle_range,normMe(abs(gmm_szz_2(25,:))),'b')
hold on
plot(angle_range,normMe(abs(model.sigma_zz(2).lower(25,:))),'r.')
hold off
% errors
yyaxis right
error = normMe(abs(gmm_szz_2(25,:))) ...
    - normMe(abs(model.sigma_zz(2).lower(25,:)));
plot(angle_range,error,'k')
% labels
ylabel('Error')
title('\sigma_z_z - int 2')
xlabel('Angle [\circ]')

% sigma zz - 3
subplot(3,4,11)
plot(angle_range,normMe(abs(gmm_szz_3(25,:))),'b')
hold on
plot(angle_range,normMe(abs(model.sigma_zz(3).lower(25,:))),'r.')
hold off
% errors
yyaxis right
error = normMe(abs(gmm_szz_3(25,:))) ...
    - normMe(abs(model.sigma_zz(3).lower(25,:)));
plot(angle_range,error,'k')
% labels
ylabel('Error')
title('\sigma_z_z - int 3')
xlabel('Angle [\circ]')

% sigma xz - 1
subplot(3,4,4)
plot(angle_range,normMe(abs(gmm_sxz_1(25,:))),'b')
hold on
plot(angle_range,normMe(abs(model.sigma_xz(1).lower(25,:))),'r.')
hold off
% errors
yyaxis right
error = normMe(abs(gmm_sxz_1(25,:))) ...
    - normMe(abs(model.sigma_xz(1).lower(25,:)));
plot(angle_range,error,'k')
% labels
ylabel('Error')
title('\sigma_x_z - int 1')
xlabel('Angle [\circ]')

% sigma xz - 2
subplot(3,4,8)
plot(angle_range,normMe(abs(gmm_sxz_2(25,:))),'b')
hold on
plot(angle_range,normMe(abs(model.sigma_xz(2).lower(25,:))),'r.')
hold off
% errors
yyaxis right
error = normMe(abs(gmm_sxz_2(25,:))) ...
    - normMe(abs(model.sigma_xz(2).lower(25,:)));
plot(angle_range,error,'k')
% labels
ylabel('Error')
title('\sigma_x_z - int 2')
xlabel('Angle [\circ]')

% sigma xz - 3
subplot(3,4,12)
plot(angle_range,normMe(abs(gmm_sxz_3(25,:))),'b')
hold on
plot(angle_range,normMe(abs(model.sigma_xz(3).lower(25,:))),'r.')
hold off
% errors
yyaxis right
error = normMe(abs(gmm_sxz_3(25,:))) ...
    - normMe(abs(model.sigma_xz(3).lower(25,:)));
plot(angle_range,error,'k')
% labels
ylabel('Error')
title('\sigma_x_z - int 3')
xlabel('Angle [\circ]')

try
    sgtitle('Interface check GMM vs PW at an arbitrary frequency')
catch
end

% =========================================================================
%   TEST 3 : PARTIAL WAVE AMPLITUDE COMPARISON
% =========================================================================
%   The partial wave amplitudes are directly related the reflection and
%   transmission coefficient, these are also produced by the GMM and are
%   compared here.

% get partial wave amplitudes from ElasticMatrix
pwMatrix = model.partial_wave_amplitudes;

figure(3);

% reflected comp;
subplot(3,4,1)
yyaxis left
plot(angle_range, abs(pwMatrix(25,:,2)),'r.')
hold on
plot(angle_range, abs(gmmMatrix(25,:,1)),'b')
% labels
ylabel('|R1 - comp|')
xlabel('Angle [\circ]')
% error
yyaxis right
plot(angle_range, normMe(abs(pwMatrix(25,:,2))) ...
    -  normMe(abs(gmmMatrix(25,:,1))),'k')
ylabel('Error')
legend('Partial-wave','GMM','error')

% reflected comp;
subplot(3,4,2)
yyaxis left
plot(angle_range, abs(pwMatrix(25,:,1)),'r.')
hold on
plot(angle_range, abs(gmmMatrix(25,:,2)),'b')
% labels
ylabel('|R1 - shear|')
xlabel('Angle [\circ]')
% error
yyaxis right
plot(angle_range, normMe(abs(pwMatrix(25,:,1))) ...
    -  normMe(abs(gmmMatrix(25,:,2))),'k')
ylabel('Error')

subplot(3,4,3)
yyaxis left
plot(angle_range, abs(pwMatrix(25,:,6)),'r.')
hold on
plot(angle_range, abs(gmmMatrix(25,:,3)),'b')
% labels
ylabel('|T1 - comp|')
xlabel('Angle [\circ]')
% error
yyaxis right
plot(angle_range, normMe(abs(pwMatrix(25,:,6))) ...
    -  normMe(abs(gmmMatrix(25,:,3))),'k')
ylabel('Error')

subplot(3,4,4)
yyaxis left
plot(angle_range, abs(pwMatrix(25,:,5)),'r.')
hold on
plot(angle_range, abs(gmmMatrix(25,:,4)),'b')
% labels
ylabel('|T1 - shear|')
xlabel('Angle [\circ]')
% error
yyaxis right
plot(angle_range, normMe(abs(pwMatrix(25,:,5))) ...
    -  normMe(abs(gmmMatrix(25,:,4))),'k')
ylabel('Error')

subplot(3,4,5)
yyaxis left
plot(abs(pwMatrix(25,:,4)),'r.')
hold on
plot(abs(gmmMatrix(25,:,5)),'b')
% labels
ylabel('|R2 - comp|')
xlabel('Angle [\circ]')
% error
yyaxis right
plot(angle_range, normMe(abs(pwMatrix(25,:,4))) ...
    -  normMe(abs(gmmMatrix(25,:,5))),'k')
ylabel('Error')

subplot(3,4,6)
yyaxis left
plot(angle_range, abs(pwMatrix(25,:,3)),'r.')
hold on
plot(angle_range, abs(gmmMatrix(25,:,6)),'b')
% labels
ylabel('|R2 - shear|')
xlabel('Angle [\circ]')
% error
yyaxis right
plot(angle_range, normMe(abs(pwMatrix(25,:,3))) ...
    -  normMe(abs(gmmMatrix(25,:,6))),'k')
ylabel('Error')

subplot(3,4,7)
yyaxis left
plot(angle_range, abs(pwMatrix(25,:,10)),'r.')
hold on
plot(angle_range, abs(gmmMatrix(25,:,7)),'b')
% labels
ylabel('|T2 - comp|')
xlabel('Angle [\circ]')
% error
yyaxis right
plot(angle_range, normMe(abs(pwMatrix(25,:,10))) ...
    -  normMe(abs(gmmMatrix(25,:,7))),'k')
ylabel('Error')


subplot(3,4,8)
yyaxis left
plot(angle_range, abs(pwMatrix(25,:,9)), 'r.')
hold on
plot(angle_range, abs(gmmMatrix(25,:,8)),'b')
% labels
ylabel('|T2 - shear|')
xlabel('Angle [\circ]')
% error
yyaxis right
plot(angle_range, normMe(abs(pwMatrix(25,:,9))) ...
    -  normMe(abs(gmmMatrix(25,:,8))),'k')
ylabel('Error')

subplot(3,4,9)
yyaxis left
plot(angle_range, abs(pwMatrix(25,:,8)), 'r.')
hold on
plot(angle_range, abs(gmmMatrix(25,:,9)),'b')
% labels
ylabel('|R3 - comp|')
xlabel('Angle [\circ]')
% error
yyaxis right
plot(angle_range, normMe(abs(pwMatrix(25,:,8))) ...
    -  normMe(abs(gmmMatrix(25,:,9))),'k')
ylabel('Error')

subplot(3,4,10)
yyaxis left
plot(angle_range, abs(pwMatrix(25,:,7)),'r.')
hold on
plot(angle_range, abs(gmmMatrix(25,:,10)),'b')
% labels
ylabel('|R3 - shear|')
xlabel('Angle [\circ]')
% error
yyaxis right
plot(angle_range, normMe(abs(pwMatrix(25,:,7))) ...
    -  normMe(abs(gmmMatrix(25,:,10))),'k')
ylabel('Error')

subplot(3,4,11)
yyaxis left
plot(angle_range, abs(pwMatrix(25,:,12)),'r.')
hold on
plot(angle_range, abs(gmmMatrix(25,:,11)),'b')
% labels
ylabel('|T3 - comp|')
xlabel('Angle [\circ]')
% error
yyaxis right
plot(angle_range, normMe(abs(pwMatrix(25,:,12))) ...
    -  normMe(abs(gmmMatrix(25,:,11))),'k')
ylabel('Error')

subplot(3,4,12)
yyaxis left
plot(angle_range, abs(pwMatrix(25,:,11)),'r.')
hold on
plot(angle_range, abs(gmmMatrix(25,:,12)),'b')
% labels
ylabel('|T3 - shear|')
xlabel('Angle [\circ]')
% error
yyaxis right
plot(angle_range, normMe(abs(pwMatrix(25,:,11))) ...
    -  normMe(abs(gmmMatrix(25,:,12))),'k')
ylabel('Error')

% super title
try
    
    sgtitle('Interface comparison for partial-wave and GMM wave amplitudes at an arbitrary frequency')
catch
end

% ========================================================================
%   COMMENTS
% =========================================================================
disp(['Note: there is excellent agreement between the two models and the ',...
    'normalized error is (or very close to) machine precision. The error is',...
    ' angle and frequency dependent. At some pairs of angle and frequency',...
    ' the system matrix becomes singular and is ill conditioned, at these',...
    ' points the error is larger.'])







