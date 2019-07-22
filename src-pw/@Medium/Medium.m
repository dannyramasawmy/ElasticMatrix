classdef Medium < handle
    %MEDIUM - one line description
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
    %   handle class    - inherits the handle class in MALTAB
    %
    % PROPERTIES
    %
    %
    % METHODS
    %
    %
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - January  - 2019
    %   last update     - 21 - July     - 2019
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
    
    
    % properties
    properties (GetAccess = public, SetAccess = private)
        name
        state 
        thickness
        density
        stiffness_matrix
        slowness
    end
    
    
    methods
        function obj = Medium(varargin)
            %   Description
            %       Takes multiple material inputs and returns a multidimensional
            %       class (i.e it can be indexed like a structure).
            % Example:
            %   To generate a layered medium for a aluminium plate in water
            %   myMedium = Medium('water',Inf, 'aluminium',0.001, 'water',Inf)
            %
            
            % if there are multiple input arguments
            if nargin ~= 0
                
                % check if the inputs are even in length
                if mod(nargin,2)
                    error(['Incorrect number of inputs, type a material ',...
                        'name followed by its thickness (''glass'',0.01,...).']);
                end
                
                % create an object array (vector)
                object_length = nargin / 2;
                obj(object_length) = obj;
                
                % assign fields
                for idx = 1:2:nargin
                    obj((idx+1)/2) = Medium.getAcousticProperties(varargin{idx});
                    obj((idx+1)/2).thickness = varargin{idx + 1};
                end
                
                % auto set first layer thickness to Inf if not defined at the start
                if obj(1).thickness ~= Inf
                    obj.setThickness(1, Inf);
                end
                
                % auto set last layer thickness to Inf if not defined at the start
                number_layers = length(obj);
                if obj(number_layers).thickness ~= Inf
                    obj.setThickness(number_layers, Inf);
                end
                
            else
                % if there are no input arguments
                % null constructor
                obj.setName(1, '0');
                obj.setThickness(1, 1);
                obj.setDensity(1, 1);
                obj.setStiffnessMatrix(1, zeros(6));
                obj.state     = 'Unknown';
            end
            
        end
        
        % display
        obj = disp(obj);
        % set the name
        obj = setName(obj, layerIndex, layerName);
        % set the thickness
        obj = setThickness(obj, layerIndex, layerValue);
        % set the Density
        obj = setDensity(obj, layerIndex, layerDensity);
        % set the stiffness matrix
        obj = setStiffnessMatrix(obj, layerIndex, cMatrix);
        
        % calculate slowness profiles
        obj = calculateSlowness( obj );
        
        % plotting slowness
        [ figure_handle, obj] = plotSlowness( obj );
        
    end
    
    
    % static methods
    methods (Static)
        
        % show the available materials
        availableMaterials();
        % get the acoustic properties
        medium_object    = getAcousticProperties(materialName);
        % change lame coefficients to stiffness matrix
        stiffness_matrix = lameConversion(lambda, mu);
        % change sound speeds and density into a stiffness matrix
        stiffness_matrix = soundSpeedDensityConversion(compressionalSpeed, shearSpeed, density);
        
    end
    
    
end
