function obj = setSpotType(obj, spot_type)
    %SETSPOTDTYPE Sets the interrogation laser spot type.
    %
    % DESCRIPTION
    %   SETSPOTDTYPE sets the interrogation laser spot type for the
    %   Fabry-Perot sensor. For me detail see documentation/REFERENCES.txt.
    %   The interrogation spot-type may either be a Gaussian shape or a
    %   'top-hat' collimated profile. The directional response is averaged
    %   over the spot-type and a collimated or Gaussian beam will change
    %   the effects of spatial averaging.
    %
    % USEAGE
    %   obj = setSpotType(obj, spot_type);
    %
    % INPUTS
    %   spot_type       - A string which can either be:    []
    %                     - 'gaussian'
    %                     - 'collimated'
    %                     - 'none'
    %                     MATLAB uses the validatestring function to check
    %                     the inputs. This has some flexibility, allowing
    %                     case-insensitive inputs and partially complete
    %                     strings.
    %
    % OPTIONAL INPUTS
    %   []              - There are no optional inputs.    []
    %
    % OUTPUTS
    %   obj.spot_type   - The spot-type.                   []
    %
    % DEPENDENCIES
    %   []              - There are no dependencies.       []
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - May      - 2019
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
    
    
    % check inputs
    output_string = inputCheck(spot_type);
    
    % set spot type
    obj.spot_type = output_string;
    
end

function output_string = inputCheck(spot_type)
    %INPUTCHECK Checks the inputs for the current function.
    %
    % DESCRIPTION
    %   INPUTCHECK(spot_type) checks the inputs for the function
    %   setSpotType(...). If any of the inputs are not valid, the
    %   function will break and print errors to screen.
    %
    % USAGE
    %   inputChecks(spot_type);
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 20 - July - 2019
    %   last update     - 28 - July - 2019
    
    % allowed inputs
    spot_type_options = {'gaussian', 'collimated','none'};
    
    % validate material is a string which is in all_materials
    output_string = validatestring(spot_type, spot_type_options,...
        'setSpotType','spot_type',1);
    
end