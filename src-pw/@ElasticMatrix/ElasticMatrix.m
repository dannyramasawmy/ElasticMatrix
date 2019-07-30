classdef ElasticMatrix < handle
    %FUNCTIONTEMPLATE - one line description
    %
    % DESCRIPTION
    %   Description coming soon...
    %
    %
    % USEAGE
    %   model = ElasticMatric(medium_object);
    %
    %
    % INPUTS
    %   medium_object   - The ElasticMatrix class is initialized with a
    %                     Medium object.
    %
    %
    % OPTIONAL INPUTS
    %   []              - There are no optional inputs. 
    %
    %
    % OUTPUTS
    %   model           - An ElasticMatrix object.      
    %
    %
    % PROPERTIES
    % (SetAccess = private, GetAccess = public)
    %   .filename                   - Filename for saving the object.
    %   .frequency                  - A range of frequencies.   [Hz]
    %   .angle                      - A range of angles.        [degree]
    %   .wavenumber                 - A range of wave-numbers.  [1/m]
    %   .phasespeed                 - A range of phase speeds.  [m/s]
    %
    %   .medium                     - A Medium object.
    %   .partial_wave_amplitudes    - Partial wave amplitudes.
    %   .x_displacement             - x-displacement at each interface.
    %   .z_displacement             - z-displacement at each interface.
    %   .sigma_zz                   - Normal stress at each interface.
    %   .sigma_xz                   - Shear stress at interface.
    %   .dispersion_curves          - Dispersion curve data.
    %
    %   .temp                       - A temporary property for users to
    %                                 test functionality.
    %
    % (SetAccess = private, GetAccess = private)
    %   .unnormalised_amplitudes    - Unnormalized partial wave amplitudes.
    %
    %
    % METHODS
    %   NON-STATIC
    %   obj = obj.setFilename(filename);
    %       Sets the .filename property.
    %       - filename      - A filename for when the object is saved to
    %                         disk.
    %
    %   obj = obj.setFrequency(frequency_range);
    %       Sets the .frequency property.
    %       - frequency_range   - A vector of frequencies to calculate the
    %                             partial wave method over. [Hz]
    %
    %   obj = obj.setAngle(angleRange);
    %       Sets the .angle property.
    %       - frequency_range   - A vector of frequencies to calculate the
    %                             partial wave method over. [Hz]
    %
    %   obj = obj.setWavenumber(wavenumber_range);
    %       Sets the .wavenumber property.
    %       - wavenumber_range  - A vector of wave-numbers to calculate the
    %                             partial wave method over. [Hz]
    %
    %   obj = obj.setPhasespeed(phasespeed_range);
    %       Sets the .phasespeed property.
    %       - phasespeed_range  - A vector of phase-speeds to calculate the
    %                             partial wave method over. [Hz]
    %
    %   obj = obj.setMedium(medium);
    %       Sets the .medium property.
    %       - medium            - Must be a Medium object.
    %
    %   obj = obj.calculate;
    %       Calculates the partial wave method over a range of frequencies,
    %       angles, phase-speeds and wave-numbers.
    %       There are no inputs or outputs, however, these properties are
    %       set:
    %       - .partial_wave_amplitudes    
    %       - .x_displacement             
    %       - .z_displacement             
    %       - .sigma_zz                   
    %       - .sigma_xz                   
    %
    %   obj = obj.calculateDispersionCurvesCoarse;
    %       Calculates the dispersion curves using the coarse method.
    %       There are no inputs or outputs, however, these properties are
    %       set:
    %       - obj.dispersion_curves
    %
    %   obj = obj.calculateDispersionCurves;
    %       There are no inputs or outputs, however, these properties are
    %       set:
    %       - obj.dispersion_curves
    %
    %   [field, obj] = obj.calculateField(...
    %       angle_choice, frequency_choice, varargin);
    %       Calculates the displacement and stress fields within the
    %       multi-layered structure.
    %       - frequency_choice      - Choice of frequency.  [Hz]
    %       - angle_choice          - Choice of angle.      [degrees]
    %       - field                 - Structure with the calculated fields:
    %           - field.z_vector        - 1D vector of z-range.        [m]
    %           - field.x_vector        - 1D vector of x-range.        [m]
    %           - field.x_displacement  - 2D matrix of x-displacements.[m]
    %           - field.z_displacement  - 2D matrix of z-displacements.[m]
    %           - field.sigma_zz        - 2D matrix of normal stress.  [Pa]
    %           - field.sigma_xz        - 2D matrix of shear stress.   [Pa]
    %
    %   [figure_handle, obj] = obj.plotDispersionCurves;
    %       FIND ME
    %
    %   [figure_handle, obj] = obj.plotInterfaceParameters;
    %       Plots the displacement and stress at the interfaces.
    %       - figure_handle   - Figure handle structure, with a new field 
    %                           for each interface.
    %
    %   [figure_handle, obj] = obj.plotField(field, varargin);
    %       Plots the displacement and/or stress fields.
    %       - field                 - Structure with the calculated fields:
    %           - field.z_vector        - 1D vector of z-range.        [m]
    %           - field.x_vector        - 1D vector of x-range.        [m]
    %           - field.x_displacement  - 2D matrix of x-displacements.[m]
    %           - field.z_displacement  - 2D matrix of z-displacements.[m]
    %           - field.sigma_zz        - 2D matrix of normal stress.  [Pa]
    %           - field.sigma_xz        - 2D matrix of shear stress.   [Pa]  
    %       - varargin
    %           'displacement1D'    - x and z displacement along x = 0, z =
    %                                 z_vector.
    %           'displacement2D'    - x and z displacement over the grid
    %                                 defined by z_vector and x_vector
    %           'stress1D'          - normal and shear stress along x = 0, 
    %                                 z = z_vector.
    %           'stress2D'          - Normal and shear stress over the grid
    %                                 defined by z_vector and x_vector.
    %           'vector'            - 2D vector field over the grid defined 
    %                                 by x_vector and z_vector, 
    %                                 displacement.
    %           'mesh'              - 2D mesh field over the grid defined 
    %                                 by x_vector and z_vector.
    %           'surf'              - 3D surface plot of normal stress
    %                                 over the grid defined by z_vector and
    %                                 x_vector.
    %           'all'               - Plots all of the above.
    %           - figure_handle     - Varagin can be a figure handle.
    %       - figure_handle         - figure handle for each figure plotted
    %                                 is returned as a structure with
    %                                 (self-explanatory) fields:
    %           - figure_handle.displacement1D
    %           - figure_handle.displacement2D
    %           - figure_handle.stress1D
    %           - figure_handle.stress2D
    %           - figure_handle.vector
    %           - figure_handle.mesh
    %           - figure_handle.surf
    %           - figure_handle.all
    %
    %   [figure_handle, obj] = obj.plotRTCoefficients;
    %       Plots the reflection and transmission coefficients (for the
    %       first and last layer in the mulit-layer structure).
    %       - figure_handle     - A figure handle to the plot.
    %
    %   obj = obj.disp;
    %       Prints the properties of ElasticMatrix to the command window.
    %       - There are no inputs or outputs.
    %
    %   obj = obj.save(varargin);
    %       Saves the ElasticMatrix object to disk. This will save any data
    %       associated with the properties.
    %       - varargin      - Filename to assign the ElasticMatrix object.      
    %
    %
    %   STATIC
    %   - No static methods.
    %
    %   For information on the methods type:
    %       help ElasticMatrix.<method_name>
    %
    %
    % DEPENDENCIES
    %   Medium          - This class is initialized with a Medium object.
    %   handle          - ElasticMatrix uses the MATLAB handle class.
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - January  - 2019
    %   last update     - 31 - July     - 2019
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
    properties (SetAccess = private, GetAccess = public)
        % properties set by the user
        filename
        frequency                   % frequency range
        angle                       % angle range
        wavenumber                  % wavenumber range
        phasespeed                  % phase_speed range
        
        % properties set by ElasticMatrix 
        medium                      % Medium class object
        partial_wave_amplitudes     % partial wave amplitudes
        %amplitudes                      
        x_displacement              % x-displacement at interface
        z_displacement              % z-displacement at interface
        sigma_zz                    % normal stress at interface
        sigma_xz                    % shear stress at interface
        dispersion_curves           % coordinates of dispersion curve
       
        temp                        % temporary property
    end
    
    properties (SetAccess = private, GetAccess = private)
        unnormalised_amplitudes     % unormalised partial wave amplitudes
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
                    if isa(varargin{1},'Medium')
                        obj.setMedium(varargin{1});
                        
                    else
                        warning(['Please provide a Medium object',...
                            ' to initalise ElasticMatrix.']);
                        
                        % default medium constructor
                        obj.medium = Medium;
                    end
            end
        end
        
        % set properties
        obj = setFilename(     obj, filename          );
        obj = setFrequency(    obj, frequency_range    );
        obj = setAngle(        obj, angle_range        );
        obj = setWavenumber(   obj, wavenumber_range   );
        obj = setPhasespeed(   obj, phasespeed_range   );
        obj = setMedium(       obj, medium            );
        
        % run model
        obj = calculate(obj);
        
        % calculate dispersion curves
        obj = calculateDispersionCurvesCoarse(obj);
        % obj = calculateDispersionCurvesR(obj); % from |R|
        obj = calculateDispersionCurves(obj);
        
        % plot / calculate displacement field
        [field, obj] = calculateField(obj, ...
            angle_choice, frequency_choice, varargin);
        
        % plotting
        [figure_handle, obj] = plotDispersionCurves(obj);
        [figure_handle, obj] = plotInterfaceParameters(obj);
        [figure_handle, obj] = plotField(obj, field, varargin);
        [figure_handle, obj] = plotRTCoefficients(obj);
        
        % other
        obj = disp(obj);
        obj = save(obj, varargin);
        
        
        
    end
    
end