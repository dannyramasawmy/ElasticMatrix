classdef ElasticMatrix < handle
    %% ElasticMatrix v1 date: 2019-01-15
    %
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Descriptions:
    %       This class evaluates a multilayered medium
    
    % open properties
    properties (SetAccess = public, GetAccess = public)
        filename
        frequency                       % frequency range
        angle                           % angle range
        wavenumber                      % wavenumber range
        phasespeed                      % phase_speed range
    end
    
    % closed properties
    properties (SetAccess = private, GetAccess = public)
        medium                          % Medium class oject
        partialWaveAmplitudes         % partial wave amplitudes
        xDisplacement                  % x-displacement at interface
        zDisplacement                  % z-displacement at interface
        sigmaZZ                        % normal stress at interface
        sigmaXZ                        % shear stress at interface
        dispersionCurves               % coordinates of dispersion curve
        
        % add a temporary field to check calcualtions
        temp
    end
    
    properties (SetAccess = private, GetAccess = private)
        tempFeature                    % temporary variable for features
        unnormalisedAmplitudes         % unormalised partial wave amplitudes
        
    end
    
    
    methods
        
        % constructor
        function obj = ElasticMatrix(varargin)
            
            % decide on inputs
            switch nargin
                case 1
                    % check medium class and assign property
                    if class(varargin{1}) == 'Medium'
                        obj.setMedium(varargin{1});
                    end
                    
                otherwise
                    warning(['Please provide a Medium object to initalise class,',...
                        ' type help ElasticMatrix for more inofrmation']);
                    
                    % predefined example
                    disp('... plate-example ...')
                    
                    % make the example medium
                    exampleMedium      = Medium.generateLayeredMedium(...
                        'vacuum',0,'aluminium',0.001,'vacuum',1);
                    
                    %set properties
                    obj.setMedium(exampleMedium);
                    obj.setFilename('PlateExample');
                    obj.setFrequency(linspace(0.1e6,5e6,100));
                    obj.setAngle(linspace(0,45,100));
            end
        end
        
        % set properties
        obj = setFilename(     obj, filename          );
        obj = setFrequency(    obj, frequencyRange    );
        obj = setAngle(        obj, angleRange        );
        obj = setWavenumber(   obj, wavenumberRange   );
        obj = setPhasespeed(   obj, phasespeedRange   );
        obj = setMedium(       obj, medium            );
        
        % run model
        obj = calculate(obj);
        
        % fabry-perot directivity
        [directivity,   obj]  = calculateDirectivity(  obj, mirrorLocation);
        [figHandle,    obj]   = plotDirectivity(       obj, varargin);
        
        % calculate dispersion curves
        obj = calculateDispersionCurves(obj);
        obj = calculateDispersionCurvesR(obj);
        obj = calculateDispersionNew(obj);
        
        % plot / calculate displacement field
        [field, obj] = displacementField(obj, angleChoice, freqChoice, varargin);
        
        % plotting
        obj = plotDispersionCurves(obj);       % NOT YET IMPLEMENTED
        obj = plotInterfaceParameters(obj);    % NOT YET IMPLEMENTED
        obj = plotRCoefficients(obj);
        obj = disp(obj);
        obj = save(obj, varargin);
        
        
        
    end
    
end