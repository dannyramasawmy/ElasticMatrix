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
cls;
%% ========================================================================
%   PATHS AND CLEAN
% =========================================================================
addpath(genpath('../../code_v4_jan2017/src/'))
% addpath('mat_funcs')

% initialise the medium class
medium = Medium.generateLayeredMedium(...
    'PET',0, 'PVDF',50e-6,'PMMA',20e-6,'glass',1);

% display class
medium.disp;

% initialise the elastic matrix class
model = ElasticMatrix(medium);

% set calculation parameters
model.setFrequency(linspace(0.1e6  , 50e6  , 100));
model.setAngle(    linspace(0     , 89    , 100));
model.setFilename( 'testing_example'             );

model.calculate


model.calculateDirectivity([1 3]);
model.plotDirectivity;

% model.Calculate_Dispersion_Curves
% dd = model.dispersion_curves;
% hold on
% plot(dd(:,2), dd(:,1)/1e6,'.')

%% ========================================================================
%   CHECK PARTIAL WAVE INTERFACE CONDITIONS
% =========================================================================

figure;
% check for every interface
for idx = 1:length(medium) - 1
    
    % extract uz
    uzUp = model.zDisplacement(idx).upper;
    uzDw = model.zDisplacement(idx).lower;
    
    % extract ux
    uxUp = model.xDisplacement(idx).upper;
    uxDw = model.xDisplacement(idx).lower;
    
    % extract sigma_zz
    sigZZup = model.sigmaZZ(idx).upper;
    sigZZdw = model.sigmaZZ(idx).lower;
    
    % extract sigma_xz
    sigXZup = model.sigmaXZ(idx).upper;
    sigXZdw = model.sigmaXZ(idx).lower;
    
    % plot uz
    subplot(length(medium) - 1,4,4*(idx - 1) + 1 )
    tmp = normMe(abs(uzUp)) - normMe(abs(uzDw));
    imagesc(tmp)
    title(['uz error : ',num2str(mean(tmp(:)))])
    
    % plot ux
    subplot(length(medium) - 1,4,4*(idx - 1) + 2)
    tmp = normMe(abs(uxUp)) - normMe(abs(uxDw));
    imagesc(tmp)
    title(['ux error : ',num2str(mean(tmp(:)))])
    
    % plot sigma zz
    subplot(length(medium) - 1,4,4*(idx - 1) + 3)
    tmp = normMe(abs(sigZZup)) - normMe(abs(sigZZdw));
    imagesc(tmp)
    title(['\sigma_z_z error ',num2str(mean(tmp(:)))])
    
    % plot sigma xz
    subplot(length(medium) - 1,4,4*(idx - 1) + 4)
    tmp = normMe(abs(sigXZup)) - normMe(abs(sigXZdw));
    imagesc(tmp)
    title(['\sigma_x_z error ',num2str(mean(tmp(:)))])
    
end

%% ========================================================================
%   COMPARISON WITH SENSORFP
% =========================================================================

layer = generateMaterialStructure(...
    'PET',0, 'PVDF',50e-6,'PMMA',20e-6,'glass',1);

% initalise class with relevant frequencies and angles
fpsen = SensorFP(layer);
fpsen.angles = model.angle;
fpsen.freqs = model.frequency;

% choose where to extract mirror locations
fpsen.dispMirLayer = [2 2];
fpsen.CalcDisplacement;

% get the X, Z displacements
XDisplacements_1 = fpsen.myXDisplacements;
ZDisplacements_1 = fpsen.myZDisplacements;

% get the stresses
sigzz_1 = fpsen.mySigmaZZ;
sigxz_1 = fpsen.mySigmaXZ;

% mirror locations (just a limitation of how it is implemented)
fpsen.dispMirLayer = [3 3];
fpsen.CalcDisplacement;

% get the X, Z displacements
XDisplacements_2 = fpsen.myXDisplacements;
ZDisplacements_2 = fpsen.myZDisplacements;

% get the stresses
sigzz_2 = fpsen.mySigmaZZ;
sigxz_2 = fpsen.mySigmaXZ;

%% ========================================================================
%   INTERFACE COMPARISON
% =========================================================================

fp_ux_1 = sum(XDisplacements_1(:,:,[3 4]),3); % ux int 1
fp_ux_2 = sum(XDisplacements_1(:,:,[1 2]),3); % ux int 2
fp_ux_3 = sum(XDisplacements_2(:,:,[1 2]),3); % ux int 3

