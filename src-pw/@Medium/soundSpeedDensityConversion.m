function [cMat] = soundSpeedDensityConversion(c, cs, rho)
    %% lameConversion v1 date:  2019-01-15
    % 
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %       Converts compressional (c), shear (cs) and density (rho) into a
    %       stiffness mattrix.
    
    % calculates lame parameters and returns a stiffness matrix
    mu      = (cs)^2 * rho;
    lambda  = (c)^2 * rho - 2*mu;
    
    % convert lame parameters
    cMat    = Medium.lameConversion(lambda, mu);
    
end