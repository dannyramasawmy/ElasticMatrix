classdef ElasticMatrix < handle
    %FUNCTIONTEMPLATE - one line description
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
    % PROPERTIES
    %
    %
    % METHODS
    %
    %   For information on the methods type:
    %       help ElasticMatrix.<method_name>
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
        medium                         % Medium class oject
        partial_wave_amplitudes        % partial wav
        amplitudes
        x_displacement                  % x-displacement at interface
        z_displacement                  % z-displacement at interface
        sigma_zz                        % normal stress at interface
        sigma_xz                        % shear stress at interface
        dispersion_curves               % coordinates of dispersion curve
        
        % a temporary field - if users wish to add features / check
        % implementations this can be used to extract data while the model
        % runs
        temp
    end
    
    properties (SetAccess = private, GetAccess = private)
        temp_feature                    % temporary variable for features
        unnormalised_amplitudes         % unormalised partial wave amplitudes
        
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
        obj = plotRTCoefficients(obj);
        
        % other
        obj = disp(obj);
        obj = save(obj, varargin);
        
        
        
    end
    
end