fp_uz_1 = sum(ZDisplacements_1(:,:,[3 4]),3); % uz int 1
fp_uz_2 = sum(ZDisplacements_1(:,:,[1 2]),3); % uz int 2
fp_uz_3 = sum(ZDisplacements_2(:,:,[1 2]),3); % uz int 3

fp_szz_1 = sigzz_1(:,:,2); % normal stress interface 1
fp_szz_2 = sigzz_1(:,:,1); % normal stress interface 2
fp_szz_3 = sigzz_2(:,:,1); % normal stress interface 3

fp_sxz_1 = sigxz_1(:,:,2); % shear stress interface 1
fp_sxz_2 = sigxz_1(:,:,1); % shear stress interface 2
fp_sxz_3 = sigxz_2(:,:,1); % shear stress interface 3

% copy angles for plotting
ang = model.angle;

%% ========================================================================
%   PLOTTING ABS
% =========================================================================

figure;

% ux - 1
subplot(3,4,1)
plot(ang,normMe(abs(fp_ux_1(25,:))))
hold on
plot(ang,normMe(abs(model.xDisplacement(1).lower(25,:))),'.')
hold off
% errors
yyaxis right
error = normMe(abs(fp_ux_1(25,:))) - normMe(abs(model.xDisplacement(1).lower(25,:)));
plot(ang,error,'k')
ylabel('Error')
title('u_x - 1')

% ux - 2
subplot(3,4,5)
plot(ang,normMe(abs(fp_ux_2(25,:))))
hold on
plot(ang,normMe(abs(model.xDisplacement(2).lower(25,:))),'.')
hold off
% errors
yyaxis right
error = normMe(abs(fp_ux_2(25,:))) - normMe(abs(model.xDisplacement(2).lower(25,:)));
plot(ang,error,'k')
ylabel('Error')
title('u_x - 2')

% ux - 3
subplot(3,4,9)
plot(ang,normMe(abs(fp_ux_3(25,:))))
hold on
plot(ang,normMe(abs(model.xDisplacement(3).lower(25,:))),'.')
hold off
% errors
yyaxis right
error = normMe(abs(fp_ux_3(25,:))) - normMe(abs(model.xDisplacement(3).lower(25,:)));
plot(ang,error,'k')
ylabel('Error')
title('u_x - 3')

% uz - 1
subplot(3,4,2)
plot(ang,normMe(abs(fp_uz_1(25,:))))
hold on
plot(ang,normMe(abs(model.zDisplacement(1).lower(25,:))),'.')
hold off
% errors
yyaxis right
error = normMe(abs(fp_uz_1(25,:))) - normMe(abs(model.zDisplacement(1).lower(25,:)));
plot(ang,error,'k')
ylabel('Error')
title('u_z - 1')

% uz - 2
subplot(3,4,6)
plot(ang,normMe(abs(fp_uz_2(25,:))))
hold on
plot(ang,normMe(abs(model.zDisplacement(2).lower(25,:))),'.')
hold off
% errors
yyaxis right
error = normMe(abs(fp_uz_2(25,:))) - normMe(abs(model.zDisplacement(2).lower(25,:)));
plot(ang,error,'k')
ylabel('Error')
title('u_z - 2')


% uz - 3
subplot(3,4,10)
plot(ang,normMe(abs(fp_uz_3(25,:))))
hold on
plot(ang,normMe(abs(model.zDisplacement(3).lower(25,:))),'.')
hold off
% errors
yyaxis right
error = normMe(abs(fp_uz_3(25,:))) - normMe(abs(model.zDisplacement(3).lower(25,:)));
plot(ang,error,'k')
ylabel('Error')
title('u_z - 3')

% sigma zz - 1
subplot(3,4,3)
plot(ang,normMe(abs(fp_szz_1(25,:))),'b')
hold on
plot(ang,normMe(abs(model.sigmaZZ(1).lower(25,:))),'r.')
hold off
% errors
yyaxis right
error = normMe(abs(fp_szz_1(25,:))) - normMe(abs(model.sigmaZZ(1).lower(25,:)));
plot(ang,error,'k')
title('\sigma_z_z - 1')

% sigma zz - 2
subplot(3,4,7)
plot(ang,normMe(abs(fp_szz_2(25,:))),'b')
hold on
plot(ang,normMe(abs(model.sigmaZZ(2).lower(25,:))),'r.')
hold off
% errors
yyaxis right
error = normMe(abs(fp_szz_2(25,:))) - normMe(abs(model.sigmaZZ(2).lower(25,:)));
plot(ang,error,'k')
title('\sigma_z_z - 2')

