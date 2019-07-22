function [stiffness_matrix]  = lameConversion(lambda, mu)
    %LAMECONVERSION Converts the Lame parameters to a stiffness matrix.
    %
    % DESCRIPTION
    %   LAMECONVERSION(lambda, mu) takes the Lame parameters, Lambda and Mu
    %   and returns a stiffness matrix. The Lame parameters fully define
    %   the stiffness matrix for an isotropic material. Namely the
    %   coefficients, C(1,1), C(2,2), C(3,3) = lambda + 2*mu, the
    %   coefficients C(1,2) C(1,3), C(2,3) = lambda, the coefficients
    %   C(4,4), C(5,5), C(6,6) = mu. The matrix is symmetric, and the
    %   remaining coefficients are 0.
    %
    % USEAGE
    %   stiffness_matrix = Medium.lameConversion(lambda, mu);
    %
    % INPUTS
    %   lambda          - the first Lame coefficient    [units]
    %   mu              - the second Lame coefficient   [units]
    %
    % OPTIONAL INPUTS
    %   []              - there are no optional inputs []
    %
    % OUTPUTS
    %   stiffness_matrix - 6 X 6 stiffness matrix       [Pa]
    %
    % DEPENDENCIES
    %   []              - there are no dependencies     []
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - January  - 2019
    %   last update     - 20 - July     - 2019
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
    
    % check the inputs
    inputCheck(lambda, mu);
    
    % the normal terms
    diagnl = lambda + 2 * mu;
    
    % make stiffness matrix
    stiffness_matrix = [...
        diagnl, lambda, lambda, 0,      0,      0;
        lambda, diagnl, lambda, 0,      0,      0;
        lambda, lambda, diagnl, 0,      0,      0;
        0,      0,      0,      mu,     0,      0;
        0,      0,      0,      0,      mu,     0;
        0,      0,      0,      0,      0,      mu];
    
end

function inputCheck(lambda, mu)
    %INPUECHECK Checks the inputs for the current function
    %
    % DESCRIPTION
    %   INPUTCHECK(lambda, mu) checks the inputs for the function
    %   lameConversion(...). If any of the inputs are not valid, the
    %   function will break and print errors to screen.
    %
    % USAGE
    %   inputChecks(lambda, mu);
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 20 - July - 2019
    %   last update     - 20 - July - 2019
    
    % define attributes
    attributes = {'size',[1 1],'real','positive'};
    
    % validate the attributes for input 1
    validateattributes(lambda,   {'numeric'},attributes,...
        'lameConversion','lambda',1);
    % validate the attributes for input 2
    validateattributes(mu,  {'numeric'},attributes,...
        'lameConversion','mu',2);
    
end