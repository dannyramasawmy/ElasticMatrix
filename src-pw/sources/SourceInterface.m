classdef SourceInterface < handle
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
    
    properties (GetAccess = public, SetAccess = private)
        type
        source_length
        amplitude
    end
    
   
    methods (Abstract)
        [vector] = sample(obj, x)
    end
    
    methods (Access = protected, Hidden = true)
        function obj = setSourceType(obj, source_type)
            obj.type = source_type;
        end
    end
        
    methods
        function obj = setSourceLength(obj, source_length)
            obj.source_length = source_length;
        end
        
        function obj = setSourceAmplitude(obj, amplitude)
            obj.amplitude = amplitude;
        end
        
        function plot(obj)
            figure;
            tmp = linspace(-obj.source_length, obj.source_length*2);
            plot(tmp, obj.sample(tmp))
            xlabel('X')
            ylabel('Amplitude')
            title(['Source: ', obj.type])
        end
    end
end