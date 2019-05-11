%% plots stress field
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
addpath(genpath('../src'));
% AddKwave;
% clean workspaces
cls;
%% ========================================================================
%   MODEL
% =========================================================================

medium = Medium.generateLayeredMedium(...
    'water',0,'aluminium',1e-3,'water',1);

model = ElasticMatrix(medium);
model.setFrequency(linspace(0.1e6, 10e6, 100));
model.setAngle(linspace(0,89,100));
model.calculate;

%%
Z_hf = linspace(-1.5e-3,0.5e-3,256);
X_hf = linspace(-1.5e-3, 1.5e-3,512);
fields = model.displacementField(19.99,4.425e6,{Z_hf, X_hf});
% fields = model.Displacement_Field(20, 10e6);

figure, 
subplot(2,2,1)
imagesc(fields.zVec, fields.xVec, real(fields.xDisp))

subplot(2,2,2)
imagesc(fields.zVec, fields.xVec,real(fields.zDisp))

subplot(2,2,3)
imagesc(fields.xVec, fields.xVec,real(fields.sigZZ))

subplot(2,2,4)
imagesc(fields.zVec, fields.xVec,real(fields.sigXZ))