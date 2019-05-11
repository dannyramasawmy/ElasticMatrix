%% tests anisotropic reflection coefficient
%
% Author    :   Danny Ramasawmy
%               rmapdrr@ucl.ac.uk
%               dannyramasawmy@gmail.com
% Date      :   2019-  -   created
%
% 
% Description
% 
%
% ERROR     :   2019-
%
%
%% ========================================================================
%   PATHS AND CLEAN
% =========================================================================
% add path
addpath(genpath('./mat_funcs'));
% AddKwave;
% clean workspaces
cls;
%% ========================================================================
%   MODEL
% ========================================================================


medium3 =  Medium.generateLayeredMedium(...
    'water',0,'steel1020',1);
model = ElasticMatrix(medium3);
model.setAngle(linspace(0.1,89,100));
model.setFrequency(1e6)
model.calculate
figure,plot(abs(model.partialWaveAmplitudes(:,:,2)))

% Medium('blank',1)

mediumGE = Medium.generateLayeredMedium(...
    'water',0,'graphiteEpoxy',0.001,'water',1);


medium2 = Medium.generateLayeredMedium(...
    'water',0,'CubicInAs0',1);

medium = Medium.generateLayeredMedium(...
    'water',0,'CubicInAs45',1);

% initalise elastic matrix model
model = ElasticMatrix(medium);
model.setAngle(linspace(0,89,300));
model.setFrequency(1e6);

model.calculate;
isotropic = model.partialWaveAmplitudes;

model.setMedium(medium2);
model.calculate;
anisotropic = model.partialWaveAmplitudes;

figure;
subplot(3,1,1)
hold on
plot(model.angle, abs(isotropic(1,:,2)),'k')
plot(model.angle, abs(anisotropic(1,:,2)),'k--')
% labels
xlabel('Angle')
ylabel('|R|')
% ylim([0 1])

subplot(3,1,2)
hold on
plot(model.angle, imag(isotropic(1,:,2)),'k')
plot(model.angle, imag(anisotropic(1,:,2)),'k--')
% labels
xlabel('Angle')
ylabel('|qTL|')


subplot(3,1,3)
hold on
plot(model.angle, abs(isotropic(1,:,2)),'k')
plot(model.angle, abs(anisotropic(1,:,2)),'k--')
% labels
xlabel('Angle')
ylabel('|qTS|')

