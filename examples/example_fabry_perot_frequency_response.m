%% example_fabry_perot_frequency_response
%
% Author        :   Danny Ramasawmy
%                   rmapdrr@ucl.ac.uk
%                   dannyramasawmy@gmail.com
%
% Date          :   2016-06-13 - created
%                   2016-11-04 - added all examples from paper
%
% Description
%   This script test the model by running the model for all 6 graphs in
%   Paul Beards - Transduction Mechanisms of the Fabry-Perot polymer film
%   sensing concept for wide-band ultrasound detection. This case is the
%   normal scenario of each of the models.
%
% Reference:
%   [1] Transduction mechanisms of the Fabry-Perot polymer film sensing
%   concept for wideband ultrasound detection, Paul Beard, 1999, IEEE
%   Transactions on Ultrasonics, Ferroelectrics and Frequency Control
%
% =========================================================================
%   SET PROPERTIES
% =========================================================================
cls;
% Define range of frequencies
freqs = linspace(0.1e6,30e6,100);
% Define range of angle (must start from 0)
angles = linspace(0,2,2);

% titles of the different figures
titles = {'Water Backed 50um PET',...
    'Glass Backed 50um PET',...
    'PMMA Backed 50um PET',...
    'Water Backed 23um PET',...
    'Glass Backed 23um PET',...
    'PMMA Backed 23 PET',};


% Figure 1 handle
mainFigHand = figure;

% different cases to plot
for idx = 1:6
    % Generate a structure
    switch idx
        case 1
            % 'Water Backed 50um PET'
            myMedium = Medium('water',0,...
                'PET',50 * 10^(-6),...
                'water',1);
        case 2
            % 'Glass Backed 50um PET'
            myMedium = Medium('water',0,...
                'PET',50 * 10^(-6),...
                'glass',1);
        case 3
            % 'PMMA Backed 50um PET',...
            myMedium = Medium('water',0,...
                'PET',50 * 10^(-6),...
                'PMMA',1);
        case 4
            % 'Water Backed 23um PET',...
            myMedium = Medium('water',0,...
                'PET',23 * 10^(-6),...
                'water',1);
        case 5
            % 'Glass Backed 23um PET',...
            myMedium = Medium('water',0,...
                'PET',23 * 10^(-6),...
                'glass',1);
        case 6
            % 'PMMA Backed 23 PET',};
            myMedium = Medium('water',0,...
                'PET',23 * 10^(-6),...
                'PMMA',1);
    end
    
    % initialize FabryPerot class    
    temp = FabryPerotSensor(myMedium);
    
    % set the properties
    temp.setFrequency(freqs); 
    temp.setAngle(angles);
    % three layer geometry so mirrors are at interface 1 and 2
    temp.setMirrorLocations([1 2]);
    
    % calculate the frequency response
    temp.calculateDirectivity;
    % get the normal incidence frequency response
    modelData = temp.getDirectivity('normal');
    
    % plotting 
    figure(mainFigHand)
    
    % get handle for subplot
    subplot(3,2,idx);
    
    % plot the model data
    plot(temp.frequency /1e6 , modelData ./ modelData(1), 'k')
    
    % labels
    title(titles{idx})
    ylim([0 1.5])
    xlim([0 30])
    axis square
    box on
    xlabel('Frequency [MHz]')
    ylabel('Normalised Mean Stress Amplitude')
    legend('Model','Location','southwest')
    
end

% set figure position
set(mainFigHand,'Position',[340 67 572 863]);


