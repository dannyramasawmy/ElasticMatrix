classdef Medium < handle
    %MEDIUM Class definition for Medium.
    %
    % DESCRIPTION
    %   MEDIUM defines the geometry and material properties for a
    %   multi-layered elastic structure [1,2]. The multi-layered structure
    %   consists of n-rigidly bonded elastic layers with parallel
    %   interfaces between adjacent layer's. Each layer defines a name,
    %   thickness and material constants (such as density, stiffness
    %   coefficients) are defined. The diagram of the multi-layered
    %   structure can be seen below. The interfaces are perpendicular to
    %   the (z)-axis and parallel to the (x,y) plane. The first and last
    %   layers are semi-infinite in (z) whereas the "sandwiched" layers are
    %   finite in (z). Note for n-layers there are n-1 interfaces.
    %
    %   ^ z
    %   |
    %   |(Layer 1), material_1, thickness_1, material_properties_1
    %   |------------------------ interface 1 ----------------------
    %   |(Layer 2), material_2, thickness_2, material_properties_2
    %   |------------------------ interface 2 ----------------------
    %   |                            ...
    %   |------------------------ interface n-1 --------------------
    %   |(Layer n), material_n, thickness_n, material_properties_n
    %   |------------------------------------------------------------> x
    %
    %   The material properties include the density [kg/m^3] and the
    %   stiffness coefficients [Pa]. The stiffness coefficients are in the
    %   form of a 6X6 stiffness matrix. The materials that have been
    %   predefined can be seen by typing:
    %       Medium.availableMaterials;
    %   New materials can be added to the list and defined by typing:
    %       edit materialList.
    %   More information as to the accepted format can be seen in the
    %   description of this function.
    %
    %   References:
    %   [1] Ramasawmy, Danny R., et al. "ElasticMatrix: A MATLAB Toolbox
    %       for Anisotropic Elastic Wave Propagation in Layered Media.",
    %       (2019).
    %
    %   [4] Nayfeh, Adnan H. "The general problem of elastic wave
    %       propagation in multi-layered anisotropic media." The Journal of
    %       the Acoustical Society of America (1991).
    %
    %
    % USEAGE
    %   medium_object = Medium;
    %   medium_object = Medium( 'material_1', thickness_1,...
    %       'material_3', thickness_2,...,'material_n', thickness_n);
    %
    %
    % INPUTS
    %   []              - No required inputs.           []
    %
    %
    % OPTIONAL INPUTS
    %   Medium accepts any number of inputs in groups of two in the form:
    %   material_name, material_thickness,...
    %   material_name       - A string of the material name from the
    %                         predefined materials. See materialList(). For
    %                         materials that have not been defined it may
    %                         be set as 'blank'.
    %   material_thickness  - The thickness of the layer.       [m]
    %
    %
    % OUTPUTS
    %   medium_object       - A Medium object.                  []
    %
    %
    % PROPERTIES
    % (GetAccess = public, SetAccess = private)
    %   .name               - The material name.
    %   .thickness          - The thickness of the material.    [m]
    %   .density            - The density of the material.      [kg/m^3]
    %   .stiffness_matrix   - The stiffness matrix of the material. [Pa]
    %   .slowness           - The slowness profiles of the materials.
    %       .slowness.kx         - Horizontal component (vector).
    %       .slowness.kz_qL1     - (quasi-)L  vertical component -ve.
    %       .slowness.kz_qL2     - (quasi-)L  vertical component +ve.
    %       .slowness.kz_qSV1    - (quasi-)SV vertical component -ve.
    %       .slowness.kz_qSV2    - (quasi-)SV vertical component +ve.
    %       .slowness.kz_qSH     - (quasi-)SH vertical component +ve.
    %
    %
    % METHODS
    %   NON-STATIC
    %   
    %   obj = obj.disp;
    %       Displays the properties of Medium.
    %       - There are no inputs.
    %
    %   obj = obj.setName(layer_index, layer_name);
    %       Sets the .name property.
    %       - layer_index       - The index of the layer.
    %       - layer_name        - A string of the new name.
    %
    %   obj = obj.setThickness(layer_index, layer_value);
    %       Sets the .thickness property.
    %       - layer_index       - The index of the layer.
    %       - layer_value       - The thickness of the layer. [m]
    %
    %   obj = obj.setDensity(layer_index, layer_density);
    %       Sets the .density property.
    %       - layer_index       - The index of the layer.
    %       - layer_density     - The density of the layer. [kg/m^3]
    %
    %   obj = obj.setStiffnessMatrix(layer_index, stiffness_matrix);
    %       Sets the .stiffness_matrix property.
    %       - layer_index       - The index of the layer.
    %       - stiffness_matrix  - Stiffness matrix, [6 X 6]. [Pa]
    %
    %   material_state  = obj.state;  
    %       Returns a string of the material state. This might be a cell of
    %       strings, or a single string of: Vacuum,Gas,Liquid,Isotropic,
    %       Anisotropic.
    %       - material_state    - (Liquid/Isotropic/...).
    %              
    %   obj = plus(medium_1, medium_2);
    %       Adds two Medium objects.
    %       - medium_1          - Medium object.
    %       - medium_2          -  Medium object.
    %
    %   obj = times(value, medium_1);
    %       Repeats medium_1 the number of times of value. Useful for
    %       periodic structures.
    %       - value             - Number of repetitions.
    %       - medium_1          - medium object,
    %
    %   obj = mtimes(value, medium_1);
    %       Repeats medium_1 the number of times of value. Useful for
    %       periodic structures.
    %       - value             - Number of repetitions.
    %       - medium_1          - medium object,
    %
    %   obj = obj.calculateSlowness;
    %       Calculates the slowness profiles for each material.
    %       - There are no inputs.
    %
    %   [ figure_handle, obj] = obj.plotSlowness;
    %       Plots the slowness curves.
    %       - figure_handle     - The figure handles for each slowness 
    %                             plot.
    %
    %   STATIC
    %   
    %   [] = Medium.availableMaterials();
    %       Prints a list of all available materials to the command window.
    %       - There are no inputs or outputs.       
    %
    %   medium_object = Medium.getAcousticProperties(material_name);
    %       Uses the materialList() function to return the properties for a
    %       selected material.
    %       - material_name       - A string of the material name.
    %       - medium_object       - Returns a Medium object.
    %
    %   stiffness_matrix = Medium.lameConversion(lambda, mu);
    %       Converts the material Lame parameters to a [6 X 6] stiffness
    %       matrix.
    %       - lambda              - The first lame parameter.     [Pa]
    %       - mu                  - The second lame parameter.    [Pa]
    %       - stiffness_matrix    - [6X6] stiffness matrix.       [Pa]
    %
    %   stiffness_matrix = Medium.soundSpeedDensityConversion(...
    %             compressional_speed, shear_speed, density);
    %       Converts compressional sound-speed, shear-speed and density to
    %       a [6 X 6] stiffness matrix.
    %       - compressional_speed   - Compressional sound-speed.   [m/s]
    %       - shear_speed           - Shear sound-speed.           [m/s]
    %       - density               - Density.                     [kg/m^3]
    %       - stiffness_matrix      - [6X6] stiffness matrix.      [Pa]
    %
    %    [ alpha_coefficients, stiffness_matrix, polarisation, sh_coeffs ] = ...
    %       calculateAlphaCoefficients(...
    %       stiffness_matrix, phase_velocity, density );
    %       Calculates wave-vectors and polarizations.
    %       - stiffness_matrix      - Material stiffness matrix.   [Pa]
    %       - phase_velocity        - Phase velocity.              [m/s]
    %       - density               - The material density.        [kg/m^3]
    %       - alpha_coefficients    - The ratio of vertical to horizontal
    %                                 wave-numbers. There are 4 alpha
    %                                 coefficients returned corresponding
    %                                 to upward and downward traveling
    %                                 q(L), q(SV) waves.
    %       - stiffness_matrix      - Either the [6x6] stiffness matrix 
    %                                 [Pa] or the lame coefficients in the
    %                                 form [lambda, mu].
    %       - polarisation          - Polarization vector for each
    %                                 alpha_coefficient.            []
    %       - sh_coeffs             - shear horizontal alpha coefficients. 
    %
    %
    %   For information on the methods type:
    %       help Medium.<method_name>
    %
    %
    % DEPENDENCIES
    %   handle          - Inherits the handle class in MALTAB.
    %   materialList    - Predefined materials are located in this
    %                     function.
    %
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - January      - 2019
    %   last update     - 11 - November     - 2019
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
        thickness
        density
        stiffness_matrix
        slowness
    end
    
    
    methods
        function obj = Medium(varargin)
            % if there are multiple input arguments
            if nargin ~= 0
                
                % check if the inputs are even in length
                if mod(nargin,2)
                    error('Incorrect number of inputs.');
                end
                
                % create an object array (vector)
                object_length = nargin / 2;
                obj(object_length) = obj;
                
                % assign fields
                for idx = 1:2:nargin
                    obj((idx+1)/2) = ...
                        Medium.getAcousticProperties(varargin{idx});
                    obj((idx+1)/2).thickness = varargin{idx + 1};
                end
                
                %{ 
                % auto set 1st layer thickness to Inf
                if obj(1).thickness ~= Inf
                    obj.setThickness(1, Inf);
                end
                
                % auto set n-th layer thickness to Inf
                number_layers = length(obj);
                if obj(number_layers).thickness ~= Inf
                    obj.setThickness(number_layers, Inf);
                end
                %}
                
            else
                % if there are no input arguments
                % null constructor
                obj.setName(1, '0');
                obj.setThickness(1, 1);
                obj.setDensity(1, 1);
                obj.setStiffnessMatrix(1, zeros(6));
            end
            
        end
        
        % display
        obj = disp(obj);
        % set the name
        obj = setName(obj, layer_index, layer_name);
        % set the thickness
        obj = setThickness(obj, layer_index, layer_value);
        % set the Density
        obj = setDensity(obj, layer_index, layer_density);
        % set the stiffness matrix
        obj = setStiffnessMatrix(obj, layer_index, stiffness_matrix);               
        % state
        state = state(obj);
                
        % overloaded functions
        % add two Medium objects
        obj = plus(obj1, obj2);
        % for periodic structures
        obj = times(value, obj2);
        % for periodic structures
        obj = mtimes(value,obj2)
             
        % calculate and plot slowness profiles
        obj = calculateSlowness( obj );
        [ figure_handle, obj] = plotSlowness( obj );

    end
    
    
    % static methods
    methods (Static)
        
        % show the available materials
        availableMaterials();
        % get the acoustic properties
        medium_object    = getAcousticProperties(material_name);
        % change lame coefficients to stiffness matrix
        stiffness_matrix = lameConversion(lambda, mu);
        % convert sound speeds and density into a stiffness matrix
        stiffness_matrix = soundSpeedDensityConversion(...
            compressional_speed, shear_speed, density);
        

    end
    
    % hidden static methods
    methods (Static, Hidden = true)

        % calculate alpha coefficients
        [ alpha_coefficients, stiffness_matrix, polarisation, sh_coeffs ] = ...
        calculateAlphaCoefficients( stiffness_matrix, phase_velocity, density );
    
    end
    
    
end