% sigma zz - 3
subplot(3,4,11)
plot(ang,normMe(abs(fp_szz_3(25,:))),'b')
hold on
plot(ang,normMe(abs(model.sigmaZZ(3).lower(25,:))),'r.')
hold off
% errors
yyaxis right
error = normMe(abs(fp_szz_3(25,:))) - normMe(abs(model.sigmaZZ(3).lower(25,:)));
plot(ang,error,'k')
title('\sigma_z_z - 3')

% sigma xz - 1
subplot(3,4,4)
plot(ang,normMe(abs(fp_sxz_1(25,:))),'b')
hold on
plot(ang,normMe(abs(model.sigmaXZ(1).lower(25,:))),'r.')
hold off
% errors
yyaxis right
error = normMe(abs(fp_sxz_1(25,:))) - normMe(abs(model.sigmaXZ(1).lower(25,:)));
plot(ang,error,'k')
title('\sigma_x_z - 1')

% sigma xz - 2
subplot(3,4,8)
plot(ang,normMe(abs(fp_sxz_2(25,:))),'b')
hold on
plot(ang,normMe(abs(model.sigmaXZ(2).lower(25,:))),'r.')
hold off
% errors
yyaxis right
error = normMe(abs(fp_sxz_2(25,:))) - normMe(abs(model.sigmaXZ(2).lower(25,:)));
plot(ang,error,'k')
title('\sigma_x_z - 2')

% sigma xz - 3
subplot(3,4,12)
plot(ang,normMe(abs(fp_sxz_3(25,:))),'b')
hold on
plot(ang,normMe(abs(model.sigmaXZ(3).lower(25,:))),'r.')
hold off
% errors
yyaxis right
error = normMe(abs(fp_sxz_3(25,:))) - normMe(abs(model.sigmaXZ(3).lower(25,:)));
plot(ang,error,'k')
ylabel('error')
title('\sigma_x_z - 3')



%% ========================================================================
%   PARTIAL WAVE AMPLITUDES
% =========================================================================
% get partial wave amplitudes from Elstic Matrix
fullMatrix = model.partialWaveAmplitudes;
% get bulk waves from GMM model
fpsen.BulkWaveAmps;
gmmMatrix = fpsen.myBulkWaveAmps;

% coefficients
figure(4);

% reflected comp;
subplot(3,4,1)
yyaxis left
plot(ang, abs(fullMatrix(25,:,2)))
hold on
plot(ang, abs(gmmMatrix(25,:,1)),'.')
% labels
ylabel('|R1 - comp|')
xlabel('Angle [\circ]')
% error
yyaxis right
plot(ang, normMe(abs(fullMatrix(25,:,2))) -  normMe(abs(gmmMatrix(25,:,1))))
ylabel('Error')

% reflected comp;
subplot(3,4,2)
yyaxis left
plot(ang, abs(fullMatrix(25,:,1)))
hold on
plot(ang, abs(gmmMatrix(25,:,2)),'.')
% labels
ylabel('|R1 - shear|')
xlabel('Angle [\circ]')
% error
yyaxis right
plot(ang, normMe(abs(fullMatrix(25,:,1))) -  normMe(abs(gmmMatrix(25,:,2))))
ylabel('Error')

subplot(3,4,3)
yyaxis left
plot(ang, abs(fullMatrix(25,:,6)))
hold on
plot(ang, abs(gmmMatrix(25,:,3)),'.')
% labels
ylabel('|R2 - comp|')
xlabel('Angle [\circ]')
% error
yyaxis right
plot(ang, normMe(abs(fullMatrix(25,:,6))) -  normMe(abs(gmmMatrix(25,:,3))))
ylabel('Error')

subplot(3,4,4)
yyaxis left
plot(ang, abs(fullMatrix(25,:,5)))
hold on
plot(ang, abs(gmmMatrix(25,:,4)),'.')
% labels
ylabel('|R2 - shear|')
xlabel('Angle [\circ]')
% error
yyaxis right
plot(ang, normMe(abs(fullMatrix(25,:,5))) -  normMe(abs(gmmMatrix(25,:,4))))
ylabel('Error')

subplot(3,4,5)
yyaxis left
plot(abs(fullMatrix(25,:,4)))
hold on
plot(abs(gmmMatrix(25,:,5)),'.')
% labels
ylabel('|T2 - comp|')
xlabel('Angle [\circ]')
% error
yyaxis right
plot(ang, normMe(abs(fullMatrix(25,:,4))) -  normMe(abs(gmmMatrix(25,:,5))))
ylabel('Error')

