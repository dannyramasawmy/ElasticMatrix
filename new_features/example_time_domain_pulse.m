%% ExampleReflectionTimeDomain
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
cls

%% ========================================================================
%   INITALISE MODELS
% =========================================================================

% medium
% medium = Medium('water',0,'PVDF',100e-6,'water',0);
% medium = Medium('water',0,'PVDF',100e-6);

% medium = Medium('water',0,'aluminium',1);
% medium = Medium('water',0,'glass',100e-6,'water',0);
medium = Medium('water',0,'aluminium',100e-6,'water',0);

% medium = Medium('water',0,'aluminium',10e-6,...
%     'water',200e-6,'aluminium',10e-6,'water',0);

% initalise elastic matrix
model = ElasticMatrix(medium);

% choose frequency and angle range
frequency_range = linspace(40e6,60e6,30);
% frequency_range = linspace(40e6,60e6,3);

angle_shifter = 0;
angle_range = 8:0.1:42 + angle_shifter;
% time_range = linspace(-30e-8, 40e-8,200);
% time_range = [-1.5e-07, 0, 1.5e-07,3e-7,4.5e-7]; % 50,90,130
time_range = linspace(-3.0e-7, 5e-7, 50);

% controls / weightings
ots = 0;                        % Reflection about the axis


f_weight = ones(1,length(frequency_range));
a_weight = ones(1,length(angle_range)); % apodization

f_weight = normpdf(linspace(-pi,pi,length(frequency_range)));
a_weight = normpdf(linspace(-pi,pi,length(angle_range))); % apodization


N = 256;
% N = 64;
% N = 128;

% grid
Z = linspace(-400e-6, 500e-6, N);
X = linspace(-300e-6, 1000e-6, 2*N);


% need to set this up
videoClass = VideoWriter('outputName.mp4','MPEG-4');         % #need this

figHand = figure(1);                                % #need this

frameRate = 10;                                      % optional
videoClass.set('FrameRate',frameRate)               % optional
open(videoClass)              


for tdx = 1:length(time_range)
    
    % initialise stress field
    comb_field_z = zeros(length(X), length(Z));
    comb_field_x = zeros(length(X), length(Z));
    
    % angle loop
    parfor adx = 1:length(angle_range)
        % frequency loop
        for fdx = 1:length(frequency_range)
            
            % 1e8 seems like a good time so far
            field = model.calculateField(...
                (frequency_range(fdx)), angle_range(adx), {Z, X},time_range(tdx));
            
            %             comb_field_z = f_weight(fdx) *(field.zDisp + ots* flipud(field.zDisp)) +  comb_field_z;
            %             comb_field_x = f_weight(fdx) *(field.xDisp + ots* flipud(field.xDisp)) +  comb_field_x;
            
            comb_field_z = a_weight(adx) * f_weight(fdx) *...
                (field.sigma_zz + ots* flipud(field.sigma_zz)) +  comb_field_z;
            comb_field_x = a_weight(adx) * f_weight(fdx) *...
                (field.sigma_xz + ots* flipud(field.sigma_xz)) +  comb_field_x;
            
            % check indicies
            disp([tdx, adx, fdx])
        end
        
    end
    
    
    field.sigma_zz = comb_field_z;
    field.sigma_xz = comb_field_x;
    %
    %     field.sigZZ = comb_field_z;
    %     field.sigXZ = comb_field_z
    
    X_field(:,:,tdx) = comb_field_x;
    Z_field(:,:,tdx) = comb_field_z;
    
    % % plotting
    figure(figHand)
    
    subplot(1,2,1)
    imagesc( X,Z, normMe([real(Z_field(:,:,tdx))])')
    axis xy image
    colormap gray
    
    subplot(1,2,2)
    imagesc( X,Z, normMe([abs(Z_field(:,:,tdx))])')
    % make pretty
    axis xy image
    colormap gray
    
    set(figHand, 'Position', [292 431 948 547])
    
    frame = getframe(figHand);                       % #need this
    writeVideo(videoClass,frame)                    % #need this
end


close(videoClass)                                   % #need this

