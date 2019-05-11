function [cMat]  = lameConversion(lambda, mu)
    %% lameConversion v1 date:  2019-01-15
    % 
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %       Converts the lame parameters into an isotropic stiffness
    %       matrix.
    
    % the normal terms
    diagnl = lambda + 2 * mu;
    
    % make stiffness matrix
    cMat = [...
        diagnl, lambda, lambda, 0,      0,      0;
        lambda, diagnl, lambda, 0,      0,      0;
        lambda, lambda, diagnl, 0,      0,      0;
        0,      0,      0,      mu,     0,      0;
        0,      0,      0,      0,      mu,     0;
        0,      0,      0,      0,      0,      mu];
    
end