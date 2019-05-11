function [ fieldMatrix, phaseInterface ] = ...
        calculateFieldMatrixAnisotropic( alpha, k, interfacePosition, cMaterial, polarisationVector )
    %% Calculate_Field_Matrix_Anisotropic - v1.0 Date: 2018-01-10
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
    %   CALCULATE PHASE FACTORS
    % =====================================================================
    
    % rename for convenience
    pVec = polarisationVector;
    
    % interface coordinate - phase condition
    phaseInterface = zeros(4);
    phaseInterface(1,1) = exp(1i * k * alpha(1) * interfacePosition);
    phaseInterface(2,2) = exp(1i * k * alpha(2) * interfacePosition);
    phaseInterface(3,3) = exp(1i * k * alpha(3) * interfacePosition);
    phaseInterface(4,4) = exp(1i * k * alpha(4) * interfacePosition);
    
    % function handle
    sts = @(alpha,U) (cMaterial(1,3) + (cMaterial(3,3))*alpha*U) * (1i * k);
    st2 = cMaterial(5,5) * (1i * k);
    
    % =====================================================================
    %   CALCULATE FIELD MATRIX
    % =====================================================================

    matrix = [...
        pVec(1),                      pVec(2),                      pVec(3),                  pVec(4)                   ; % u3 displacement @ interface
        1,                            1,                            1,                        1                         ; % U1 displacement @ interface
        (sts(alpha(1),pVec(1))),      (sts(alpha(2),pVec(2))),      (sts(alpha(3),pVec(3))),  (sts(alpha(4),pVec(4)))   ; % S_zz @ interface
        (alpha(1)+ pVec(1))*st2,      (alpha(2) + pVec(2))*st2,     (alpha(3) + pVec(3))*st2, (alpha(4) + pVec(4))*st2 ]; % S_xz @ interface
    
    % multiply by interface phase condition
    fieldMatrix = matrix * phaseInterface;
    
end

