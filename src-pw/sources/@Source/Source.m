classdef Source < handle
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
    %   last update     - 11 - May          - 2021
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
    
    properties (GetAccess = public, SetAccess = private)
        type
        source_length = 1;
        steering_angle = 0;
        amplitude = 1;
        complex_source
    end
    
    properties (GetAccess = protected, SetAccess = private)
        sampling_dx;
        sampling_N;
        sampling_locations;
    end
    
    
    
    methods
        function obj = Source(varargin)
            
            obj.setSourceType('Default');
                   
            switch nargin
                case {0}
                    % do nothing
                case {1}
                    obj.setSourceLength(varargin{1});       % [m]
                    
                case {2}
                    obj.setSourceLength(varargin{1});       % [m]
                    obj.setSteeringAngle(varargin{2});      % [deg]
                    
                case {3}
                    obj.setSourceLength(varargin{1});       % [m]
                    obj.setSteeringAngle(varargin{2});      % [deg]
                    obj.setSourceAmplitude(varargin{3});    % [Pa]
                                
                otherwise
                    error('Inncorrect number of inputs.')
                    
            end
        end
        
        function obj = sampleSource(obj, sample_locations, frequency, sound_speed)
            obj.setSamplingProperties(sample_locations)
            
            obj.setComplexSource(zeros(1, obj.sampling_N));
            
            obj.applyPhaseOffset(frequency, sound_speed);
        end
        
        
        function source = getComplexSource(obj)
            source = obj.complex_source;
        end
        
        function obj = setSourceLength(obj, source_length)
            obj.source_length = source_length;
            
            % reset source
            obj.resetSamplingProperties;
            
        end
        
        function obj = setSteeringAngle(obj, steering_angle)
            obj.steering_angle = steering_angle;
            
            % reset source if sampled
            obj.resetSamplingProperties;
        end
        
        function obj = setSourceAmplitude(obj, amplitude)
            obj.amplitude = amplitude;
            
            % reset source if sampled
            obj.resetSamplingProperties;
        end
        
        
        function plot(obj)
            figure;
            plot(obj.sampling_locations, abs(obj.complex_source))
            hold on
            plot(obj.sampling_locations, angle(obj.complex_source))
            hold off
            % labels
            xlabel('X')
            ylabel('Amplitude')
            title(['Source: ', obj.type])
            legend('Magnitude', 'Phase')
        end
    end
    
    
    methods (Access = protected, Hidden = true)
        function obj = setSourceType(obj, source_type)
            obj.type = source_type;
        end
        
        function obj = applyPhaseOffset(obj, frequency, sound_speed)
            
            % get sample points information
            N = obj.sampling_N;
            dx = obj.sampling_dx;
            
            % calculate the phase offset
            phase_offset = 2 * pi * frequency * (0:N-1)*dx * ...
                sind(obj.steering_angle) / sound_speed;
            
            % set phase offset
            source = obj.amplitude * obj.complex_source ...
                .* exp(1i .* phase_offset);
            obj.setComplexSource(source);
        end
        
        function obj = setSamplingProperties(obj, x_vector)
            obj.sampling_dx = abs(x_vector(2) - x_vector(1));
            obj.sampling_N = length(x_vector);
            obj.sampling_locations = x_vector;
        end
        
        function obj = resetSamplingProperties(obj)
            
            if ~isempty(obj.complex_source)
                warning('Current source will be reset')
            end
            
            obj.sampling_dx = [];
            obj.sampling_N = [];
            obj.sampling_locations = [];
            obj.complex_source = [];
        end
        
        function obj = setComplexSource(obj, complex_source)
            obj.complex_source = complex_source;
        end
        
        
    end
    
    
end