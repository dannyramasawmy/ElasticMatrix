function obj = calculateSlowness(obj)
    %CALCULATESLOWNESS Calculates the slowness profiles.
    %
    % DESCRIPTION
    %   CALCULATESLOWNESS is a method of the Medium class. This function
    %   calculates the slowness profiles of each material in the Medium
    %   object. This is found by defining a range of phase-speeds and
    %   calculating the slowness of each bulk wave using the Christoffel
    %   equation, see ./documentation/REFERENCES.txt.
    %
    % USEAGE
    %   obj.calculateSlowness;
    %   calculateSlowness(obj);
    %
    % INPUTS
    %   obj             - Medium object.
    %
    % OPTIONAL INPUTS
    %   []              - there are no optional inputs  []
    %
    % OUTPUTS
    %   obj             - returns the input object      []
    %
    %   The .slowness property is a structure of wave-vector components
    %   normalized by an arbitrary frequency. Effectively they are k/omega
    %   with units of [s/m].
    %
    %   obj.slowness            - property of Medium, (structure)
    %   obj.slowness.kx         - horizontal component (vector)
    %   obj.slowness.kz_qL1     - (quasi-)L  vertical component -ve
    %   obj.slowness.kz_qL2     - (quasi-)L  vertical component +ve
    %   obj.slowness.kz_qSV1    - (quasi-)SV vertical component -ve
    %   obj.slowness.kz_qSV2    - (quasi-)SV vertical component +ve
    %   obj.slowness.kz_qSH     - (quasi-)SH vertical component +ve
    %
    % DEPENDENCIES
    %   calculateAlphaCoefficients(...) - Christoffel equation
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - January  - 2019
    %   last update     - 19 - July     - 2019
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
    
    % loop over each material
    for idx = 1:length(obj)
        
        % different solution for different types of materials
        switch obj(idx).state
            case {'Vacuum', 'Unknown'}
                % slowness curves do not exist
                obj(idx).slowness = NaN;
                
            case {'Gas', 'Liquid'}
                % slowness curves are circular
                obj(idx).slowness = calculateSlownessLiquid( obj(idx) );
                
            case {'Isotropic'}
                obj(idx).slowness = calculateSlownessIsotropic( obj(idx) );
                
            case {'Anisotropic'}
                obj(idx).slowness = calculateSlownessAnisotropic( obj(idx) );
                
            otherwise
                % slowness cannot be calculated
                obj(idx).slowness = NaN;
        end
        
    end
    
end

function [slowness] = calculateSlownessLiquid( material )
    %CALCULATESLOWNESSLIQUID Calculates the slowness profiles.
    %
    % DESCRIPTION
    %   CALCULATESLOWNESSLIQUID calculates the slowness profiles for a
    %   liquid material. Note, liquids cannot support a shear wave.
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - January  - 2019
    %   last update     - 19 - July     - 2019
    
    % get the compressional wave speed
    phase_velocity = sqrt(material(1).stiffness_matrix(1,1) /...
        material(1).density);
    
    % get the slowness profiles
    [slowness] = calculateSlownessAnisotropic(material, phase_velocity);
    
    % other parameters are non-physical for liquids
    slowness.kz_qSH     = NaN;
    slowness.kz_qSV1    = NaN;
    slowness.kz_qSV2    = NaN;
    
end


function [slowness] = calculateSlownessIsotropic( material )
    %CALCULATESLOWNESSISOTROPIC Calculates the slowness profiles.
    %
    % DESCRIPTION
    %   CALCULATESLOWNESSISOTROPIC calculates the slowness profiles for a
    %   isotropic materials.
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - January  - 2019
    %   last update     - 19 - July     - 2019
    
    % find the shear speed (lowest phase velocity)
    phase_velocity = sqrt(...
        ((material.stiffness_matrix(1,1) - material.stiffness_matrix(1,3)) / 2 )...
        / material.density);
    
    % calculate the slowness profiles
    [slowness] = calculateSlownessAnisotropic( material, phase_velocity);
    
end


function [slowness] = calculateSlownessAnisotropic( material , varargin)
    %CALCULATESLOWNESSANISOTROPIC Calculates the slowness profiles.
    %
    % DESCRIPTION
    %   CALCULATESLOWNESSANISOTROPIC calculates the slowness profiles for a
    %   anisotropic material.
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - January  - 2019
    %   last update     - 19 - July     - 2019
    
    
    % =====================================================================
    %   SOLVE CHRISTOFFEL EQUATION
    % =====================================================================
    
    % number of sampling points
    N = 5000;
    % define propagation vector
    angle_vec = linspace(0,90,N);
    angle_vec(1) = 0  + eps; % avoid zero errors
    angle_vec(N) = 90 - eps;
    
    % for liquid and isotropic materials a phase_velocity is defined
    try
        max_phase_velocity = varargin{1};
    catch
        % estimate of lowest phase velocity
        max_phase_velocity = sqrt(material(1).stiffness_matrix(5,5) /...
            material(1).density) * 0.5;
    end
    
    % initialize output, wave-vector components
    slowness.kx = zeros(size(angle_vec));
    slowness.kz_qL1 = zeros(size(angle_vec));
    slowness.kz_qL2 = zeros(size(angle_vec));
    slowness.kz_qSV1 = zeros(size(angle_vec));
    slowness.kz_qSV2 = zeros(size(angle_vec));
    slowness.kz_qSH = zeros(size(angle_vec));
    
    % loop over each phase velocity
    for angle_idx = 1:length(angle_vec)
        
        % propagation direction
        angle = angle_vec(angle_idx);
        theta = angle * pi /180;
        % phase velocity at that angle
        cp = max_phase_velocity / sin(theta);
        
        % frequency
        omega = 2* pi * 1e6;
        k = omega / cp ;
        
        % =================================================================
        %   MATERIAL PROPERTIES FOR EACH LAYER
        % =================================================================
        
        % loop over the medium layers and extract the important properties
        %   alpha            - wave-vector ratio
        %   stiffness_matrix - stiffness matrix for each material
        %   p_vec            - polarization of each partial wave
        
        [ m_p.alpha, m_p.stiffness_matrix, m_p.pVec, m_p.sh_coeff ] = ...
            calculateAlphaCoefficients(...
            material.stiffness_matrix, cp, material.density );
        
        % =================================================================
        %   CALCUALTE WAVEVECTOR / FREQUENCY COMPONENTS
        % =================================================================
        
        % horizontal component is the same for qL and qSH qSV waves
        slowness.kx (angle_idx)     = k / omega;                    % [s/m]
        
        % vertical component - (q)L wave
        slowness.kz_qL1(angle_idx)  = k * m_p(1).alpha(4) / omega;  % [s/m]
        slowness.kz_qL2 (angle_idx) = k * m_p(1).alpha(3) / omega;  % [s/m]
        
        % vertical component - (q)SV waves
        slowness.kz_qSV1(angle_idx) = k * m_p(1).alpha(2) / omega;  % [s/m]
        slowness.kz_qSV2(angle_idx) = k * m_p(1).alpha(1) / omega;  % [s/m]
        
        % vertical component - (q)SH waves
        slowness.kz_qSH (angle_idx) = k * m_p(1).sh_coeff / omega;  % [s/m]
        
    end
    
end