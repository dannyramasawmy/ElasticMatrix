function [obj] = calculateDirectivity(obj)
    %CALCULATEDIRECTIVITY Calculate the directivity of Fabry-Perot sensors.
    %
    % DESCRIPTION
    %   CALCULATEDIRECTIVITY calculates the frequency-dependent directivity
    %   of Fabry-Perot ultrasound sensors. This function uses the
    %   .calculate method of the ElasticMatrix class to calculate the
    %   displacements at the interfaces between layered media. The
    %   calculation is over a range of angles and frequencies which must be
    %   defined prior to using this method. The difference in displacement
    %   between the top and bottom mirror of the Fabry-Perot sensor is
    %   proportional to the acoustic sensitivity. See [1,2] for more
    %   detail.
    %
    %   [1] Cox, Benjamin T., and Paul C. Beard. "The frequency-dependent
    %       directivity of a planar Fabry-Perot polymer film ultrasound
    %       sensor." IEEE transactions on ultrasonics, ferroelectrics, and
    %       frequency control, (2007).
    %
    %   [2] Ramasawmy, Danny R., et al. "Analysis of the Directivity of
    %       Glass Etalon Fabry-Pérot Ultrasound Sensors." IEEE transactions
    %       on ultrasonics, ferroelectrics, and frequency control, (2019).
    %
    % USEAGE
    %   obj.calculate;
    %
    % INPUTS
    %   obj.frequency           - frequency range, (vector)       [Hz]
    %   obj.angle               - angle range, (vector)           [degrees]
    %   obj.mirror_locations    - locations of the FP mirrors
    %   obj.spot_diameter       - diameter of interrogation spot  [m]
    %   obj.spot_type           - spot profile
    %
    %
    % OPTIONAL INPUTS
    %   []                  - there are no optional inputs  []
    %
    % OUTPUTS
    %   obj.directivity     - the directivity property of FabryPerotSensor
    %                         is populated
    %
    % DEPENDENCIES
    %   []                  - there are no dependencies     []
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 05 - May      - 2019
    %   last update     - 28 - July     - 2019
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
    
    % this function calculates the directivity
    disp('... Calculating directivity ...')
    
    % calculate the mirror displacements
    obj.calculate;
    
    % check inputs
    inputCheck(obj);
    
    % =====================================================================
    %   BEAM WEIGHTING
    % =====================================================================
    
    % get the maximum phase velocity
    phase_velocity = sqrt(obj.medium(1).stiffness_matrix(1,1) /...
        obj.medium(1).density);
    
    % angles in radians
    theta = obj.angle * pi /180;
    % circular frequency
    omega = 2* pi * obj.frequency;
    
    % phase velocity
    cp = phase_velocity ./ sin(theta);
    
    % kx wavenumber
    k_x = transpose(omega) ./ cp ;
    
    % spot radius
    beam_radius = obj.spot_diameter / 2;
    
    % which option to choose
    switch obj.spot_type
        
        case 'gaussian'
            % gaussian weighting, beam radius is 1 standard deviation
            sig = beam_radius/6 /2;
            
            % gaussian profile
            psybar = exp(-pi * (k_x.^2)*(sig.^2)./2) ;
            
        case 'collimated'
            % top-hat beam profile
            psybar = (2 * besselj(1,k_x.*beam_radius) ) ./...
                (k_x.*beam_radius );
            
        otherwise
            % in any other case
            psybar = ones(size( k_x ));
    end
    
    % =====================================================================
    %   CALCULATE DIRECTIVITY
    % =====================================================================
    
    % DEBUG
    % # ADD OPTICAL BIREFRINGENCE ###')
    
    % difference in vertical displacement of the mirrors
    directivity = psybar .* (...
        obj.z_displacement(obj.mirror_locations(1)).upper - ...
        obj.z_displacement(obj.mirror_locations(2)).upper);
    
    % assign to temporary variable for fast plotting
    obj.directivity = directivity;
    
    disp('... Finished calculating ...')
    
end

function obj = inputCheck(obj)
    %INPUTCHECK Checks the inputs for the current function.
    %
    % DESCRIPTION
    %   INPUTCHECK(obj) checks the inputs for the function
    %   calculateDirectivity(...). If any of the inputs are not valid, the
    %   function will break and print errors to screen.
    %
    % USAGE
    %   inputChecks(obj)
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 28 - July - 2019
    %   last update     - 29 - July - 2019
    
    % error message
    if isempty(obj.mirror_locations)
        error('Please set mirror locations: obj.setMirrorLocations(...).')
    end
    
    % not essential - assume none
    if isempty(obj.spot_type)
        % set property
        obj.setSpotType('none')
        % warning
        warning('No spot-type set: obj.setSpotType(...).')
    end
    
    % set to 1 (it will do nothing)
    if isempty(obj.spot_diameter)
        % set property
        obj.setSpotDiameter(1);
        % warning
        warning('No spot-diameter set: obj.setSpotDiameter(...).')
    end
end

