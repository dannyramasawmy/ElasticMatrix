function [directivity] = getDirectivity(obj, varargin)
    %GETDIRECTIVITY Returns calculated directivity data.
    %
    % DESCRIPTION
    %   GETDIRECTIVITY(...) returns the directivity data held in property
    %   obj.directivity. The directivity data is in general complex, this
    %   function will process it and return it in a number of different
    %   ways - this is described below.
    %
    % USEAGE
    %   [directivity] = getDirectivity(obj, varargin)
    %   
    % INPUTS
    %   []                - There are no inputs.           []
    %
    % OPTIONAL INPUTS
    %   Only one optional input is accepted, this must be a string:
    %   - 'raw'           - Calculated (complex) obj.directivity.
    %   - 'real'          - Imaginary part of obj.directivity.
    %   - 'imag'          - Real part of obj.directivity.
    %   - 'phase'         - Phase of obj.directivity.
    %   - 'abs'           - Absolute values of obj.directivity.
    %   - 'linear'        - Normalized to normal incidence response. 
    %                       obj.directivity.
    %   - 'decibel'       - Decibel scaling of 'linear'.
    %   - 'normalise'     - Normalize to maximum value of normal incidence.
    %   - 'normal'        - Normal incidence response.
    %
    % OUTPUTS
    %   directivity     - Matrix or vector of size length(obj.frequency) X
    %                     length(obj.angle).
    %
    % DEPENDENCIES
    %   []              - There are no dependencies.     []
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 05 - May      - 2019
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
    %
    
    % get the raw directivity
    unprocessed_directivity = obj.directivity;
    
    % normalized to normal incidence response
    normalised_directivity = unprocessed_directivity ./ ...
        (unprocessed_directivity(:,1) * ones(1,length(obj.angle)));
    
    % check if varargin is empty
    if isempty(varargin)
        varargin{1} = 'raw';
    end
    
    % check the inputs
    valid_types = {'raw', 'real', 'imag', 'abs', 'phase', 'linear', ...
        'decibel', 'normal', 'normalise'};
    process_string = validatestring(varargin{1}, valid_types);
    
    % check against common cases otherwise return raw
    switch process_string
        case 'raw'
            % return complex data
            directivity = unprocessed_directivity;
            
        case 'real'
            % take real part
            directivity = real(unprocessed_directivity);
    
        case 'imag'       
            % take imaginary part
            directivity = imag(unprocessed_directivity);
            
        case 'abs'
            % absolute value
            directivity = abs(unprocessed_directivity);
            
        case 'phase'
            % returns phase after normalization to normal incidence
            directivity = angle(unprocessed_directivity) ;

        case 'linear'
            % absolute value after normalization
            directivity = abs(normalised_directivity);
                                               
        case 'decibel'
            directivity = 20 * log10( obj.getDirectivity('linear'));
            
        case 'normal'
            % returns the normal incidence response
            directivity = normMe( abs(unprocessed_directivity(:,1)) );
            
        case 'normalise'
            % normalized to the maximum value in the normal incidence
            % response (stops horizontal bands from 0's in the
            % normalization) - most values will be between 0 and 1
            max_normal_incidence = max(...
                abs(unprocessed_directivity(:,1)) );
            directivity = abs(unprocessed_directivity) ...
                ./ max_normal_incidence;
            
        otherwise
            % otherwise output unprocessed
            obj.getDirectivity('normalise');
    end
    
 
end