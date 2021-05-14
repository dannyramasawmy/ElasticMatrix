function material_state = state(obj)
    %STATE Finds the material state.
    %
    % DESCRIPTION
    %   STATE(...) returns the material state as a string which can be any
    %   of: 'Unknown', 'Vacuum', 'Gas', 'Liquid', 'Isotropic',
    %   'Anisotropic'. This is a method of the Medium class and is used for
    %   to reduce calculations and plotting.
    %
    % USEAGE
    %   state = obj.state;
    %
    % INPUTS
    %   obj             - A Medium class object.
    %
    % OPTIONAL INPUTS
    %   []              - There are no optional inputs.       []
    %
    % OUTPUTS
    %   state           - A string that is either: 'Unknown', 'Vacuum',
    %                     'Gas', 'Liquid', 'Isotropic','Anisotropic'. If
    %                     length(obj) is more than 1, state will be a cell
    %                     of strings.
    %
    % DEPENDENCIES
    %   []              - There are no dependencies.          []
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 03 - September    - 2019
    %   last update     - 03 - September    - 2019
    %
    % This file is part of the ElasticMatrix toolbox.
    % Copyright (c) 2021 Danny Ramasawmy.
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
       
    % initialize output
    material_state{length(obj)} = '';

    
    % loop over Medium object dimensions
    for idx = 1:length(obj)
        
        % default set output to an unknown material
        state_vector = 0;
    
        % check inputs
        inputCheck(obj(idx).stiffness_matrix);
    
        % =====================================================================
        %   CALCULATE TESTS
        % =====================================================================
        
        % comparison of diagonal "normal" elements, C11, C22, C33
        err_C11mC22 = obj(idx).stiffness_matrix(1,1) -  ...
            obj(idx).stiffness_matrix(2,2);
        err_C33mC22 = obj(idx).stiffness_matrix(3,3) -  ...
            obj(idx).stiffness_matrix(2,2);
        
        % comparison of diagonal "shear" elements, C44, C55, C66
        err_C44mC55 = obj(idx).stiffness_matrix(4,4) -  ...
            obj(idx).stiffness_matrix(5,5);
        err_C66mC55 = obj(idx).stiffness_matrix(6,6) -  ...
            obj(idx).stiffness_matrix(5,5);
        
        % comparison of off diagonal elements, C12, C23, C13
        err_C12mC13 = obj(idx).stiffness_matrix(1,2) -  ...
            obj(idx).stiffness_matrix(1,3);
        err_C23mC13 = obj(idx).stiffness_matrix(2,3) -  ...
            obj(idx).stiffness_matrix(1,3);
        
        % compare off diagonal with diagonal, C11,C12,C13,C23
        err_C11mC12 = obj(idx).stiffness_matrix(1,1) -  ...
            obj(idx).stiffness_matrix(1,2);
        err_C11mC13 = obj(idx).stiffness_matrix(1,1) -  ...
            obj(idx).stiffness_matrix(1,3);
        err_C11mC23 = obj(idx).stiffness_matrix(1,1) -  ...
            obj(idx).stiffness_matrix(2,3);
        
        % set an arbitrary tolerance
        tolerance_stiffness_matrix = 1;
        
        % =================================================================
        %   1) CHECK FOR VACUUM
        % =================================================================
        
        % if the density is a very small value material_state is a vacuum
        if abs(obj(idx).density) < 0.1
            state_vector = 1;
        end
        
        if abs(obj(idx).stiffness_matrix(1,1)) < 1
            state_vector = 1;
        end
        
        % =================================================================
        %   2) CHECK FOR ISOTROPIC / ANISOTROPY
        % =================================================================
        if state_vector == 0

            % if the material is not a vacuum, check if it is isotropic/
            % anisotropic
            
            % set to isotropic, and if it fails any of the tests below 
            % material_state is anisotropic
            state_vector = 4;
            
            % check normal diagonal components are the same, C11, C22, C33
            if abs(err_C11mC22) > tolerance_stiffness_matrix
                state_vector = 5;
            end
            
            if abs(err_C33mC22) > tolerance_stiffness_matrix
                state_vector = 5;
            end
            
            % check shear diagonal components are the same, C44, C55, C66
            if abs(err_C44mC55) > tolerance_stiffness_matrix
                state_vector = 5;
            end
            
            % check shear diagonal components are the same, C44, C55, C66
            if abs(err_C66mC55) > tolerance_stiffness_matrix
                state_vector = 5;
            end
            
            % check off-diagonal components are the same, C12, C13, C23
            if abs(err_C12mC13) > tolerance_stiffness_matrix
                state_vector = 5;
            end
            
            if abs(err_C23mC13) > tolerance_stiffness_matrix
                state_vector = 5;
            end
        end
  
        % =================================================================
        %   3) IF ISOTROPIC CHECK FOR LIQUID
        % =================================================================
        % If the above statements satisfy the Isotropic constraints check 
        % if it satisfies the Liquid constraints.

        if state_vector == 4
            % check shear diagonal components are the same, C44, C55, C66
            if abs(err_C11mC12) < tolerance_stiffness_matrix
                state_vector = 3;
            end
            
            if abs(err_C11mC13) < tolerance_stiffness_matrix
                state_vector = 3;
            end

            % check off-diagonal components are the same, C12, C13, C23
            if abs(err_C11mC23) < tolerance_stiffness_matrix
                state_vector = 3;
            end
            
            % if the stiffness (mu) parameter is less than one - set to liquid.
            if abs(sqrt(obj(idx).stiffness_matrix(5,5)/...
                    obj(idx).density)) < 5
                state_vector = 3;
            end
            
        end
        
        % =================================================================
        %   IF LIQUID CHECK FOR GAS
        % =================================================================
        % If the above statements satisfy the Isotropic constraints check
        % if it satisfies the Liquid constraints. Unlikely to have a
        % gas less than 500 kg/m^3.
        
        if state_vector == 3
            % density test if less than 500 Kg/m^3 set to gas
            if abs(obj(idx).density) < 500
                state_vector = 2;
            end
        end
           
        % =================================================================
        %   ASSIGN STATE
        % =================================================================
        % assign output
        switch state_vector
            case 1
                material_state{idx} = 'Vacuum';
            case 2
                material_state{idx} = 'Gas';
            case 3
                material_state{idx} = 'Liquid';
            case 4
                material_state{idx} = 'Isotropic';
            case 5
                material_state{idx} = 'Anisotropic';
            otherwise
                material_state{idx} = 'Unknown';
        end
        
    end
    
    % if only a 1D object
    if length(obj) == 1
        material_state = material_state{idx};
    end
    
end

function inputCheck(stiffness_matrix)
    %INPUTCHECK Checks the inputs for the current function.
    %
    % DESCRIPTION
    %   INPUTCHECK(obj) checks the inputs for the function state(...). If
    %   any of the inputs are not valid, the function will break and print
    %   errors to screen.
    %
    % USAGE
    %   inputChecks(obj);
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 20 - July      - 2019
    %   last update     - 09 - September - 2019
    
    
    % define attributes
    attributes = {'size',[6 6],'real'};
    
    % validate the attributes for input 2
    validateattributes(stiffness_matrix,  {'numeric'},attributes,...
        'setStiffnessMatrix','stiffness_matrix',1);
    
end