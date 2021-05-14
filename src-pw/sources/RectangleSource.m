classdef RectangleSource < Source
    %MEDIUM Class definition for Medium.
    %
    % DESCRIPTION
    %   SOURCEINTERFACE is an abstract class for describing a source term.
    %   Concrete classes must implement the .x_sample method.
    %
    %
    % USEAGE
    %   Abstract class cannot be instantiated.
    %
    %
    % INPUTS
    %   []              - No required inputs.           []
    %
    %
    % OPTIONAL INPUTS
    %   None.
    %
    %
    % OUTPUTS
    %   Source object.
    %
    %
    % PROPERTIES
    % (GetAccess = public, SetAccess = private)
    %
    %
    % METHODS
    %   ABSTRACT
    %
    %   For information on the methods type:
    %       help SourceInterface.<method_name>
    %
    %
    % DEPENDENCIES
    %   handle          - Inherits the handle class in MALTAB.
    %
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 11 - May          - 2021
    %   last update     - 14 - May          - 2021
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
    
    methods
        % constructor
        function obj = RectangleSource(varargin)
            % call super class constructor
            obj = obj@Source(varargin{:});
            
            % set the name
            obj.setSourceType('Rectangle')
        end
        
        
        % override the sampleSource method in the super class
        function obj = sampleSource(obj, sample_locations, frequency, sound_speed)
            
            obj.setSamplingProperties(sample_locations)
            
            
            source = zeros(1, obj.sample_N);
            
            mask = (obj.sample_locations > 0) & ...
                (obj.sample_locations < obj.source_length);
            source(mask) = 1;
            
            obj.setComplexSource(source);
            
            obj.applyPhaseOffset(frequency, sound_speed);
            
     

        end
        
    end
    
end