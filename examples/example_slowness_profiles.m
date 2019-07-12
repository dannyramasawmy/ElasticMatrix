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
cls; % clears variables and closes figures
% firstly create a Medium object with each material needed to generate a
% plot. Here the slowness profiles of water, glass and beryl will be
% generated
myMedium = Medium('water',Inf,'glass',0.001,'beryl2',0.001,'CubicInAs0',Inf);


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
disp('Errors for glass are within numerical precision : ')

% note the compressional speed of glass is 1/L curve
cLGlass = 5570; % see materialList
cLGlassSlowness = 1/ sqrt(real(slownessDataMat_2.kx(1)).^2 + real(slownessDataMat_2.kz_qL1(1)).^2);
differenceErrorCL = abs((cLGlass - cLGlassSlowness)/5570);

% note the shear (vertical) speed of glass is 1/SV curve
cSGlass = 3430; % see materialList
cSGlassSlowness = 1/ sqrt(real(slownessDataMat_2.kx(1)).^2 + real(slownessDataMat_2.kz_qSV1(1)).^2);
differenceErrorCSV = abs((cSGlass - cSGlassSlowness)/3430);

% note the shear (horizontal) speed of glass is 1/SH = 1/SV curve
cSGlassSlowness = 1/ sqrt(real(slownessDataMat_2.kx(1)).^2 + real(slownessDataMat_2.kz_qSH(1)).^2);
differenceErrorCSH = abs((cSGlass - cSGlassSlowness)/3430);

disp(['Error in cL   :', num2str(differenceErrorCL) ])
disp(['Error in cSV  :', num2str(differenceErrorCSV)])
disp(['Error in cSH  :', num2str(differenceErrorCSH)])


disp(['Errors for beryl are within numerical precision,'...
    ' however, the profile is not calculated exactly when  kz=0:,'...
    ' this has been indicated with an *.'])
% get the stiffness matrix for beryl
stiffnessMatrixBeryl = myMedium(3).stiffnessMatrix;
densityBeryl = myMedium(3).density;

% compare qL at kx = 0
diffErrorqLkx0 = (sqrt(densityBeryl/ stiffnessMatrixBeryl(3,3)) -...
    abs(myMedium(3).slowness.kz_qL1(1))) / sqrt(densityBeryl/ stiffnessMatrixBeryl(3,3));

% compare qL at kz = 0
[idx] = find(real(myMedium(3).slowness.kz_qL1) == 0);
diffErrorqLkz0 = (myMedium(3).slowness.kx(idx(1)) - ...
    sqrt(densityBeryl/ stiffnessMatrixBeryl(1,1))) / sqrt(densityBeryl/ stiffnessMatrixBeryl(1,1)) ;

% compare qSV at kx = 0
diffErrorqSVkx0 = (sqrt(densityBeryl/ stiffnessMatrixBeryl(5,5)) -...
    abs(myMedium(3).slowness.kz_qSV1(1))) / sqrt(densityBeryl/ stiffnessMatrixBeryl(5,5));

% compare qSV at kz = 0
[idx] = find(real(myMedium(3).slowness.kz_qSV1) == 0);
diffErrorqSVkz0 = (myMedium(3).slowness.kx(idx(1)) - ...
    sqrt(densityBeryl/ stiffnessMatrixBeryl(5,5))) / sqrt(densityBeryl/ stiffnessMatrixBeryl(5,5)) ;


disp(['Error in qL  at kx = 0   :', num2str(diffErrorqLkx0) ])
disp(['Error in qL  at kz = 0 * :', num2str(diffErrorqLkz0)])
disp(['Error in qSV at kx = 0   :', num2str(diffErrorqSVkx0)])
disp(['Error in qSV at kz = 0 * :', num2str(diffErrorqSVkz0)])
















