classdef Medium < handle
    %% Medium v1 date: 2019-01-15
    %
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Descriptions:
    %       Creates the medium for the partial wave method.
    %
    
    % properties
    properties (GetAccess = public, SetAccess = private)
        name
        state = '';
        thickness
        density
        stiffnessMatrix
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
                objectLength = nargin / 2;
                obj(objectLength) = obj;
                
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
                numberLayers = length(obj);
                if obj(numberLayers).thickness ~= Inf
                    obj.setThickness(numberLayers, Inf);
                end
                
            else
                % if there are no input arguments
                % null constructor
                obj.name      = 0;
                obj.thickness = 0;
                obj.density   = 0;
                obj.stiffnessMatrix      = zeros(6);
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
        [ figureHandle, obj] = plotSlowness( obj );
        
    end
    
    
    % static methods
    methods (Static)
        
        % show the available materials
        availableMaterials();
        % get the acoustic properties
        mediumObject    = getAcousticProperties(materialName);
        % change lame coefficients to stiffness matrix
        stiffnessMatrix = lameConversion(lambda, mu);
        % change sound speeds and density into a stiffness matrix
        stiffnessMatrix = soundSpeedDensityConversion(compressionalSpeed, shearSpeed, density);
        
    end
    
    
end
