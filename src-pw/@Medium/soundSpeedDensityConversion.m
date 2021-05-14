function [stiffness_matrix] = soundSpeedDensityConversion(c, cs, density)
    %SOUNDSPEEDDENSITYCONVERSION Converts parameters to stiffness matrix.
    %
    % DESCRIPTION
    %   SOUNDSPEEDDENSITYCONVERSION(c, cs, rho) converts compressional
    %   sound-speed (c), shear sound-speed (cs) and density (rho) into a 6
    %   X 6 stiffness matrix (C). (c,cs,rho) are firstly converted into
    %   Lame parameters and the method .lameConversion(lambda, mu) is
    %   called. This function is only valid for isotropic materials.
    %
    %
    % USAGE
    %   [stiffness_matrix] = soundSpeedDensityConversion(c, cs, rho)
    %
    % INPUTS
    %   c               - Compressional sound-speed, double. [m/s]
    %   cs              - Shear sound-speed, double.         [m/s]
    %   density         - Density, double.                   [kg/m^3]
    %
    % OPTIONAL INPUTS
    %   []              - There are no optional inputs.      []
    %
    % OUTPUTS
    %   stiffness_matrix - 6 X 6 (isotropic) stiffness matrix.[units]
    %
    % DEPENDENCIES
    %   Medium.lameConversion(lambda, mu);
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - January  - 2019
    %   last update     - 20 - July     - 2019
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
    
    % =====================================================================
    %   VALIDATE INPUTS
    % =====================================================================
    inputCheck(c, cs, density);
    
    % =====================================================================
    %   CALCULATE STIFFNESS MATRIX
    % =====================================================================
    
    % calculate the Lame parameters
    mu      = (cs).^2 * density;
    lambda  = (c).^2  * density - 2*mu;
    
    % convert the lame parameters to a 6 X 6 stiffness matrix
    stiffness_matrix    = Medium.lameConversion(lambda, mu);
    
end

function inputCheck(c, cs, density)
    %INPUECHECK Checks the inputs for the current function
    %
    % DESCRIPTION
    %   INPUTCHECK(c, cs, rho) checks the inputs for the function
    %   soundSpeedDensityConversion(...). If any of the inputs are not
    %   valid, the function will break and print errors to screen.
    %
    % USAGE
    %   inputChecks(c, cs, density);
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - January  - 2019
    %   last update     - 20 - July     - 2019
    
    % define attributes
    attributes = {'size',[1 1],'real','positive'};
    
    % validate the attributes for input 1
    validateattributes(c,   {'numeric'},attributes,...
        'soundSpeedDensityConversion','c',1);
    % validate the attributes for input 2
    validateattributes(cs,  {'numeric'},attributes,...
        'soundSpeedDensityConversion','cs',2);
    % validate the attributes for input 3
    validateattributes(density, {'numeric'},attributes,...
        'soundSpeedDensityConversion','density',3);
    
end