%% example_plot_field_parameters
%
% Author    :   Danny Ramasawmy
%               rmapdrr@ucl.ac.uk
%               dannyramasawmy@gmail.com
% Date      :   2019-01-25  -   created
%

% ========================================================================
%   MODEL
% =========================================================================

% 
medium = Medium(...
    'water',0, 'aluminium',0.001, 'water',1);


model = ElasticMatrix(medium);
model.setFrequency(linspace(0.1e6, 10e6, 100));
model.setAngle(linspace(0,89,100));
model.calculate;


%%

% 19.99, 4.425e6
% 18.17, 6.092e6

Z_hf = linspace(-1.5e-3,0.5e-3,128);
X_hf = linspace(-1.5e-3, 1.5e-3,128);

tvec =  linspace(-1e-6, 1e-6,300);

for tdx = 1:length(tvec)
    field = model.calculateField(19.99,4.425e6,{Z_hf, X_hf}, tvec(tdx));
    field2 = model.calculateField(18.17, 6.092e6, {Z_hf, X_hf}, tvec(tdx));
    
    if tdx == 1
        [figH1] = model.plotField(field, 'Surf');
        [figH2] = model.plotField(field2, 'Surf');
    else
        model.plotField(field, figH1);
        model.plotField(field2, figH2);
    end
    
     
end