%% example_interface_parameters 
%
%   Author
%   Danny Ramasawmy
%   rmapdrr@ucl.ac.uk
%
%   Descriptions:
%       Plots the parameters (stress/displacement) at every interface of the
%   multi-layered medium.
%
% =========================================================================
%   SET UP MODEL
% =========================================================================

% medium
myMedium = Medium('PVDF',Inf,'glass',0.001,'aluminium',Inf);

% model
model = ElasticMatrix(myMedium);

% set parameters
model.setFrequency(1e6);
model.setAngle(linspace(0,89,100));

% calculate 
model.calculate;

% plot the interface parameters
model.plotInterfaceParameters;
