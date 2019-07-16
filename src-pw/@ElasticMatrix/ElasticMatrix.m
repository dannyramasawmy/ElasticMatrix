classdef ElasticMatrix < handle
    %% ElasticMatrix v1` date: 2019-01-15
    %
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Descriptions:
    %       This class evaluates a multilayered medium using the partial
    %       wave method
    
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
        partialWaveAmplitudes           % partial wav
        amplitudes
        xDisplacement                  % x-displacement at interface
        zDisplacement                  % z-displacement at interface
        sigmaZZ                        % normal stress at interface
        sigmaXZ                        % shear stress at interface
        dispersionCurves               % coordinates of dispersion curve
        
        % a temporary field - if users wish to add features / check
        % implementations this can be used to extract data while the model
        % runs
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
                case 0
                    % null constructor - null medium
                    obj.medium = Medium;
                    
                otherwise
                    % check medium class and assign property
                    if class(varargin{1}) == 'Medium'
                        obj.setMedium(varargin{1});
                        
                    else          
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
        
        % calculate dispersion curves
        obj = calculateDispersionCurvesCoarse(obj);
        % obj = calculateDispersionCurvesR(obj); % from |R|
        obj = calculateDispersionCurves(obj);
        
        % plot / calculate displacement field
        [field, obj] = calculateField(obj, angleChoice, freqChoice, varargin);
        
        % plotting
        obj = plotDispersionCurves(obj);
        obj = plotInterfaceParameters(obj);
        obj = plotField(obj, fieldValues, varargin);
        obj = plotRCoefficients(obj);
        
        % other
        obj = disp(obj);
        obj = save(obj, varargin);
        
        
        
    end
    
end