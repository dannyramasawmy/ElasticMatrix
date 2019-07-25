function [RL, RS, TL, TS] = calculateReflectionTransmissionAnalytic(...
        angle_range, medium_object)
    %CALCULATEREFLECTIONTRANSMISSIONANALYTIC analytic R and T coefficients.
    %
    % DESCRIPTION
    %   CALCULATEREFLECTIONTRANSMISSIONANALYTIC calculates the
    %   angle-dependent reflection and transmission (displacement)
    %   coefficients between two half-spaces using the expressions given in
    %   [1], and [2].
    %
    %   [1] Rose, Joseph L. Ultrasonic guided waves in solid media.
    %       Cambridge university press, 2014.
    %   [2] Cheeke, J. David N. Fundamentals and applications of ultrasonic
    %       waves. CRC press, 2016.
    %
    % USEAGE
    %   [RL, RS, TL, TS] = calculateReflectionTransmissionAnalytic(...
    %       angle_range, medium_object);
    %
    % INPUTS
    %   angle_range     - a range of input angles               [degrees]
    %   medium_object   - a medium object with two isotropic layers
    %
    % OPTIONAL INPUTS
    %   []              - there are no optional inputs              []
    %
    % OUTPUTS
    %   RL              - reflected compressional coefficient       []
    %   RS              - reflected shear coefficient               []
    %   TL              - transmitted compressional coefficient     []
    %   TS              - transmitted shear coefficient             []
    %
    % DEPENDENCIES
    %   Medium class    - requires a Medium class object
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 05 - July     - 2019
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
    
    % check inputs
    inputCheck(angle_range, medium_object);
    
    % =====================================================================
    %   SORT MATERIAL PROPERTIES AND CALCULATE
    % =====================================================================
    
    % reassign data density
    rho1    = medium_object(1).density;
    rho2    = medium_object(2).density;
    % compressional speed
    cL1     = sqrt(medium_object(1).stiffness_matrix(1,1) ./ rho1);
    cL2     = sqrt(medium_object(2).stiffness_matrix(1,1) ./ rho2);
    % shear speed
    cS1     = sqrt(medium_object(1).stiffness_matrix(5,5) ./ rho1);
    cS2     = sqrt(medium_object(2).stiffness_matrix(5,5) ./ rho2);
    
    % choose calculation option
    switch medium_object(1).state
        case {'Liquid'}
            % use Cheeke solution
            [RL, RS, TL, TS] = rTSolutionCheeke(...
                cL1, cL2, cS2, rho1, rho2, angle_range);
            
        otherwise
            % use Rose solution
            [RL, RS, TL, TS] = rTSolutionRose(...
                cL1, cL2, cS1, cS2, rho1, rho2, angle_range);
    end
    
    
    
end

function inputCheck(angle_range, medium_object)
    %INPUECHECK Checks the inputs for the current function.
    %
    % DESCRIPTION
    %   INPUTCHECK(angle_range) checks the inputs for the function
    %   calculateReflectionTransmissionAnalytic(...). If any of the inputs
    %   are not valid, the function will break and print errors to screen.
    %
    % USAGE
    %   inputChecks(angle_range);
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 20 - July - 2019
    %   last update     - 25 - July - 2019
    
    % define attributes
    attributes = {'real'};
    
    % validate the attributes for input 1
    validateattributes(angle_range, {'numeric'}, attributes,...
        'calculateReflectionTran...', 'angle_range', 1);
    
    % check material properties are a Medium class
    if isa(medium_object, 'Medium')
        % check it has a length of 2
        if length(medium_object) ~= 2
            error('Use a Medium object of length 2.')
        end
        
        % check the layers are not anisotropic
        if sum(strcmp({medium_object(1).state, medium_object(2).state},'Anisotropic')) > 0
            error('This function is not valid for anisotropic materials')
        end
    else
        % not used a medium object
        warning('Incorrect input arguments')
    end
    
end

