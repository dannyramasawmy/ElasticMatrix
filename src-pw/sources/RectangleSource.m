classdef RectangleSource < Source
    %RECTANGLESOURCE Class definition for RECTANGLESOURCE.
    %
    % DESCRIPTION
    %   RECTANGLESOURCE overrides the Source.sampleSource() method, see
    %   Source class for more details.
    %
    %
    % USEAGE
    %   my_source = RectangleSource(varargin);
    %   my_source = RectangleSource(source_length);
    %   my_source = RectangleSource(source_length, steering_angle);
    %   my_source = RectangleSource(source_length, steering_angle, amplitude);
    %
    %
    % INPUTS
    %   See Source definition.
    %
    %
    % OPTIONAL INPUTS
    %   See Source definition.
    %
    %
    % OUTPUTS
    %   RectangleSource object.
    %
    %
    % PROPERTIES
    %   See Source definition.
    %
    %
    % METHODS
    %   NON-STATIC
    %   obj = obj.sampleSource(sample_locations, frequency, sound_speed)
    %       Source sample overrides the Source.sampleSource method, and
    %       samples a rectangle. Additionally the frequency and sound_speed
    %       are used to set the phase for the given steering angle.
    %       - sample_locations     - A vector of sample locations. [m]
    %       - frequency            - The temporal frequency.       [Hz]
    %       - sound_speed          - The sound_speed of the medium.[m/s]
    %
    %
    %   See Source definition for additional methods.
    %  
    %
    % DEPENDENCIES
    %   handle          - Inherits the handle class in MALTAB.
    %   Source          - Inherits the Source class.
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
        function obj = RectangleSource(varargin)
            % call super class constructor
            obj = obj@Source(varargin{:});
            
            % set the type
            obj.setSourceType('Rectangle')
        end
        
        
        function obj = sampleSource(obj, sample_locations, frequency, sound_speed)
            % SAMPLESOURCE override the sampleSource method in the
            % superclass.
            %
            % For sample location x
            % 0 if x =< 0
            % 1 if 0 < x =< obj.source_length
            % 0 if obj.source_length < x
            
            % set the sampling properties (dx, length, locations)
            obj.setSamplingProperties(sample_locations)
            
            % define source function 
            source = zeros(1, obj.sample_N);
            mask = (obj.sample_locations > 0) & ...
                (obj.sample_locations <= obj.source_length);
            source(mask) = 1;
            
            % set the source magnitude
            obj.setComplexSource(source);
            
            % apply phase offset for steered beam
            obj.applyPhaseOffset(frequency, sound_speed);
        end
        
    end
    
end