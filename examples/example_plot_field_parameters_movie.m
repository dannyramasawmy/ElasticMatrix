%% Example Plot Field Parameters - Movie
% This example continues from Example: Plot Field Parameters, and
% demonstrates how to create a movie of a stress or displacement field.

%% Initialize an ElasticMatrix Object
% Initialize the ElasticMatix object, in this example it will be an
% aluminium plate in water.

% Medium class:
my_medium = Medium(...
    'water', Inf, 'aluminium', 0.001, 'water', Inf);

% Initialize an ElasticMatrix object:
my_model = ElasticMatrix(my_medium);

%% Setting Calculation Parameters
% Chosen angle and frequency:
% Symmetric Lamb mode:
angle_s = 18.17;
freq_s  = 6.092e6;

% Antisymmetric Lamb mode:
angle_a = 19.99;
freq_a  = 4.425e6;

% Define plotting vectors:
sample_points = 64;
Z = linspace(-1.5e-3, 0.5e-3, sample_points);
X = linspace(-1.5e-3, 1.5e-3, sample_points);

%% Loop and Write Movie

% Initialize and open video writer objects:
vS = VideoWriter('TestAlPlateSmode.mp4', 'MPEG-4'); 
open(vS) 
vA = VideoWriter('TestAlPlateAmode.mp4', 'MPEG-4'); 
open(vA)  

% Create time array:
t_vec =  linspace(0e-6, 0.5e-6, 200);

% Loop over time array:
for tdx = 1:length(t_vec)
    
    % Calculate fields for a symmetric and anti-symmetric mode:
    field_s = my_model.calculateField(freq_s, angle_s, {Z, X}, t_vec(tdx));
    field_a = my_model.calculateField(freq_a, angle_a, {Z, X}, t_vec(tdx));
    
    % For the first loop - use a plotting argument:
    if tdx == 1
        % Use a mesh plotting style:
        fig_h1 = my_model.plotField(field_s, 'mesh');
        fig_h2 = my_model.plotField(field_a, 'mesh');
    else
        
        % For the remaining loops pass the figure handle:
        % Symmetric mode:
        my_model.plotField(field_s, fig_h1);
        
        % Force update plot:
        frame_s = getframe(gcf);   
        writeVideo(vS, frame_s); 
        
        % Plot the anti-symmetric mode:
        my_model.plotField(field_a, fig_h2);
        
        % Force update plot:
        frame_a = getframe(gcf); 
        writeVideo(vA, frame_a); 
        
    end     
end

% Close VideoWriter objects:
close(vS)  
close(vA)  
    


