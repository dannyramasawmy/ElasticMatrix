function [RL, RS, TL, TS] = calculateReflectionTransmissionAnalytic(angleRange, mediumObject)
    % calculateReflectionTransmissionAnalytic
    %
    % Author    :   Danny Ramasawmy
    %               rmapdrr@ucl.ac.uk
    %               dannyramasawmy@gmail.com
    % Date      :   2019-07-05  -   created
    %
    % This function calculates the analytical reflection and transmission
    % coefficients between two half-spaces using the expressions given in
    % [1], and [2].
    %
    % [1] Rose, Joseph L. Ultrasonic guided waves in solid media.
    %   Cambridge university press, 2014.
    % [2] Cheeke, J. David N. Fundamentals and applications of ultrasonic
    %   waves. CRC press, 2016.
    %
    %
    % =====================================================================
    %   SORT MATERIAL PROPERTIES
    % =====================================================================
    
    % check material properties follow a Medium structure
    try
        if class(mediumObject) == 'Medium'
            % check it has a length of 2
            if length(mediumObject) ~= 2
                warning('Use a Medium object of length 2')
                return
            end
            
            % check the layers are not anisotropic
            if sum(strcmp({mediumObject(1).state, mediumObject(2).state}, 'Anisotropic')) > 0
                warning('This function is not valid for anisotropic materials')
            end
            
        end
    catch
        % not used a medium object
        warning('Incorrect input arguments')
        return;
    end
    
    % reassign data
    % density
    rho1    = mediumObject(1).density;
    rho2    = mediumObject(2).density;
    % compressional speed
    cL1     = sqrt(mediumObject(1).stiffnessMatrix(1,1) ./ rho1);
    cL2     = sqrt(mediumObject(2).stiffnessMatrix(1,1) ./ rho2);
    % shear speed
    cS1     = sqrt(mediumObject(1).stiffnessMatrix(5,5) ./ rho1);
    cS2     = sqrt(mediumObject(2).stiffnessMatrix(5,5) ./ rho2);
    
    % choose calculation option
    switch mediumObject(1).state
        case {'Liquid'}
            % use Cheeke solution
            [RL, RS, TL, TS] = rTSolutionCheeke(cL1, cL2, cS2, rho1, rho2, angleRange);

        otherwise
            % use Rose soution
            [RL, RS, TL, TS] = rTSolutionRose(cL1, cL2, cS1, cS2, rho1, rho2, angleRange);
    end
    
    
    
end


