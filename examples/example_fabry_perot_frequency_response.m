%% Example: Fabry-Perot Frequency Response
% This example plots the frequency response of the Fabry-Perot sensor for 6
% different sensor types, repoducing the results found in [1].
%
% [1] Transduction mechanisms of the Fabry-Perot polymer film sensing
% concept for wideband ultrasound detection, Paul Beard, 1999, IEEE
% Transactions on Ultrasonics, Ferroelectrics and Frequency Control
%

%% Setting Parameters

% Define range of frequencies:
freqs = linspace(0.1e6, 30e6, 100);

% Define range of angle (must start from 0):
angles = linspace(0, 2, 2);

% Titles of the different figures:
titles = {'Water Backed 50um PET', ...
    'Glass Backed 50um PET', ...
    'PMMA Backed 50um PET', ...
    'Water Backed 23um PET', ...
    'Glass Backed 23um PET', ...
    'PMMA Backed 23 PET'};

% Figure 1 handle
main_fig_hand = figure;

% different cases to plot
for idx = 1:6

    % Generate a structure
    switch idx
        case 1
    
            % 'Water Backed 50um PET'
            my_medium = Medium('water', 0, ...
                'PET', 50 * 10^(-6), ...
                'water', 1);
        case 2
            
            % 'Glass Backed 50um PET'
            my_medium = Medium('water', 0, ...
                'PET', 50 * 10^(-6), ...
                'glass', 1);
        case 3
            
            % 'PMMA Backed 50um PET',...
            my_medium = Medium('water', 0, ...
                'PET', 50 * 10^(-6), ...
                'PMMA', 1);
        case 4
            
            % 'Water Backed 23um PET',...
            my_medium = Medium('water', 0, ...
                'PET', 23 * 10^(-6), ...
                'water', 1);
        case 5
            
            % 'Glass Backed 23um PET',...
            my_medium = Medium('water', 0, ...
                'PET', 23 * 10^(-6), ...
                'glass', 1);
        case 6
            
            % 'PMMA Backed 23 PET',};
            my_medium = Medium('water', 0, ...
                'PET', 23 * 10^(-6), ...
                'PMMA', 1);
    end
    
    % Initialize FabryPerot object:    
    temp = FabryPerotSensor(my_medium);
    
    % Set the properties:
    temp.setFrequency(freqs); 
    temp.setAngle(angles);
    
    % Three layer geometry, mirrors are at interface 1 and 2:
    temp.setMirrorLocations([1 2]);
    
    % Calculate the frequency-response:
    temp.calculateDirectivity;
    
    % Get the normal incidence frequency response:
    model_data = temp.getDirectivity('normal');
    
    % Plotting:
    figure(main_fig_hand)
    
    % Get handle for subplot:
    subplot(3, 2, idx);
    
    % Plot the model data:
    plot(temp.frequency / 1e6, model_data ./ model_data(1), 'k')
    
    % Labels:
    title(titles{idx})
    ylim([0 1.5])
    xlim([0 30])
    axis square
    box on
    xlabel('Frequency [MHz]')
    ylabel('Normalised Mean Stress Amplitude')
    legend('Model','Location','southwest')
    
end

% Set figure position:
set(main_fig_hand, 'Position', [340 67 572 863]);

