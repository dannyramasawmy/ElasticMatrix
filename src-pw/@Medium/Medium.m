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
        cMat 
        slowness
    end
    
    
    methods 
        function obj = Medium(varargin)
              obj.name      = 0;
              obj.thickness = 0;
              obj.density   = 0;
              obj.cMat      = zeros(6);
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
        obj = setCMatrix(obj, layerIndex, cMatrix);
        
        % calculate slowness profiles
        obj = calculateSlowness( obj ); 
        
        % plotting slowness
        [ figureHandle, obj] = plotSlowness( obj );  
        
    end
    
    
    % static methods
    methods (Static)
        
        % show the available materials
        availableMaterials();     
        % returns a multidimensional medium object
        mediumObject    = generateLayeredMedium(varargin);       
        % get the acoustic properties
        mediumObject    = getAcousticProperties(materialName);              
        % change lame coefficients to stiffness matrix
        stiffnessMatrix = lameConversion(lambda, mu);    
        % change sound speeds and density into a stiffness matrix
        stiffnessMatrix = soundSpeedDensityConversion(compressionalSpeed, shearSpeed, density);
        
    end
    
    
end
