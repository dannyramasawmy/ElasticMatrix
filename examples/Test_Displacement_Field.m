%% TestdisplacementField
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
%   PATHS AND CLEAN
% =========================================================================
addpath(genpath('./mat_funcs'));

%% ========================================================================
%   INITALISE MODELS
% =========================================================================

% close all
cls

% medium
medium = Medium.Generate_Layered_Medium('water',0,'PVDF',1);

% initalise elastic matrix
model = ElasticMatrix(medium);

ang = 15;
freq = 40e6;

% set frequencies and angles
% model.Set_Frequency(linspace(2e6,300e6,600));
% % model.Set_Angle(0.1:0.2:89.9);
% Z_hf = linspace(-200e-6,100e-6,512);
% X_hf = linspace(-1e-4, 1e-4,512);

model.Set_Frequency(linspace(40e6,60e6,20)) 
model.Set_Angle(15:0.2:35);
ots = 0;
            
% model.Set_Angle(0);
model.Calculate;

f_weight =  normpdf(linspace(-pi,pi,length(model.frequency)));


Z_hf = linspace(-300e-6,300e-6,256);
X_hf = linspace(-300e-6, 300e-6,256);

% Z_hf = linspace(-10e-6,10e-6,256);
% X_hf = linspace(-10e-6, 10e-6,256);

time = linspace(-30e-8, 40e-8,200);
%   h =;
%time =  linspace(-4e-8, 20e-8,100);
%   h = figure;

tic
for tdx = 1:length(time)

   comb_field_z = zeros(length(X_hf), length(Z_hf));
   comb_field_x = zeros(length(X_hf), length(Z_hf));
   
    for adx = 1:length(model.angle)
        
        for fdx = 1:length(model.frequency)
            % 1e8 seems like a good time so far
            field = model.Displacement_Field(...
                model.angle(adx), (model.frequency(fdx)),{Z_hf, X_hf},time(tdx));
            
         
            comb_field_z = f_weight(fdx) *(field.Z + ots* flipud(field.Z)) +  comb_field_z;
            comb_field_x = f_weight(fdx) *(field.X + ots* flipud(field.X)) +  comb_field_x;
            disp([tdx, adx, fdx])
        end

    end
    
    
    
    X_field(:,:,tdx) = comb_field_z;
    Z_field(:,:,tdx) = comb_field_x;
end
toc
%     figure(h)
%     subplot(1,3,1)
%     imagesc(field.Zvec, field.Xvec, real(field.X))
%     colormap hot
%     colorbar
%     axis square
%     title('X - disp')
%
%     subplot(1,3,2)
%     imagesc(field.Zvec, field.Xvec, real(field.Z))
%     colormap hot
%     colorbar
%     axis square
%     title('Z - disp')
%
figure(1)
%     subplot(1,3,3)
% imagesc(field.Zvec, field.Xvec, sqrt((real(comb_field_x)).^2+(real(comb_field_z)).^2))
imagesc(field.Zvec, field.Xvec, real(comb_field_z))
colormap hot
colorbar
axis equal
title('mag-disp')

return

figure(1)
%     subplot(1,3,3)
imagesc(field.Zvec, field.Xvec, real(comb_field_z))
colormap hot
colorbar
axis square
title('mag-disp')
%%
figure(1)
for idx = 1:length(time)
%     figure
    imagesc(((abs(Z_field(:,:,idx)))))
    caxis([-1e-7 1e-7])
%     pause
    drawnow
    

    pause(0.01)

end


return
max(abs(real(X_field(:,:,:))))

%% ========================================================================
%   INITALISE MODELS
% =========================================================================

gmm_medium = generateMaterialStructure('water',0,'PVDF',30e-6,'glass',1);
sensor = SensorFP(gmm_medium);
sensor.freqs = 40e6;
sensor.angles = linspace(0,45,100);
sensor.CalcDir;

thetac = 15;
freqc = 40.2e6;
% in the extended frequency range
Z_hf = linspace(-50e-6,50e-6,300);
X_hf = linspace(-150e-6,150e-6,300);
sensor.PlotDisplacementMesh2D(freqc,thetac,{Z_hf,X_hf},0,{'2DDisplacement'});
