function [ alpha_coefficients, stf_material, p_vec, sh_coeffs ] = ...
        calculateAlphaCoefficients( stf_material, phase_velocity, density )
    %CALCULATEALPHACOEFFICIENTS Calculates wave-vectors and polarizations.
    %
    % DESCRIPTION
    %   CALCULATEALPHACOEFFICIENTS calculates the wave-vectors and
    %   polarizations for a single anisotropic/isotropic material needed
    %   for the slowness-profiles and partial-wave method. See
    %   documentation/REFERENCES.txt for more information. In this
    %   implementation the key elements of the 6X6 stiffness matrix (C) are
    %   [C_11 C_13 C_33 C_55] where 3 is the z-direction and 1 is the
    %   x-direction.
    %
    % USEAGE
    %   [ alpha_coefficients, stf_material, p_vec, sh_coeffs ] = ...
    %       calculateAlphaCoefficients(...
    %       stf_material, phase_velocity, density )
    %
    % INPUTS
    %   stf_material            - material stiffness matrix     [Pa]
    %   phase_velocity          - phase velocity                [m/s]
    %   density                 - the material density          [kg/m^3]
    %
    % OPTIONAL INPUTS
    %   []              - there are no optional inputs []
    %
    % OUTPUTS
    %   alpha_coefficients      - the ratio of vertical to horizontal
    %                             wave-numbers. There are 4 alpha 
    %                             coefficients returned corresponding to
    %                             upward and downward traveling
    %                             q(L), q(SV) waves.
    %   stf_material            - either the [6x6] stiffness matrix [Pa] or
    %                             the lame coefficients in the form 
    %                             [lambda, mu].
    %   p_vec                   - polarization vector for each
    %                             alpha_coefficient.            []
    %   sh_coeffs               - shear horizontal alpha coefficients. []
    %
    % DEPENDENCIES
    %   []              - there are no dependencies     []
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 10 - January  - 2019
    %   last update     - 25 - July     - 2019
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
    
    % =====================================================================
    %   SORT MATERIAL PROPERTIES
    % =====================================================================
    
    % assign smaller variables
    cp = phase_velocity;
    rho = density;
    
    % for isotropic materials
    if size(stf_material,2) == 2
        
        lambda  = stf_material(1);
        mu      = stf_material(2);
        
        % define the coefficients on the middle layer
        c11 = lambda + 2*mu; c12 = lambda; c13 = lambda;
        c22 = lambda + 2*mu; c23 = lambda;
        c33 = lambda + 2*mu;
        c44 = mu;
        c55 = mu;
        c66 = mu;
        
        % stiffness matrix for an orthotropic material
        stf_material = [...
            c11   , c12 , c13   , 0     , 0     , 0     ;
            c12   , c22 , c23   , 0     , 0     , 0     ;
            c13   , c23 , c33   , 0     , 0     , 0     ;
            0     , 0   , 0     , c44   , 0     , 0     ;
            0     , 0   , 0     , 0     , c55   , 0     ;
            0     , 0   , 0     , 0     , 0     , c66   ];
        
    end

    % check if material is a fluid
    if stf_material(5,5) < 5
        stf_material(5,5) = 0.01;
        stf_material(4,4) = 0.01;
        stf_material(6,6) = 0.01;       
    end

    % =====================================================================
    %   SOLVE FOR PARTIAL WAVE COEFFICIENTS
    % =====================================================================

    % quadratic coefficients for middle layer 1
    AQM = stf_material(3,3) * stf_material(5,5);
    BQM = ...
        (stf_material(1,1) - rho * cp^2 )*stf_material(3,3) + ...
        (stf_material(5,5) - rho * cp^2 )*stf_material(5,5) + ...
        - (stf_material(1,3) + stf_material(5,5))^2;
    CQM = ...
        (stf_material(1,1) - rho * cp^2) * ...
        (stf_material(5,5) - rho * cp^2);
    
    % quasi-compressional wave
    alpha_mag(1) = sqrt( (-BQM - sqrt(BQM^2 - 4*AQM*CQM)) / (2 *  AQM)); 
    % quasi-shear wave
    alpha_mag(2) = sqrt( (-BQM + sqrt(BQM^2 - 4*AQM*CQM)) / (2 *  AQM)); 
            
    % =====================================================================
    %   CALCULATE THE ALPHA COEFFICIENTS AND POLARISATION VECTOR
    % =====================================================================
    alpha_coefficients(1) = alpha_mag(2);
    p_vec(1) = -1/alpha_coefficients(1);
    
    alpha_coefficients(2) = -alpha_mag(2);
    p_vec(2) = -1/alpha_coefficients(2);
    
    alpha_coefficients(3) = alpha_mag(1);
    p_vec(3) = alpha_coefficients(3);
    
    alpha_coefficients(4) = -alpha_mag(1);
    p_vec(4) = alpha_coefficients(4);
    
    % =====================================================================
    %   CALCULATE THE SHEAR-HORIZONTAL COEFFICIENTS AND POLARISATION VECTOR
    % =====================================================================
    sh_coeffs = -sqrt( (-stf_material(6,6) + (rho * cp^2)) ...
        / stf_material(4,4));
       
end

