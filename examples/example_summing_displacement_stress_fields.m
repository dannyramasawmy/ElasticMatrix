%% TestdisplacementField
%
% Author    :   Danny Ramasawmy
%               rmapdrr@ucl.ac.uk
%               dannyramasawmy@gmail.com
% Date      :   2019-01-25  -   created
%
%
% Description
% Multiple plane waves can be summed to produce an arbitrary shaped field.
% This example demonstrates how to use ElasticMatrix to show the
% displacement/stress fields for a non-plane source
%
% An arc source can be created by summing different frequency plane waves
% at different angles. This script will demonstrate an ultrasound pulse in
% water refecting from a water-PVDF interfaces
%
% This script utilises the parallel computing toolbox
%
% ========================================================================
%   INITALISE MODELS AND SET PARAMETERS
% =========================================================================
cls;

try 
   ver('distcomp')
catch
   fprintf('...Parallel computing toolbox not installed...')
   fprintf('...this code may take a few minutes to run...')
   
end

% medium
myMedium = Medium('water',0,'PVDF',1);

% initalise elastic matrix
myModel = ElasticMatrix(myMedium);

% set parameters
myModel.setFrequency(linspace(40e6,60e6,20))
myModel.setAngle(15:0.2:35);
ots = 0;

% model.Set_Angle(0);
myModel.calculate;

% add a weighting to different frequencies
fWeight =  normpdf(linspace(-pi,pi,length(myModel.frequency)));


% define plotting mesh
samples = 128;
Z_hf = linspace(-300e-6,    300e-6,     samples);
X_hf = linspace(-300e-6,    300e-6,     samples);

% time vector for movie
time = linspace(-15e-8, 10e-8,50);

% loop over time + freqeuncy + angle
tic
parfor tdx = 1:length(time)
    
    % initalise combined fields
    combStressZZ = zeros(length(X_hf), length(Z_hf));
    combStressXZ = zeros(length(X_hf), length(Z_hf));
    
    % sum over every angle and frequency for each time point to get an
    for adx = 1:length(myModel.angle)
        
        for fdx = 1:length(myModel.frequency)
            % 1e8 seems like a good time so far
            field = myModel.calculateField(...
                (myModel.frequency(fdx)), myModel.angle(adx), {Z_hf, X_hf},time(tdx));
            
            % sum the fields together
            combStressZZ = fWeight(fdx) *(field.sigZZ ) +  combStressZZ;
            combStressXZ = fWeight(fdx) *(field.sigXZ ) +  combStressXZ;
            
      
        end
        
    end
    
    % what index
    disp(['time index: ',num2str(tdx),'/',num2str(length(time))])
    
    % output field
    outputStressXZ(:,:,tdx) = combStressXZ;
    outputStressZZ(:,:,tdx) = combStressZZ;
end

% =========================================================================
%   WRITE VIDEO
% =========================================================================
% open video writer class
v = VideoWriter('TestVideo4.mp4','MPEG-4');

% open figure
figure(1)
frameRate = 50;                                 
open(v)                                    

% for each time index
for idx = 1:length(time)
    
    myfig = figure(1);
    
    % surf plot the displacement field
    s = surf(X_hf, Z_hf,((real(outputStressZZ(:,:,idx)))));
    
    % set figure properties
    s.EdgeColor = 'none';
    set(myfig,'color','none')
    axis off
    view(-35,70)
    zlim([-5 5]*1e8)
    drawnow;

    % get the current frame and write to video
    frame = getframe(gcf);                 
    writeVideo(v,frame)                  
    
end

close(v)                                  
