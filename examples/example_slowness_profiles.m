%% example_slowness_profiles
%
% Author    :   Danny Ramasawmy
%               rmapdrr@ucl.ac.uk
%               dannyramasawmy@gmail.com
% Date      :   2019-01-25  -   created
%
%   This script will demonstrate how to calculate slowness profiles using
%   the Medium class. Please refer to the example_medium_class.m script if
%   unfamilar with the class attibutes and methods.

% =========================================================================
%   PLOT SLOWNESS CURVES
% =========================================================================
% firstly create a Medium object with each material needed to generate a
% plot. Here the slowness profiles of water, glass and beryl will be
% generated
myMedium = Medium.generateLayeredMedium('water',Inf,'glass',0.001,'beryl2',Inf);

% calculate the slowness profiles
myMedium.calculateSlowness;

% the slowness profiles can be plotted, since these are symmetric about the
% axes, the are only plotted for a single quadrant
myMedium.plotSlowness;


% =========================================================================
%   MANUAL PLOTTING
% =========================================================================
% to manually plot the curves, the kx vs kz data is given in a structure
% form.

% slowness data for the first material
slownessDataMat_1 = myMedium(1).slowness;

% slowness data for the second material
slownessDataMat_2 = myMedium(2).slowness;

% slowness data for the third material
slownessDataMat_3 = myMedium(3).slowness;

% The .calcualteSlowness function will return complex values under certain
% conditions. Therefore only the real part should be plotted. 
% Additionally these may be positive or negative kz -> these are symmetric
% however

figure;

% plot the (q)-L component (kz_qL1)
plot( real(slownessDataMat_2.kx), abs(real(slownessDataMat_2.kz_qL1)) ,'k' )
hold on
% plot the (q)-SV component (kzt_qSV1)
plot( real(slownessDataMat_2.kx), abs(real(slownessDataMat_2.kz_qSV1)) ,'b' )

% plot the (q)-SH component (kz_qSH)
plot( real(slownessDataMat_2.kx), abs(real(slownessDataMat_2.kz_qSH)), 'r--')
hold off
% labels
axis equal
xlabel('k_x /\omega')
ylabel('k_z /\omega')
legend('L','SV','SH')
title('Manual slowness plot')


% =========================================================================
%   CALCULATE ERRORS
% =========================================================================
disp('Errors are within numerical precision : ')

% note the compressional speed of glass is 1/L curve
cLGlass = 5570; % see materialList
cLGlassSlowness = 1/ sqrt(real(slownessDataMat_2.kx(2)).^2 + real(slownessDataMat_2.kz_qL1(2)).^2);
differenceErrorCL = abs((cLGlass - cLGlassSlowness)/5570);

% note the shear (vertical) speed of glass is 1/SV curve
cSGlass = 3430; % see materialList
cSGlassSlowness = 1/ sqrt(real(slownessDataMat_2.kx(2)).^2 + real(slownessDataMat_2.kz_qSV1(2)).^2);
differenceErrorCSV = abs((cSGlass - cSGlassSlowness)/3430);

% note the shear (horizontal) speed of glass is 1/SH = 1/SV curve
cSGlassSlowness = 1/ sqrt(real(slownessDataMat_2.kx(2)).^2 + real(slownessDataMat_2.kz_qSH(2)).^2);
differenceErrorCSH = abs((cSGlass - cSGlassSlowness)/3430);

disp(['Error in cL   :', num2str(differenceErrorCL) ])
disp(['Error in cSV  :', num2str(differenceErrorCSV)])
disp(['Error in cSH  :', num2str(differenceErrorCSH)])