function  [RL, RS, TL, TS] = rTSolutionRose(cL1, cL2, cT1, cT2, rho1, rho2, angleRange)
    % rTSolutionRose
    %
    % Author    :   Danny Ramasawmy
    %               rmapdrr@ucl.ac.uk
    %               dannyramasawmy@gmail.com
    % Date      :   2019-07-05  -   created
    %
    % This function calcualtes the R and T coefficients between two half
    % spacaes which both have elastic properties
    % no reflected shear
    %
    % [1] Rose, Joseph L. Ultrasonic guided waves in solid media.
    %   Cambridge university press, 2014.
    
    % initalise coefficient matrices
    RL = zeros(size(angleRange));
    RS = zeros(size(angleRange));
    TL = zeros(size(angleRange));
    TS = zeros(size(angleRange));
    
    % incident layer wave velocity
    cN = cL1;
    
    % loop over angles
    for idx = 1:length(angleRange)
        % incidence angle
        theta = angleRange(idx) * pi /180;
        omega = 2 * pi * 1e6;
        
        
        % angle of incidence/ reflectoin
        alphaL = asin( sin(theta) * cL1 / cN );
        alphaT = asin( sin(theta) * cT1 / cN );
        
        betaL = asin( sin(theta) * cL2 / cN );
        betaT = asin( sin(theta) * cT2 / cN );
        
        % calculate wave-vectors
        % horizontal component
        kx = (omega / cN) * sin(theta);
        
        % compresional wavevector
        kL1 = (omega / cL1) ;
        kL2 = (omega / cL2) ;
        % shear wavevectors
        kT1 = (omega / cT1) ;
        kT2 = (omega / cT2) ;
        
        % defin lame parameters
        mu1        = rho1 * (cT1^2);
        lambda1    = rho1 * (cL1^2) - 2*mu1;
        
        mu2        = rho2 * (cT2^2);
        lambda2    = rho2 * (cL2^2) - 2*mu2;
        
        % other factors
        factor1 = kL1 * (lambda1 + 2*mu1);
        factor2 = kL2 * (lambda2 + 2*mu2);
        
        % input vector
        incidentVector = [...
            -cos(alphaL);
            sin(alphaL);
            factor1 * cos(2*alphaT);
            -kL1 * mu1 * sin(2 * alphaL)];
        
        % system matrix
        systemMatrix = [...
            -cos(alphaL)               ,  sin(alphaT)                 , -cos(betaL)              , sin(betaT);
            -sin(alphaL)               , -cos(alphaT)                 , sin(betaL)               , cos(betaT);
            -factor1 * cos(2*alphaT)  ,  kT1 * mu1 * sin(2*alphaT) , factor2 * cos(2*betaT)  , -kT2 * mu2 * sin(2*betaT);
            -kL1*mu1*sin(2*alphaL)   , -kT1*mu1*cos(2*alphaT)     , -kL2*mu2*sin(2*betaL)  , -kT2 * mu2 * cos(2 * betaT)];
        
        % Solve with inverse
        partialWaveAmps = systemMatrix \ incidentVector;
        
        % the soundspeed/soundspeed converts the velocity coefficients to
        % displacement coefficients
        RL(idx) = partialWaveAmps(1) * cL1/cL1 ;
        RS(idx) = partialWaveAmps(2) * cT1/cL1 ;
        TL(idx) = partialWaveAmps(3) * cL2/cL1 ;
        TS(idx) = partialWaveAmps(4) * cT2/cL1 ;
    end
    
end



function  [RL, RS, TL, TS] = rTSolutionCheeke(cL1, cL2, cS2, rho1, rho2, angleRange)
    % rTSolutionCheeke
    %
    
    % Author    :   Danny Ramasawmy
    %               rmapdrr@ucl.ac.uk
    %               dannyramasawmy@gmail.com
    % Date      :   2019-07-05  -   created
    %
    % This function calcualtes the R and T coefficients between two half
    % spacaes where the first layer has fluid properties and the second
    % layer has elastic properties
    %
    %   solution is from [1]
    %   [1] Cheeke, J. David N. Fundamentals and applications of ultrasonic
    %   waves. CRC press, 2016.
    %
    
    % initalise coefficient matrices
    RL = zeros(size(angleRange));
    RS = zeros(size(angleRange));
    TL = zeros(size(angleRange));
    TS = zeros(size(angleRange));
    
    % loop over angles
    for idx = 1:length(angleRange)
        
        % angle in radians
        theta =  angleRange(idx) * pi / 180 ;
        
        % Snells law - angles of refraction
        thetaL = asin( sin(theta)*(cL2)/(cL1)  );
        thetaS = asin( sin(theta)*(cS2)/(cL1)  );
        
        % Impeadances
        Z1 = rho1 * cL1 / cos(theta);
        ZL = rho2 * cL2 / cos(thetaL);
        ZS = rho2 * cS2 / cos(thetaS);
        
        % effective impedance (for each angle)
        Zeff = ZL*(cos(2*thetaS))^2 + ZS*(sin(2*thetaS))^2;
        
        % reflected compressional wave
        RL(idx) = (Zeff - Z1) / (Zeff + Z1);
        
        % transmitted compressional wave
        TL(idx) = (rho1 / rho2)*...
            (2*ZL*cos(2*thetaS))/(Zeff+Z1);
        
        % transmitted shear wave
        TS(idx) = -(rho1 /rho2)*...
            (2*ZS*sin(2*thetaS))/(Zeff+Z1);
    end
    
    
end