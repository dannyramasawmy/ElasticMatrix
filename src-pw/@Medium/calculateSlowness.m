function obj = calculateSlowness(obj)
    %% setCMat v1 date:  2019-01-15
    %
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %       Calculates the slowness profiles for each material in the
    %       layered object
    
    
    % loop over every material
    for idx = 1:length(obj)
        
        % different solution for different materials
        switch obj(idx).state
            case {'Vacuum', 'Unknown'}
                % slowness curvess do not exist
                obj(idx).slowness = NaN;
                
            case {'Gas', 'Liquid'}
                % slowness curves are circular
                obj(idx).slowness = calculateSlownessLiquid( obj(idx) );
                
            case {'Isotropic'}
                obj(idx).slowness = calculateSlownessIsotropic( obj(idx) );
                
            case {'Anisotropic'}
                obj(idx).slowness = calculateSlownessAnisotropic( obj(idx) );
                
            otherwise
                % slowness ccannot be calculated
                obj(idx).slowness = NaN;
        end
        
    end
    
end

function [slownessProfiles] = calculateSlownessLiquid( material )
    % calculateSlownessLiquid
    %
    % Author    :   Danny Ramasawmy
    %               rmapdrr@ucl.ac.uk
    %               dannyramasawmy@gmail.com
    % Date      :   2019-01-25  -   created
    %
    %
    % Description
    %   This function is for liquid materials (only support compressional
    %   waves)
    
    % get the compressional wave speed
    phase_vel = sqrt(material(1).cMat(1,1) / material(1).density);
    
    % get the slowness profiles
    [slownessProfiles] = calculateSlownessAnisotropic( material, phase_vel );
    
    % other parameters are non-physical for liquids
    slownessProfiles.ksht = NaN;
    slownessProfiles.kzt_1 = NaN;
    slownessProfiles.kzt_2 = NaN;
    
end


function [slownessProfiles] = calculateSlownessIsotropic( material )
    % calculateSlownessIsotropic
    %
    % Author    :   Danny Ramasawmy
    %               rmapdrr@ucl.ac.uk
    %               dannyramasawmy@gmail.com
    % Date      :   2019-01-25  -   created
    %
    %
    % Description
    %   This function is for isotropic materials (support compressional and
    %   shear waves)
    
    % find the shear speed (lowest phase velocity)
    phase_vel = sqrt(...
        ((material(1).cMat(1,1) - material(1).cMat(1,3)) / 2 ) / material(1).density);
    
    % calculate the slowness profiles
    [slownessProfiles] = calculateSlownessAnisotropic( material, phase_vel);
    
end


function [slownessProfiles] = calculateSlownessAnisotropic( material , varargin)
    %% TestScript
    %
    % Author    :   Danny Ramasawmy
    %               rmapdrr@ucl.ac.uk
    %               dannyramasawmy@gmail.com
    % Date      :   2019-01-25  -   created
    %
    %
    % Description
    %   This function is fir finding the slowness profiles of anisotropic
    %   materials
    
    
    %% ========================================================================
    %   PLOT SLOWNESS PROFILES
    % =========================================================================
    % generate a medium
    
    N = 2000;
    angle_vec = linspace(0,90,N);
    
    % precalculated factors
    freq = 1e6;
    
    try
        phase_vel = varargin{1};
    catch
        % esitmate of lowest phase velocity
        phase_vel = sqrt(material(1).cMat(5,5) / material(1).density);
    end
    
    
    for angle_idx = 1:length(angle_vec)
        
        % basis of phase speed from first layer
        % angle and phase velocity
        angle = angle_vec(angle_idx);
        theta = angle * pi /180;
        
        cp = phase_vel / sin(theta);
        % frequency
        omega = 2* pi * 1e6;
        k = omega / cp ;
        
        % =============================================================
        %   MATERIAL PROPERTIES FOR EACH LAYER
        % =============================================================
        
        % loop over the medium layers and extract the important properties
        %   alpha - partial wave amplitudes
        %   C_mat - stiffness matrix for each material
        %   p_vec - polarisation of each partial wave
        
        [ m_p.alpha, m_p.cMat, m_p.pVec, m_p.sh_coeff ] = ...
            calculateAlphaCoefficients(...
            material.cMat, cp, material.density );
        
        % =================================================================
        %   CALCUALTE WAVEVECTOR COMPONENTS
        % =================================================================
        
        % horizontal component same for qL and qSH qSV waves
        kx(angle_idx) = k /omega;
        
        % vertical component - compressional wave
        kz_1(angle_idx) = k * m_p(1).alpha(4) /omega;
        kz_2(angle_idx) = k * m_p(1).alpha(3) /omega;
        
        % vertical component qSV waves
        kzt_1(angle_idx) = k * m_p(1).alpha(2) /omega;
        kzt_2(angle_idx) = k * m_p(1).alpha(1) /omega;
        
        % vertical component qSH waves
        ksht(angle_idx) = k * m_p(1).sh_coeff /omega;
        
        % assign output
        slownessProfiles.kx = kx;
        slownessProfiles.kz_1 = kz_1;
        slownessProfiles.kz_2 = kz_2;
        slownessProfiles.kzt_1 = kzt_1;
        slownessProfiles.kzt_2 = kzt_2;
        slownessProfiles.ksht = ksht;
    end
    
    
    
    
    
    
end