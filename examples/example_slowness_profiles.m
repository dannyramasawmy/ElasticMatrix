%% example_slowness_profiles
%
% Author    :   Danny Ramasawmy
%               rmapdrr@ucl.ac.uk
%               dannyramasawmy@gmail.com
% Date      :   2019-01-25  -   created
%
%   This script will demonstrate how to calculate slowness profiles using
%   the Medium class. Please refer to the example_medium_class.m script if
%   unfamilar with the class attibutes and methods.

% =========================================================================
%   INITALISE THE MEDIUM
% =========================================================================
% firstly create a Medium object with each material needed to generate a
% plot. Here the slowness profiles of water, glass and beryl will be
% generated
myMedium = Medium.generateLayeredMedium('water',Inf,'glass',0.001,'beryl2',Inf);

% calculate the slowness profiles
myMedium.calculateSlowness;

myMedium.plotSlowness;