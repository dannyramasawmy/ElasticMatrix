%% example_n_layers_vs_calculation_time 
%
% Author    :   Danny Ramasawmy
%               rmapdrr@ucl.ac.uk
%               dannyramasawmy@gmail.com
% Date      :   2019-07-11  -   created
%
%
% Description
%   This script times the execution time of elastic matrix for an
%   increasing number of layers.
%
% =========================================================================
%   MODEL
% =========================================================================
cls;

% make medium
myMedium = Medium('PVDF',1e-6);

% initalise elastic matrix
myModel = ElasticMatrix(myMedium);

% number of points, x^2
numberPoints = 50;

% set model parameters
myModel.setAngle(       linspace(0,     45, numberPoints));
myModel.setFrequency(   linspace(0.1e6, 5e6,numberPoints));

% loop, add a new layer to myModel each time, and recalculate
for idx = 2:30
    
    % add new medium
    myMedium(idx) = Medium('PVDF',Inf);
    if idx > 2
        % set previous thickness to 1 micron (could be anything)
        myMedium.setThickness(idx-1, 1e-6);
    end
    
    % update model (this resets any calculations performed)
    myModel.setMedium(myMedium);
    myModel.disp
    % run and time
    tic;
    myModel.calculate;
    tmpTime = toc;
    
    % store time
    outputTime(idx-1,:) = [idx, tmpTime];
    
end

% =========================================================================
%   PLOTTING
% =========================================================================
h = figure;
plot(outputTime(:,1),outputTime(:,2),'k.')
title('Run Time of ElasticMatrix');
legend('Elastic')
xlabel('Number of Layers')
ylabel('Time [s]')
% ylim([0 10])
xlim([0 40])
set(h,'Position',[388 482 459 370])








