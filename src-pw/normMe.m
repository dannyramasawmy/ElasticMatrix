function [normalised_matrix] = normMe(input_matrix)
    %NORMME Normalises a matrix to the maximum absolute value.
    %
    % DESCRIPTION
    %   NORMME(inputMatrix) takes a matrix or vector of any size, finds the
    %   absolute maximum value and normalized the vector. Therefore, the
    %   element with the largest absolute value is equal to 1.
    %
    % USEAGE
    %   normalised_matrix = normMe(input_matrix);
    %
    % INPUTS
    %   input_matrix    - A matrix with an arbitrary size and dimension. []
    %
    % OPTIONAL INPUTS
    %   []              - There are no optional inputs. []
    %
    % OUTPUTS
    %   outputs         - The normalized matrix.        []
    %
    % DEPENDENCIES
    %   []              - There are no dependencies.    []
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 26 - October  - 2016
    %   last update     - 30 - July     - 2019
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
        
    % find the maximum value
    max_value = max( abs( input_matrix(:) ));
    % normalize the matrix
    normalised_matrix = input_matrix ./ max_value;
    
end


