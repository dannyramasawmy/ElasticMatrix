%CLS - clears the current workspace, command window and figures
%
% DESCRIPTION
%   CLS clears the command window, the variables in the
%   workspace and closes any open figures.
%
% USEAGE
%   [] = cls;
%
% INPUTS
%   []              - there are no inputs           []
%
% OPTIONAL INPUTS
%   []              - there are no optional inputs  []
%
% OUTPUTS
%   []              - there are no outputs          []
%
% DEPENDENCIES
%   []              - there are no dependencies     []
%
% ABOUT
%   author          - Danny Ramasawmy
%   contact         - dannyramasawmy+elasticmatrix@gmail.com
%   date            - 01 - November - 2016
%   last update     - 19 - July     - 2019
%
% This file is part of the ElasticMatrix toolbox.
% Copyright (c) 2019 Danny Ramasawmy.
%
% This file is part of ElasticMatrix. ElasticMatrix is free software:
% you can redistribute it and/or modify it under the terms of the GNU
% Lesser General Public License as published by the Free Software
% Foundation, either version 3 of the License, or (at your option) any
% later version.
%
% ElasticMatrix is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% Lesser General Public License for more details.
%
% You should have received a copy of the GNU Lesser General Public
% License along with ElasticMatrix. If not, see
% <http://www.gnu.org/licenses/>.

% =========================================================================
%   CLEAR WORKSPACE
% =========================================================================

% close figures
close all;

% clear variables

clear all;   %#ok<CLALL> % suppress clear all warning

% clear command window
clc;
