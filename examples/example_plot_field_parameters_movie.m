%% example_plot_field_parameters
%
% Author    :   Danny Ramasawmy
%               rmapdrr@ucl.ac.uk
%               dannyramasawmy@gmail.com
% Date      :   2019-01-25  -   created
%
% This script demonstrates how to plot the displacement and stress fields
% for the layered medium with time. This is calculated for a certain angle 
% and frequency, the future code will accept a phase velocity and 
% wavenumber as an input. 
%
%  to create a movie UNCOMMENT indicated lines of code 
%   search for: < ## UNCOMMENT TO WRITE MOVIE ## >
%
% ========================================================================
%   MODEL
% =========================================================================
% firstly run the model over a range or single pair of angle(s) and 
% frequencie(s). Ensure that the angle-frequency pair you wish to plot the
% fields for are included within the calculations. 

% initalise the medium
medium = Medium(...
    'water',Inf, 'aluminium',0.001, 'water',Inf);

% initalise ElasticMatrix class
model = ElasticMatrix(medium);
% set some properties
model.setFrequency(linspace(0.1e6, 10e6, 100));
model.setAngle(linspace(0,89,100));
% run model to calcualte the partial wave coefficients, these are used to
% plot the field values
model.calculate;

% =========================================================================
%   DEFINE THE Z AND X VECTORS THAT THE PLOTTING MESH WILL USE
% =========================================================================

% parameters for a symmetric
chosenAngleS = 18.17;
chosenFreqS = 6.092e6;

% parameters for an antisymmetric mode
chosenAngleA = 19.99;
chosenFreqA = 4.425e6;

% vectors range and number of points
samplePoints = 64;
Zhf = linspace( -1.5e-3, 0.5e-3, samplePoints);
Xhf = linspace( -1.5e-3, 1.5e-3, samplePoints);

% =========================================================================
%   PLOTTING WITH DIFFERENT TIME INCREMENTS (FOR MAKING MOVIES)
% =========================================================================

% uncomment lines below to initalise and open video writer class
% vS = VideoWriter('TestAlPlateSmode.mp4','MPEG-4'); % ## UNCOMMENT TO WRITE MOVIE # 
% vA = VideoWriter('TestAlPlateAmode.mp4','MPEG-4'); % ## UNCOMMENT TO WRITE MOVIE # 
% open(vS) % ## UNCOMMENT TO WRITE MOVIE ## 
% open(vA) % ## UNCOMMENT TO WRITE MOVIE ## 


% create time array
tvec =  linspace(0e-6, 0.5e-6, 100);

for tdx = 1:length(tvec)
    
    % calculate fields for a symmetric and anti-symmetric mode
    fieldS = model.calculateField(chosenAngleS, chosenFreqS, {Zhf, Xhf}, tvec(tdx));
    fieldA = model.calculateField(chosenAngleA, chosenFreqA, {Zhf, Xhf}, tvec(tdx));
    
    % for the FIRST loop - -use a plotting argument
    if tdx == 1
        % any plotting argument is acceptable, i.e. 'surf' see:
        % help plotField
        [figH1] = model.plotField(fieldS, 'Mesh');
        [figH2] = model.plotField(fieldA, 'Mesh');
    else
        
        % for the REMAINNG LOOPS give the plot-field the figure handle to
        % plot with the same figure handle
        % plot the symmetric mode
        model.plotField(fieldS, figH1);
        
        % force plot
        % frameS = getframe(gcf); % ## UNCOMMENT TO WRITE MOVIE ##  
        % writeVideo(vS, frameS); % ## UNCOMMENT TO WRITE MOVIE ##
        
        % plot the anti symmetric mode
        model.plotField(fieldA, figH2);
        
        % force plot
        % frameA = getframe(gcf); % ## UNCOMMENT TO WRITE MOVIE ##
        % writeVideo(vA, frameA); % ## UNCOMMENT TO WRITE MOVIE ##
        
    end     
end

% close open videoWriter classes
% close(vS)  % ## UNCOMMENT TO WRITE MOVIE ##
% close(vA)  % ## UNCOMMENT TO WRITE MOVIE ##
    