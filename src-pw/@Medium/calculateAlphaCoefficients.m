 function [ alpha_coefficients, stiffness_matrix, polarisation, sh_coeffs ] = ...
        calculateAlphaCoefficients( stiffness_matrix, phase_velocity, density )
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
    %   [ alpha_coefficients, stiffness_matrix, polarisation, sh_coeffs ] = ...
    %       calculateAlphaCoefficients(...
    %       stiffness_matrix, phase_velocity, density )
    %
    % INPUTS
    %   stiffness_matrix        - Material stiffness matrix.     [Pa]
    %   phase_velocity          - Phase velocity.                [m/s]
    %   density                 - The material density.          [kg/m^3]
    %
    % OPTIONAL INPUTS
    %   []              - there are no optional inputs []
    %
    % OUTPUTS
    %   alpha_coefficients      - The ratio of vertical to horizontal
    %                             wave-numbers. There are 4 alpha 
    %                             coefficients returned corresponding to
    %                             upward and downward traveling
    %                             q(L), q(SV) waves.
    %   stiffness_matrix        - Either the [6x6] stiffness matrix [Pa] or
    %                             the lame coefficients in the form 
    %                             [lambda, mu].
    %   polarisation            - Polarization vector for each
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
    
    % =====================================================================
    %   SORT MATERIAL PROPERTIES
    % =====================================================================
    
    % assign smaller variables
    cp = phase_velocity;
    rho = density;
    
    % for isotropic materials
    if size(stiffness_matrix,2) == 2
        
        lambda  = stiffness_matrix(1);
        mu      = stiffness_matrix(2);
        
        % define the coefficients on the middle layer
        c11 = lambda + 2*mu; c12 = lambda; c13 = lambda;
        c22 = lambda + 2*mu; c23 = lambda;
        c33 = lambda + 2*mu;
        c44 = mu;
        c55 = mu;
        c66 = mu;
        
        % stiffness matrix for an orthotropic material
        stiffness_matrix = [...
            c11   , c12 , c13   , 0     , 0     , 0     ;
            c12   , c22 , c23   , 0     , 0     , 0     ;
            c13   , c23 , c33   , 0     , 0     , 0     ;
            0     , 0   , 0     , c44   , 0     , 0     ;
            0     , 0   , 0     , 0     , c55   , 0     ;
            0     , 0   , 0     , 0     , 0     , c66   ];
        
    end

    % check if material is a fluid
    if stiffness_matrix(5,5) < 5
        stiffness_matrix(5,5) = 0.01;
        stiffness_matrix(4,4) = 0.01;
        stiffness_matrix(6,6) = 0.01;       
    end

    % =====================================================================
    %   SOLVE FOR PARTIAL WAVE COEFFICIENTS
    % =====================================================================

    % quadratic coefficients for middle layer 1
    AQM = stiffness_matrix(3,3) * stiffness_matrix(5,5);
    BQM = ...
        (stiffness_matrix(1,1) - rho * cp^2 )*stiffness_matrix(3,3) + ...
        (stiffness_matrix(5,5) - rho * cp^2 )*stiffness_matrix(5,5) + ...
        - (stiffness_matrix(1,3) + stiffness_matrix(5,5))^2;
    CQM = ...
        (stiffness_matrix(1,1) - rho * cp^2) * ...
        (stiffness_matrix(5,5) - rho * cp^2);
    
    % quasi-compressional wave
    alpha_mag(1) = sqrt( (-BQM - sqrt(BQM^2 - 4*AQM*CQM)) / (2 *  AQM)); 
    % quasi-shear wave
    alpha_mag(2) = sqrt( (-BQM + sqrt(BQM^2 - 4*AQM*CQM)) / (2 *  AQM)); 
            
    % =====================================================================
    %   CALCULATE THE ALPHA COEFFICIENTS AND POLARISATION VECTOR
    % =====================================================================
    % DEBUG
    % -> check the alpha coefficients
    
    alpha_coefficients(1) = alpha_mag(2);
    polarisation(1) = -1/alpha_coefficients(1);
    
    alpha_coefficients(2) = -alpha_mag(2);
    polarisation(2) = -1/alpha_coefficients(2);
    
    alpha_coefficients(3) =  alpha_mag(1);
    polarisation(3) = alpha_coefficients(3);
    
    alpha_coefficients(4) = -alpha_mag(1);
    polarisation(4) = alpha_coefficients(4);

    % DEBUG
    if cp < 0
        alpha_coefficients(1) = -alpha_mag(2) ;
        alpha_coefficients(2) = alpha_mag(2);
        alpha_coefficients(3) =  -alpha_mag(1);
        alpha_coefficients(4) = alpha_mag(1);
        
        polarisation(1) = -1/alpha_coefficients(1);
        polarisation(2) = -1/alpha_coefficients(2);
        polarisation(3) = alpha_coefficients(3);
        polarisation(4) = alpha_coefficients(4);
    end
    
    % DEBUG
    % disp(alpha_coefficients)
    
    % =====================================================================
    %   CALCULATE THE SHEAR-HORIZONTAL COEFFICIENTS AND POLARISATION VECTOR
    % =====================================================================
    sh_coeffs = -sqrt( (-stiffness_matrix(6,6) + (rho * cp^2)) ...
        / stiffness_matrix(4,4));
       
end

