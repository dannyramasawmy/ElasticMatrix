%% run_all
%
% Author    :   Danny Ramasawmy
%               rmapdrr@ucl.ac.uk
%               dannyramasawmy@gmail.com
% Date      :   2019-01-25  -   created
%
%   This script runs through every example script. This is a good function
%   to run to test all of the features are working as expected.
%
%
% =========================================================================
%   ADDPATHS
% =========================================================================
addpath('../src-pw/'); % clears the current variables and closes figures 
addpath('../examples')

% =========================================================================
%   RUN THROUGH ALL THE SCRIPTS
% =========================================================================

if exist('../testing','dir')
    % compatabilitiy (MATLAB version)
    test_compatability;
    pause(2);
    
    % comparison script
    test_comparison_with_GMM;
    pause(2);
    
    % test the fabry perot directivity
    test_fabry_perot_directivity;
    pause(2);
    
    % test fabry perot frequency response
    test_fabry_perot_frequency_response;
    pause(2);
    
    % calculation vs number of layers
    test_n_layers_vs_calculation_time;
    pause(2);
else
    warning('... testing data is not included ...')
    
end
% test the medium class
example_medium_class;  
pause(2);

% plotting th eslowness profiles
example_slowness_profiles;
pause(2);

% test elastic matrix class
example_elasticmatrix_class;
pause(2);

% plotting the reflection coefficient
example_reflection_and_transmission; 
pause(2);

% plotting dispalcement and stress at the interface
example_interface_parameters;
pause(2);

% plotting a displacement and stress field
example_plot_field_parameters;        
pause(2);

% plotting a displacement and stress field
example_plot_field_parameters_movie;        
pause(2);

% dispersion curve calcualtion comparison with disperse
example_dispersion_curve_titanium_plate;  
pause(2);

% PVDF plate
example_dispersion_curve_PVDF_plate   
pause(2);

% trest the fabry perot directivity
example_fabry_perot_directivity;   
pause(2);

% test fabry perot frequency response
example_fabry_perot_frequency_response;    
pause(2);

% finish
clc;
disp('... finished, all scripts have run...')
