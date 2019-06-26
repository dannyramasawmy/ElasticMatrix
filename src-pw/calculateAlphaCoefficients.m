function [ alphaCoefficients, cMaterial, polarisationVec, shCoeffs ] = ...
        calculateAlphaCoefficients( cMaterial, phaseVelocity, density )
    %% calculateAlphaCoefficients - v1.0 Date: 2018-01-10
    %
    % Author    :   Danny Ramasawmy
    %               rmapdrr@ucl.ac.uk
    % Date      :   2018-01-10 -   created
    %
    %
    % Description
    %   C_material should be either [lambda mu] or stiffness matrix[6 x 6]
    %   the important terms are
    %       C = [C_11 C_13 C_33 C_55] where direction 3 is downwards
    %
    %   INPUTS are the stiffness matrix of the material or lame parameters
    %   for isotropic materials, the phase velocity and density
    %   OUTPUTS are the alpha_coefficients (which are like wavenumbers) and
    %   the stiffness matrix
    %
    % ERROR     :   2018-
    %
    %
    % =====================================================================
    %   SORT MATERIAL PROPERTIES
    % =====================================================================
    
    % assign smaller variables
    cp = phaseVelocity;
    rho = density;
    
    % for isotropic materials
    if size(cMaterial) == [1 2]
        
        Lambda  = cMaterial(1);
        Mu      = cMaterial(2);
        
        % define the coeffiicents on the middle layer
        c11 = Lambda + 2*Mu; c12 = Lambda; c13 = Lambda;
        c22 = Lambda + 2*Mu; c23 = Lambda;
        c33 = Lambda + 2*Mu;
        c44 = Mu;
        c55 = Mu;
        c66 = Mu;
        
        % stiffness matrix for an orthotropic material
        cMaterial = [...
            c11   , c12 , c13   , 0     , 0     , 0     ;
            c12   , c22 , c23   , 0     , 0     , 0     ;
            c13   , c23 , c33   , 0     , 0     , 0     ;
            0     , 0   , 0     , c44   , 0     , 0     ;
            0     , 0   , 0     , 0     , c55   , 0     ;
            0     , 0   , 0     , 0     , 0     , c66   ];
        
    end

    % check if material is a fluid
    FLUID_FLAG = false;
    if cMaterial(5,5) < 5
        FLUID_FLAG = true;
        cMaterial(5,5) = 0.01;
        cMaterial(4,4) = 0.01;
        cMaterial(6,6) = 0.01;
        
    end

    % =====================================================================
    %   SOLVE FOR PARTIAL WAVE COEFFICIENTS
    % =====================================================================

    % quadratic coefficients for middle layer 1
    AQM = cMaterial(3,3) * cMaterial(5,5);
    BQM = ...
        (cMaterial(1,1) - rho * cp^2 )*cMaterial(3,3) + ...
        (cMaterial(5,5) - rho * cp^2 )*cMaterial(5,5) + ...
        - (cMaterial(1,3) + cMaterial(5,5))^2;
    CQM = ...
        (cMaterial(1,1) - rho * cp^2) * ...
        (cMaterial(5,5) - rho * cp^2);
    
    alpha_mag(1) = sqrt( (-BQM - sqrt(BQM^2 - 4*AQM*CQM)) / (2 *  AQM)); % quasi-compressional wave
    alpha_mag(2) = sqrt( (-BQM + sqrt(BQM^2 - 4*AQM*CQM)) / (2 *  AQM)); % quasi-shear wavey
            
    % =====================================================================
    %   CALCULATE THE ALPHA COEFFICIENTS AND POLARISATION VECTOR
    % =====================================================================
    alphaCoefficients(1) = alpha_mag(2);
    polarisationVec(1) = -1/alphaCoefficients(1);
    
    alphaCoefficients(2) = -alpha_mag(2);
    polarisationVec(2) = -1/alphaCoefficients(2);
    
    alphaCoefficients(3) = alpha_mag(1);
    polarisationVec(3) = alphaCoefficients(3);
    
    alphaCoefficients(4) = -alpha_mag(1);
    polarisationVec(4) = alphaCoefficients(4);
    
    % =====================================================================
    %   CALCULATE THE SHEAR-HORIZONTAL COEFFICIENTS AND POLARISATION VECTOR
    % =====================================================================
%     shCoeffs = -sqrt( (-cMaterial(6,6) + (rho * cp^2)) / cMaterial(5,5));
    shCoeffs = -sqrt( (-cMaterial(6,6) + (rho * cp^2)) / cMaterial(4,4));
    
    
    %{

    %     % =====================================================================
    %     %   If the material is a fluid
    %     % =====================================================================
    %     if FLUID_FLAG == 1
    %         lam_f = C_material(1,1);
    % %         % the alpha values are the effective wavenumbers
    % %         % calculate wavenumbers layer 1
    %         alpha_coefficients(3) = +sqrt(-1 + (rho / lam_f)*cp^2 );
    %         polarisation_vec(3) = alpha_coefficients(3);
    %
    %         alpha_coefficients(4) = -sqrt(-1 + (rho / lam_f)*cp^2 );
    %         polarisation_vec(4) = alpha_coefficients(4);
    % %
    % %         % set the other components to 0
    %         alpha_coefficients(1) = 0; % for shear
    %         alpha_coefficients(2) = 0; % for shear
    %         polarisation_vec(1) = 0;
    %         polarisation_vec(2) = 0;
    % end
    %
    %

    %}
    
end