function  [RL, RS, TL, TS] = rTSolutionRose(...
        cL1, cL2, cT1, cT2, rho1, rho2, angle_range)
    %RTSOULUTIONROSE analytic R and T coefficients.
    %
    % DESCRIPTION
    %   RTSOULUTIONROSE calculates the
    %   angle-dependent reflection and transmission (displacement)
    %   coefficients between two half-spaces using the expressions given in
    %   [1].
    %
    %   [1] Rose, Joseph L. Ultrasonic guided waves in solid media.
    %       Cambridge university press, 2014.
    %
    % USEAGE
    %   [RL, RS, TL, TS] = rTSolutionRose(...
    %       cL1, cL2, cT1, cT2, rho1, rho2, angle_range);
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 05 - July     - 2019
    %   last update     - 25 - July     - 2019
    
    % initalise coefficient matrices
    RL = zeros(size(angle_range));
    RS = zeros(size(angle_range));
    TL = zeros(size(angle_range));
    TS = zeros(size(angle_range));
    
    % incident layer wave velocity
    cN = cL1;
    
    % loop over angles
    for idx = 1:length(angle_range)
        % incidence angle
        theta = angle_range(idx) * pi /180;
        omega = 2 * pi * 1e6;
        
        
        % angle of incidence/ reflection
        alphaL = asin( sin(theta) * cL1 / cN );
        alphaT = asin( sin(theta) * cT1 / cN );
        
        betaL = asin( sin(theta) * cL2 / cN );
        betaT = asin( sin(theta) * cT2 / cN );
        
        % calculate wave-vectors horizontal component
        % kx = (omega / cN) * sin(theta);
        
        % compressional wave-vector
        kL1 = (omega / cL1) ;
        kL2 = (omega / cL2) ;
        % shear wave-vectors
        kT1 = (omega / cT1) ;
        kT2 = (omega / cT2) ;
        
        % define lame parameters
        mu1        = rho1 * (cT1^2);
        lambda1    = rho1 * (cL1^2) - 2*mu1;
        
        mu2        = rho2 * (cT2^2);
        lambda2    = rho2 * (cL2^2) - 2*mu2;
        
        % other factors
        factor1 = kL1 * (lambda1 + 2*mu1);
        factor2 = kL2 * (lambda2 + 2*mu2);
        
        % input vector
        incident_vector = [...
            -cos(alphaL);
            sin(alphaL);
            factor1 * cos(2*alphaT);
            -kL1 * mu1 * sin(2 * alphaL)];
        
        % system matrix
        system_matrix = [...
            -cos(alphaL)               ,  sin(alphaT)                 , -cos(betaL)              , sin(betaT);
            -sin(alphaL)               , -cos(alphaT)                 , sin(betaL)               , cos(betaT);
            -factor1 * cos(2*alphaT)  ,  kT1 * mu1 * sin(2*alphaT) , factor2 * cos(2*betaT)  , -kT2 * mu2 * sin(2*betaT);
            -kL1*mu1*sin(2*alphaL)   , -kT1*mu1*cos(2*alphaT)     , -kL2*mu2*sin(2*betaL)  , -kT2 * mu2 * cos(2 * betaT)];
        
        % Solve with inverse
        partial_wave_amps = system_matrix \ incident_vector;
        
        % the sound-speed_1/sound-speed_2 converts the velocity coefficients to
        % displacement coefficients
        RL(idx) = partial_wave_amps(1) * cL1/cL1 ;
        RS(idx) = partial_wave_amps(2) * cT1/cL1 ;
        TL(idx) = partial_wave_amps(3) * cL2/cL1 ;
        TS(idx) = partial_wave_amps(4) * cT2/cL1 ;
    end
    
end



function  [RL, RS, TL, TS] = rTSolutionCheeke(...
        cL1, cL2, cS2, rho1, rho2, angle_range)
    %RTSOULUTIONCHEEKE analytic R and T coefficients.
    %
    % DESCRIPTION
    %   RTSOULUTIONCHEEKE calculates the
    %   angle-dependent reflection and transmission (displacement)
    %   coefficients between two half-spaces using the expressions given in
    %   [1].
    %
    %   [1] Cheeke, J. David N. Fundamentals and applications of ultrasonic
    %       waves. CRC press, 2016.
    %
    % USEAGE
    %   [RL, RS, TL, TS] = rTSolutionCheeke(...
    %       cL1, cL2, cS2, rho1, rho2, angle_range);
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 05 - July     - 2019
    %   last update     - 25 - July     - 2019
    %
    
    % initalise coefficient matrices
    RL = zeros(size(angle_range));
    RS = zeros(size(angle_range));
    TL = zeros(size(angle_range));
    TS = zeros(size(angle_range));
    
    % loop over angles
    for idx = 1:length(angle_range)
        
        % angle in radians
        theta =  angle_range(idx) * pi / 180 ;
        
        % Snell's law - angles of refraction
        theta_L = asin( sin(theta)*(cL2)/(cL1)  );
        theta_S = asin( sin(theta)*(cS2)/(cL1)  );
        
        % Impedances
        Z1 = rho1 * cL1 / cos(theta);
        ZL = rho2 * cL2 / cos(theta_L);
        ZS = rho2 * cS2 / cos(theta_S);
        
        % effective impedance (for each angle)
        Zeff = ZL*(cos(2*theta_S))^2 + ZS*(sin(2*theta_S))^2;
        
        % reflected compressional wave
        RL(idx) = (Zeff - Z1) / (Zeff + Z1);
        
        % transmitted compressional wave
        TL(idx) = (rho1 / rho2)*...
            (2*ZL*cos(2*theta_S))/(Zeff+Z1);
        
        % transmitted shear wave
        TS(idx) = -(rho1 /rho2)*...
            (2*ZS*sin(2*theta_S))/(Zeff+Z1);
    end
    
    
end