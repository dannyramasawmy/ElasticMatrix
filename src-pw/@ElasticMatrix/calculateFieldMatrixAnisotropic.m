function [ field_matrix, phase_interface ] = calculateFieldMatrixAnisotropic(...
        alpha, k, itfc_position, stiffness_matrix, p_vector )
    %CALCULATEFIELDMATRIX Calculates the field matrix.
    %
    % DESCRIPTION
    %   CALCULATEFIELDMATRIX calculates the field matrix for a transversely
    %   isotropic solid. See documentation/REFERENCES.txt. In this
    %   implementation the key elements of the 6X6 stiffness matrix (C) are
    %   [C_11 C_13 C_33 C_55] where 3 is the z-direction and 1 is
    %   the x-direction.
    %
    % USEAGE
    %   [ field_matrix, phase_interface ] = ...
    %       calculateFieldMatrixAnisotropic(...
    %       alpha, k, itfc_position, stiffness_matrix, p_vector )
    %
    % INPUTS
    %   alpha           - The ratio of vertical to horizontal wavenumber 
    %                     that is returned from calculateAlphaCoefficients. 
    %   k               - Horizontal wavenumber.                      [1/m]
    %   itfc_position   - Interface positions between material layers.[m]
    %   stiffness_matrix- The materials 6X6 stiffness matrix.         [Pa]
    %   p_vector        - Polarization vector returned from 
    %                     calculateAlphaCoefficients.                 []
    %
    % OPTIONAL INPUTS
    %   []              - There are no optional inputs                []
    %
    % OUTPUTS
    %   field_matrix    - [4X4] field matrix.                         []
    %   phase_interface - The phase at the interface.                  []
    %
    % DEPENDENCIES
    %   calculateAlphaCoefficients() - requires outputs from this function
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 10 - January  - 2019
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
    
    % =====================================================================
    %   CALCULATE PHASE AT THE INTERFACE
    % =====================================================================
    
    % rename for convenience
    pVec = p_vector;
    
    % interface coordinate - phase condition
    phase_interface = zeros(4);
    phase_interface(1,1) = exp(1i * k * alpha(1) * itfc_position);
    phase_interface(2,2) = exp(1i * k * alpha(2) * itfc_position);
    phase_interface(3,3) = exp(1i * k * alpha(3) * itfc_position);
    phase_interface(4,4) = exp(1i * k * alpha(4) * itfc_position);
    
    % function handle
    sts = @(alpha,U) (stiffness_matrix(1,3) + (stiffness_matrix(3,3))*alpha*U)...
        * (1i * k);
    st2 = stiffness_matrix(5,5) * (1i * k);
    
    % =====================================================================
    %   CALCULATE FIELD MATRIX
    % =====================================================================
    
    matrix = [...
        pVec(1),                      pVec(2),                      pVec(3),                  pVec(4)                   ; % u3 displacement @ interface
        1,                            1,                            1,                        1                         ; % U1 displacement @ interface
        (sts(alpha(1),pVec(1))),      (sts(alpha(2),pVec(2))),      (sts(alpha(3),pVec(3))),  (sts(alpha(4),pVec(4)))   ; % S_zz @ interface
        (alpha(1)+ pVec(1))*st2,      (alpha(2) + pVec(2))*st2,     (alpha(3) + pVec(3))*st2, (alpha(4) + pVec(4))*st2 ]; % S_xz @ interface
    
    % multiply by interface phase condition
    field_matrix = matrix * phase_interface;
    
end

