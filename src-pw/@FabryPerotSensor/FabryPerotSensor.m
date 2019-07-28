classdef FabryPerotSensor < ElasticMatrix
    %FABRYPEROTSENSOR - one line description
    %
    % DESCRIPTION
    %   A short description of the functionTemplate goes here.
    %
    % USEAGE
    %   outputs = functionTemplate(input, another_input)
    %   outputs = functionTemplate(input, another_input, optional_input)
    %
    % INPUTS
    %   input           - the first input   [units]
    %
    % OPTIONAL INPUTS
    %   []              - there are no optional inputs []
    %
    % OUTPUTS
    %   outputs         - the outputs       [units]
    %
    % DEPENDENCIES
    %   []              - there are no dependencies     []
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - January  - 2019
    %   last update     - 28 - July     - 2019
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
    
    properties (SetAccess = private, GetAccess = public)
        mirror_locations                 % locations of the FP mirrors
        spot_diameter                    % size of interrogation spot
        spot_type                        % Gaussian or collimated beam
    end
    
    properties (SetAccess = private, GetAccess = private)
        directivity                     % directional response of sensor (complex)
    end
    
    methods
        % constructor
        function obj = FabryPerotSensor(varargin)
            
            % decide on inputs
            switch nargin
                case 1
                    % check medium class and assign property
                    if class(varargin{1}) == 'Medium'
                        obj.setMedium(varargin{1});
                    end
                    
                otherwise
                    warning(['Please provide a Medium object to initalise class,',...
                        ' type help FabryPerotSensor for more inofrmation']);
                    
                    % predefined example
                    disp('... glass etalon example ...')
                    
                    % make the example medium
                    exampleMedium      = Medium.generateLayeredMedium(...
                        'water',0,'glass',200e-6,'air',1);
                    
                    %set properties
                    obj.setMedium(exampleMedium);
                    obj.setFilename('GlassEtalonExample');
                    obj.setFrequency(linspace(0.1e6,100e6,100));
                    obj.setAngle(linspace(0,45,100));
                    obj.setMirrorLocations([1 2]);
            end
        end
        
        % set the interface locations of the mirrors
        obj = setMirrorLocations(   obj, interface_locations );
        % set the interrogation spot size
        obj = setSpotDiameter(      obj, spot_diameter       );
        % set the spot type (gaussian or collimated)
        obj = setSpotType(          obj, spot_type           );
        
        % calculate the directivity
        obj = calculateDirectivity( obj );
        
        % get directivity data and plot
        [directivity,   obj] = getDirectivity(  obj, varargin   );
        [fig_handles,   obj] = plotDirectivity( obj, varargin   );
        
        % display method
        obj = disp(obj);
    end
    
end