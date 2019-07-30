classdef FabryPerotSensor < ElasticMatrix
    %FABRYPEROTSENSOR Class definition for FabryPerotSensor.
    %
    % DESCRIPTION
    %   FABRYPEROTSENSOR models the acoustic response of a Fabry-Perot
    %   ultrasound sensor. Fabry-Perot ultrasound sensors can detect
    %   ultrasound with a high sensitivity over a broadband frequency range
    %   (tens of MHz). It has frequently been used in photo-acoustic
    %   imaging and as a reference sensor for hydrophone calibration.
    %   Modeling the acoustic response of Fabry-Perot ultrasound sensors is
    %   useful for optimizing the design of the sensors and understanding
    %   the underlying physical mechanisms [1,2,3].
    %   
    %   The Fabry-Perot sensor detects ultrasound via interferometry. A
    %   diagram of the sensor is shown below (Note: the Fabry-Perot sensor
    %   is not restricted to 4-layers and may have more of less). Two
    %   partially-reflecting mirrors are separated by an optically
    %   transparent spacer and are deposited on a substrate backing. A
    %   laser interrogates the sensor from the substrate backing and is
    %   multiply-reflected between the two mirrors. The light-fields
    %   interfere and the intensity of the laser is measured from the
    %   substrate backing. The intensity of the reflected laser light is
    %   dependent on the laser wavelength and the distance between the
    %   mirrors (spacer thickness). When an acoustic wave is incident on
    %   the sensor the distance between the mirrors (optical cavity) is
    %   modulated and hence, the intensity of the reflected laser is
    %   modulated. The acoustic sensitivity is proportional to the change
    %   in cavity thickness [1,2,3].
    %
    %       water     (Layer 1)
    %   ------------------------ interface 1
    %       mirror    (Layer 2)
    %   ------------------------ interface 2
    %       spacer    (Layer 3)
    %   ------------------------ interface 3
    %       mirror    (Layer 4)
    %   ------------------------ interface 4
    %       substrate (Layer 5)
    %
    %   There is a complex wave-field in the sensor when an ultrasound wave
    %   is incident. This is due to the interaction of adjacent layers in
    %   the sensor. 
    %
    %   FABRYPEROTSENSOR inherits the ElasticMatrix class to model the
    %   interaction of an acoustic wave with the multi-layered elastic
    %   structure of the Fabry-Perot sensor. The geometry of the sensor is
    %   defined using the Medium class and the displacements of the mirrors
    %   and change in cavity thickness is calculated using the .calculate
    %   method of ELasticMatrix.
    %
    %   References:
    %   
    %   [1] Beard, P. "Transduction mechanisms of the Fabry-Perot polymer
    %       film sensing concept for wideband ultrasound detection"  IEEE
    %       transactions on ultrasonics, ferroelectrics, and frequency
    %       control, (1999).
    %
    %   [2] Cox, Benjamin T., and Paul C. Beard. "The frequency-dependent
    %       directivity of a planar Fabry-Perot polymer film ultrasound
    %       sensor." IEEE transactions on ultrasonics, ferroelectrics, and
    %       frequency control, (2007).
    %
    %   [3] Ramasawmy, Danny R., et al. "Analysis of the Directivity of
    %       Glass Etalon Fabry-Pérot Ultrasound Sensors." IEEE transactions
    %       on ultrasonics, ferroelectrics, and frequency control, (2019).
    %
    %
    % USEAGE
    %   sensor = FabryPerotSensor( medium_object );
    %
    %
    % INPUTS
    %   medium_object   - The class is initialized using a Medium object.
    %
    %
    % OPTIONAL INPUTS
    %   []              - There are no optional inputs. []
    %
    %
    % OUTPUTS
    %   sensor          - Returns a FabryPerotSensor object.
    %
    %
    % PROPERTIES
    % Please see ElasticMatrix to see all other methods.
    %
    % (SetAccess = private, GetAccess = public)
    %   .mirror_locations - (refer to figure above) the interface locations
    %                       of where the mirrors are. A vector:
    %                       [itfc_loc_1, itfc_loc_2].
    %   .spot_diameter    - Interrogation spot diameter.     [m]
    %   .spot_type        - Interrogation spot type, which can either be:   
    %                       - 'gaussian'
    %                       - 'collimated'
    %                       - 'none'
    %   
    %
    % (SetAccess = private, GetAccess = private) 
    %   .directivity    - The directional response of the Fabry-Perot
    %                     sensor. This is a matrix of complex data of size
    %                     [length_frequency_range x length_angle_range].
    %
    %
    % METHODS
    % Default constructor - initialize the FabryPerotSensor Class:
    %   sensor = FabryperotSensor( medium_object );
    %   
    %   obj = obj.setMirrorLocations([itfc_1, itfc_2])
    %       Sets the .mirror_locations property.
    %       - itfc_1        - The interface at the first mirror.
    %       - itfc_2        - The interface at the second mirror.
    %
    %   obj = obj.setSpotDiameter( diameter )
    %       Sets the .spot_diameter property.
    %       - diameter      - The spot diameter.     [m]
    %
    %   obj = obj.setSpotType( string )
    %       Sets the .spot_type property.
    %       string:
    %       - 'gaussian'
    %       - 'collimated'
    %       - 'none'
    %
    %   obj = obj.calculateDirectivity
    %       Calculates the directional response / acoustic sensitivity of
    %       the FabryperotSensor. Before using this the .setFrequency,
    %       .setAngle and .setMirrorLocations must be used.
    %       - There are no inputs to this method.
    %
    %
    %   [directivity, obj] = obj.getDirectivity(type)
    %       Returns the directional response with different types of
    %       processing/normalization.
    %       type:
    %       - 'raw'          - Calculated (complex) obj.directivity.
    %       - 'real'         - Imaginary part of obj.directivity.
    %       - 'imag'         - Real part of obj.directivity.
    %       - 'phase'        - Phase of obj.directivity.
    %       - 'abs'          - Absolute values of obj.directivity.
    %       - 'linear'       - Normalized to normal incidence response. 
    %       - 'decibel'      - Decibel scaling of 'linear'.
    %       - 'normalise'    - Normalize to maximum of normal incidence.
    %       - 'normal'       - Normal incidence response.
    %
    %
    %   [fig_handles, obj] = obj.plotDirectivity
    %   [fig_handles, obj] = obj.plotDirectivity(plot_type, plot_type,...)
    %       Plot the directional response of the Fabry-perot sensor.
    %       plot_type:
    %       - 'phase'        - Phase of obj.directivity.
    %       - 'linear'       - Normalized to normal incidence response.                        
    %       - 'decibel'      - Decibel scaling of 'linear'.
    %       - 'normalise'    - Normalized to maximum  of normal incidence.
    %       - 'normal'       - Normal incidence response.
    %       fig_handles      - Figure handles. 
    %
    %   obj = obj.disp
    %       Display the properties of object.
    %       - There are no inputs to this method.
    %
    %   For information on the methods type:
    %       help FabryPerotSensor.<method_name>
    %
    %
    % DEPENDENCIES
    %   Medium          - This class is initialized with a Medium object.
    %   ElasticMatrix   - FabryPerotSensor inherits an ElasticMatric
    %                     object.
    %   handle          - FabryPerotSensor uses the MATLAB handle class.
    %
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 05 - May      - 2019
    %   last update     - 30 - July     - 2019
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
        mirror_locations                 % mirror interfaces
        spot_diameter                    % spot diameter
        spot_type                        % spot type
    end
    
    properties (SetAccess = private, GetAccess = private)
        directivity                     % directivity data (complex)
    end
    
    methods
        % constructor
        function obj = FabryPerotSensor(varargin)
            
            % sort inputs
            switch nargin
                case 1
                    % check medium class and assign property
                    if isa(varargin{1},'Medium')
                        obj.setMedium(varargin{1});
                    end
                    
                otherwise
                    % warning message
                    warning on
                    warning(['Please provide a Medium object to ',...
                        ' initalise FabryPerotSensor class. ']);
                    % predefined warning
                    warning('A glass etalon example will be used.')
                    
                    % use an example medium
                    exampleMedium      = Medium(...
                        'water',0,'glass',200e-6,'air',1);
                    
                    %set properties
                    obj.setMedium(exampleMedium);
                    obj.setFilename('glass_etalon_example');
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