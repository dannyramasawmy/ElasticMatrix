%% FUNCTION/TEST SCRIPT NAME - v1.0 Date: 2018-
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
% addpath(genpath('../src'));
% AddKwave;
% clean workspaces
cls;

%% ========================================================================
%   MODEL
% =========================================================================

medium = Medium.generateLayeredMedium(...
    'water',0, 'aluminium',0.001,'water',1);

model = ElasticMatrix(medium);
model.setFrequency(linspace(0.1e6, 10e6, 100));
model.setAngle(linspace(0,89,100));
model.calculate;
% model.Calculate_Directivity([1 2]);
% model.Plot_Directivity;

% model.Calculate_Dispersion_Curves;

% figure(2)
% hold on
% plot(model.dispersion_curves(:,2),  model.dispersion_curves(:,1)/1e6, '.')

%%

% 19.99, 4.425e6
% 18.17, 6.092e6

Z_hf = linspace(-1e-3,0e-3,32);
X_hf = linspace(-1.5e-3, 1.5e-3,32);

tvec = 0; linspace(-1e-6, 1e-6,300);

for tdx = 1:length(tvec)
    field = model.displacementField(19.99,4.425e6,{Z_hf, X_hf}, tvec(tdx));
    field2 = model.displacementField(18.17, 6.092e6, {Z_hf, X_hf}, tvec(tdx));
    
    
    [Z, X] = meshgrid(Z_hf, X_hf);
    
    % figure,
    % imagesc(field.Xvec, field.Zvec, transpose(real(field.Z)))
    %
    % figure,
    % imagesc(field.Xvec, field.Zvec, transpose(real(field.X)))
    
    fact  = 1.5e3;
    samp = 1;
    
    figure(1),    % figure,

%     imagesc(field.Xvec, field.Zvec, transpose(real(field.Z)))
%     axis xy
    hold on
    
    a =     X(1:samp:end,1:samp:end) + fact* real(field.xDisp(1:samp:end,1:samp:end));
    b =         Z(1:samp:end,(1:samp:end)) + fact*real(field.zDisp(1:samp:end,1:samp:end));
    
    aa = X(1:samp:end,1:samp:end)' + fact* real(field.xDisp(1:samp:end,1:samp:end))';
    bb =       Z(1:samp:end,1:samp:end)' + fact*real(field.zDisp(1:samp:end,1:samp:end))';
    
    plot(a,b, 'k')
    plot(aa,bb, 'k')
    hold off
    title('Anti-symmetric')
    ee = 0.00005;
    ylim([-0.001-ee 0+ee])
    xlim([X_hf(1)-ee X_hf(end)+ee])
    box on
%     
%     axis equal
    
figure(2)
%     imagesc(field2.Xvec, field2.Zvec, transpose(real(field2.Z)))
%     axis xy
    hold on
    
    a =     X(1:samp:end,1:samp:end) + fact* real(field2.xDisp(1:samp:end,1:samp:end));
    b =         Z(1:samp:end,(1:samp:end)) + fact*real(field2.zDisp(1:samp:end,1:samp:end));
    
    aa = X(1:samp:end,1:samp:end)' + fact* real(field2.xDisp(1:samp:end,1:samp:end))';
    bb =       Z(1:samp:end,1:samp:end)' + fact*real(field2.zDisp(1:samp:end,1:samp:end))';
    
    plot(a,b, 'k')
    plot(aa,bb, 'k')
    hold off
    title('Symmetric')
      ylim([-0.001-ee 0+ee])
    xlim([X_hf(1)-ee X_hf(end)+ee])
    box on
%     axis equal
    
    drawnow;
%     pause(0.01)
    
    
end