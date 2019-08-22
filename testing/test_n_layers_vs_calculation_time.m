%% example_n_layers_vs_calculation_time 
%
% DESCRIPTION
%   example_n_layers_vs_calculation_time builds model geometries with an
%   increasing number of layers and times how long it takes to calculate
%   the partial-wave method for a set range of inputs.
%
% ABOUT
%   author          - Danny Ramasawmy
%   contact         - dannyramasawmy+elasticmatrix@gmail.com
%   date            - 11 - July     - 2019
%   last update     - 22 - August   - 2019
%
% This file is part of the ElasticMatrix toolbox.
% Copyright (c) 2019 Danny Ramasawmy.
%
% This file is part of ElasticMatrix. ElasticMatrix is free software: you
% can redistribute it and/or modify it under the terms of the GNU Lesser
% General Public License as published by the Free Software Foundation,
% either version 3 of the License, or (at your option) any later version.
%
% ElasticMatrix is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser
% General Public License for more details.
%
% You should have received a copy of the GNU Lesser General Public License
% along with ElasticMatrix. If not, see <http://www.gnu.org/licenses/>.

% =========================================================================
%   MODEL
% =========================================================================
cls;

% make medium
my_medium = Medium('PVDF',1e-6);

% initialize elastic matrix
my_model = ElasticMatrix(my_medium);

% number of points, x^2
number_points = 50;

% set model parameters
my_model.setAngle(       linspace(0,     45, number_points));
my_model.setFrequency(   linspace(0.1e6, 5e6,number_points));

output_time = zeros(30,2);

% loop, add a new layer to myModel each time, and recalculate
for idx = 2:30
    
    % add new medium
    my_medium(idx) = Medium('PVDF',Inf);
    if idx > 2
        % set previous thickness to 1 micron (could be anything)
        my_medium.setThickness(idx-1, 1e-6);
    end
    
    % update model (this resets any calculations performed)
    my_model.setMedium(my_medium);
    my_model.disp
    % run and time
    tic;
    my_model.calculate;
    tmp_time = toc;
    
    % store time
    output_time(idx-1,:) = [idx, tmp_time];
    
end

% =========================================================================
%   PLOTTING
% =========================================================================
h = figure;
plot(output_time(:,1),output_time(:,2),'k.')
% labels
title('Run Time of ElasticMatrix');
legend('Elastic')
xlabel('Number of Layers')
ylabel('Time [s]')
% ylim([0 10])
xlim([0 40])
set(h,'Position',[388 482 459 370])