subplot(3,4,6)
yyaxis left
plot(ang, abs(fullMatrix(25,:,3)))
hold on
plot(ang, abs(gmmMatrix(25,:,6)),'.')
% labels
ylabel('|T2 - shear|')
xlabel('Angle [\circ]')
% error
yyaxis right
plot(ang, normMe(abs(fullMatrix(25,:,3))) -  normMe(abs(gmmMatrix(25,:,6))))
ylabel('Error')

subplot(3,4,7)
yyaxis left
plot(ang, abs(fullMatrix(25,:,10)))
hold on
plot(ang, abs(gmmMatrix(25,:,7)),'.')
% labels
ylabel('|R3 - comp|')
xlabel('Angle [\circ]')
% error
yyaxis right
plot(ang, normMe(abs(fullMatrix(25,:,10))) -  normMe(abs(gmmMatrix(25,:,7))))
ylabel('Error')


subplot(3,4,8)
yyaxis left
plot(ang, abs(fullMatrix(25,:,9)))
hold on
plot(ang, abs(gmmMatrix(25,:,8)),'.')
% labels
ylabel('|R3 - shear|')
xlabel('Angle [\circ]')
% error
yyaxis right
plot(ang, normMe(abs(fullMatrix(25,:,9))) -  normMe(abs(gmmMatrix(25,:,8))))
ylabel('Error')

subplot(3,4,9)
yyaxis left
plot(ang, abs(fullMatrix(25,:,8)))
hold on
plot(ang, abs(gmmMatrix(25,:,9)),'.')
% labels
ylabel('|T3 - comp|')
xlabel('Angle [\circ]')
% error
yyaxis right
plot(ang, normMe(abs(fullMatrix(25,:,8))) -  normMe(abs(gmmMatrix(25,:,9))))
ylabel('Error')

subplot(3,4,10)
yyaxis left
plot(ang, abs(fullMatrix(25,:,7)))
hold on
plot(ang, abs(gmmMatrix(25,:,10)),'.')
% labels
ylabel('|T3 - shear|')
xlabel('Angle [\circ]')
% error
yyaxis right
plot(ang, normMe(abs(fullMatrix(25,:,7))) -  normMe(abs(gmmMatrix(25,:,10))))
ylabel('Error')

subplot(3,4,11)
yyaxis left
plot(ang, abs(fullMatrix(25,:,12)))
hold on
plot(ang, abs(gmmMatrix(25,:,11)),'.')
% labels
ylabel('|T - comp|')
xlabel('Angle [\circ]')
% error
yyaxis right
plot(ang, normMe(abs(fullMatrix(25,:,12))) -  normMe(abs(gmmMatrix(25,:,11))))
ylabel('Error')

subplot(3,4,12)
yyaxis left
plot(ang, abs(fullMatrix(25,:,11)))
hold on
plot(ang, abs(gmmMatrix(25,:,12)),'.')
% labels
ylabel('|T - shear|')
xlabel('Angle [\circ]')
% error
yyaxis right
plot(ang, normMe(abs(fullMatrix(25,:,11))) -  normMe(abs(gmmMatrix(25,:,12))))
ylabel('Error')

%% ========================================================================
%   DIRECTIVITY COMPARISON
% =========================================================================


directivity_unnorm_fp = (fp_uz_3 - fp_uz_1);
directivity_norm_fp = directivity_unnorm_fp ./ ...
    (directivity_unnorm_fp(:,1)*ones(1, length(model.angle)));

directivity_unnorm_pw = (model.zDisplacement(3).upper ...
    - model.zDisplacement(1).lower );
directivity_norm_pw = directivity_unnorm_pw ./ ...
    (directivity_unnorm_pw(:,1)*ones(1, length(model.angle)));


figure;
subplot(1,3,1)
imagesc(model.angle, model.frequency/1e7, abs(directivity_norm_fp))
axis xy
colormap hot
colorbar
caxis([0 5])
title('SensorFP')

subplot(1,3,2)
imagesc(model.angle, model.frequency/1e7, abs(directivity_norm_pw))
axis xy
colormap hot
colorbar
caxis([0 5])
title('ElasticMatrix')

subplot(1,3,3)
imagesc(model.angle, model.frequency/1e7, abs(directivity_norm_fp)-abs(directivity_norm_pw))
axis xy
colormap hot
colorbar
% caxis([0 1e-7])
title(['Mean ERR : ',num2str(...
    mean(mean(abs(directivity_norm_fp)-abs(directivity_norm_pw))))])


