classdef FabryPerotSensor < ElasticMatrix
    %% FabryPerotSensor v1 date: 2019-05-14
    %
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Descriptions:
    %       Models the FabryPerot ultrasound sensor.
    
    properties (SetAccess = private, GetAccess = public)
        mirrorLocations                 % locations of the FP mirrors
        spotSize                        % size of interrogation spot
        spotType                        % Gaussian or collimated beam
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
        obj = setMirrorLocations(   obj, interfaceLocations );
        % set the interrogation spot size
        obj = setSpotSize(          obj, spotDiameter       );
        % set the spot type (gaussian or collimated)
        obj = setSpotType(          obj, spotType           );
        
        % calculate the directivity
        obj = calculateDirectivity( obj );   % FINDME : NOT FULLY IMPLEMENTED
 
        % get directivity with different processinf
        [directivity,   obj] = getDirectivity(  obj, varargin   ); 
        [figHandles,    obj] = plotDirectivity( obj, varargin   ); 
        
        % display method
        obj = disp(obj);
    end
    
end