function obj = setSpotDiameter(obj, spot_diameter)
    %SETSPOTDIAMETER Sets the interrogation laser spot-diameter.
    %
    % DESCRIPTION
    %   SETSPOTDIAMETER sets the interrogation laser spot diameter for the
    %   Fabry-Perot sensor. For me detail see documentation/REFERENCES.txt.
    %   The interrogation spot-diameter will change the amount of spatial
    %   averaging that occurs in the sensor. A large diameter will make the
    %   sensor more directional.
    %
    % USEAGE
    %   obj = setSpotSize(obj, spot_diameter);
    %   
    % INPUTS
    %   spot_diameter   - The laser interrogation spot diameter.    [m]
    %
    % OPTIONAL INPUTS
    %   []              - there are no optional inputs.             []
    %
    % OUTPUTS
    %   obj.spot_size  - The diameter of the interrogation spot.    [m]
    %
    % DEPENDENCIES
    %   []              - There are no dependencies.                []
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - May      - 2019
    %   last update     - 30 - July     - 2019
    %
    % This file is part of the ElasticMatrix toolbox.
    % Copyright (c) 2021 Danny Ramasawmy.
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
    
    % check inputs
    inputCheck(spot_diameter);
    
    % set spot diameter;
    obj.spot_diameter = spot_diameter;

    
end


function inputCheck(spot_diameter)
    %INPUTCHECK Checks the inputs for the current function.
    %
    % DESCRIPTION
    %   INPUTCHECK(spot_diameter) checks the inputs for the function
    %   setSpotDiameter(...). If any of the inputs are not valid, the
    %   function will break and print errors to screen.
    %
    % USAGE
    %   inputChecks(spot_diameter);
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 20 - July - 2019
    %   last update     - 28 - July - 2019
    
    % define attributes
    attributes = {'real','positive'};
    
    % validate the attributes for input 1
    validateattributes(spot_diameter,   {'numeric'},attributes,...
        'setSpotDiameter','spot_diameter',1);
   
    
end