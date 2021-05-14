function [fields, obj] = calculateFieldKf(obj, frequency_choice, kx_choice, varargin)
    %CALCULATEFIELD Calculates the displacement and stress fields.
    %
    % DESCRIPTION
    %   CALCULATEFIELD(...) plots the displacement and stress field in the
    %   multi-layered structure for a given pair of frequency and angle.
    %   The function takes the partial_wave_amplitudes calculated from the
    %   .calculate function, and calculates the displacement and stress
    %   within the multi-layered structure over a range of values X_hf and
    %   Z_hf. Currently this function is limited to only plotting a single
    %   angle and frequency and cannot plot if the first layer is a vacuum.
    %   There are multiple types of figure-styles that can be plotted and
    %   these are described below.
    %
    % USEAGE
    %   [figure_handle] = calculateField(frequency_choice, kx_choice);
    %   [figure_handle] = calculateField(frequency_choice, kx_choice,...
    %       {vector-Z, vector-X});
    %   [figure_handle] = calculateField(frequency_choice, kx_choice,...
    %       {vector-Z, vector-X}, time);
    %
    % INPUTS
    %   frequency_choice    - Choice of frequency.  [Hz]
    %   angle_choice        - Choice of angle.      [degrees]
    %
    % OPTIONAL INPUTS
    %   {z_vector, x_vector} - cell containing two vectors, these vectors
    %   define the range in z and x and sample density. The grid on which
    %   the field parameters are calculated are at [Z, X] =
    %   meshgrid(z_vector, x_vector);
    %
    %   z_vector        - Range of z-coordinates.           [m]
    %   x_vector        - Range of x-coordinates.           [m]
    %   time            - Time of propagation, default 0.   [s]
    %
    % OUTPUTS
    %   fields                  - Structure with the calculated fields:
    %   fields.z_vector         - 1D vector of z-range.         [m]
    %   fields.x_vector         - 1D vector of x-range.         [m]
    %   fields.x_displacement   - 2D matrix of x-displacements. [m]
    %   fields.z_displacement   - 2D matrix of z-displacements. [m]
    %   fields.sigma_zz         - 2D matrix of normal stress.   [Pa]
    %   fields.sigma_xz         - 2D matrix of shear stress.    [Pa]
    %
    % DEPENDENCIES
    %   []              - There are no dependencies.    []
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - January      - 2019
    %   last update     - 05 - May          - 2020
    %
    % This file is part of the ElasticMatrix toolbox.
    % Copyright (c) 2021 Danny Ramasawmy.
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
    
    [fields, obj] = calculateFieldGeneral(obj, 'frequency-wavenumber', ...
        frequency_choice, kx_choice, varargin{:});
    
    
    