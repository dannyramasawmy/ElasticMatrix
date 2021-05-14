function [pwa_struct] = getPartialWaveAmplitudes(obj, layer_index)
    %GETPARTIALWAVEAMPLITUDES Returns the partial-wave amplitudes.
    %
    % DESCRIPTION
    %   GETPARTIALWAVEAMPLITUDES(...) sorts the matrix stored in the
    %   .partial_wave_amplitudes property and returns a structure
    %   containing the amplitudes. Also, see .calculate for more
    %   information.
    %
    %   The obj.partial_wave_amplitudes property is of size [n_freqs X
    %   n_other X amplitude], where n_other is the number of angles,
    %   phase-speeds or wave-numbers. Amplitudes is of length 4*(N-1) where
    %   N is the number of layers.
    %   The partial wave amplitude order:
    %       - amplitudes(1)     - Upwards qSV in 1st layer (reflected).
    %       - amplitudes(2)     - Upward qL in 1st layer (reflected).
    %       - amplitudes(end-1) - Downward qSV in last layer (transmitted).
    %       - amplitudes(end)   - Downward qL in last layer (transmitted).
    %
    %   ... for layer n = {2,...end-1}
    %       - amplitudes(4(n - 2) + 3) - Upwards qSV.
    %       - amplitudes(4(n - 2) + 4) - Downwards qSV.
    %       - amplitudes(4(n - 2) + 5) - Upwards qL.
    %       - amplitudes(4(n - 2) + 6) - Downwards qL.
    %   In this function they are sorted for a single index and returned.
    %
    % USEAGE
    %   [partial_waves] = getPartialWaveAmplitudes(layer_index)
    %
    % INPUTS
    %   obj             - An ElasticMatrix object.
    %   layer_index     - The index of the layer. 
    %
    % OPTIONAL INPUTS
    %   []              - There are no optional inputs.
    %
    % OUTPUTS
    %   pwa_struct      - A structure of partial-wave amplitudes.
    %   - pwa_struct.layer_index    - The index of the layer.
    %   - pwa_struct.qL_up          - Upward traveling
    %                                 (quasi-)longitudinal waves.
    %   - pwa_struct.qL_dw          - Downward traveling
    %                                 (quasi-)longitudinal waves.
    %   - pwa_struct.qS_up          - Upward traveling
    %                                 (quasi-)shear waves.
    %   - pwa_struct.qS_dw          - Downward traveling
    %                                 (quasi-)shear waves.
    %
    % DEPENDENCIES
    %   []              - There are no dependencies.     []
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
    
    % check that the .calculate has been used
    inputCheck(obj, layer_index);
    
    % sort inputs and outputs
    length_object = length(obj.medium);
    
    % get output dimensions
    dimension = size(obj.partial_wave_amplitudes);
    
    % initialize the output structure
    pwa_struct.layer_index  = layer_index;
    pwa_struct.qL_up        = zeros(dimension(1),dimension(2),1);  
    pwa_struct.qL_dw        = zeros(dimension(1),dimension(2),1);
    pwa_struct.qS_up        = zeros(dimension(1),dimension(2),1); 
    pwa_struct.qS_dw        = zeros(dimension(1),dimension(2),1);
    
    % assign structure values
    switch layer_index
        case 1
            pwa_struct.qL_up = obj.partial_wave_amplitudes(:,:,2);
            pwa_struct.qS_up = obj.partial_wave_amplitudes(:,:,1);
            pwa_struct.qL_dw = ones(dimension(1),dimension(2),1);
            
        case length_object
            pwa_struct.qL_dw = obj.partial_wave_amplitudes(:,:,end);
            pwa_struct.qS_dw = obj.partial_wave_amplitudes(:,:,end-1);            
            
        otherwise
            % choose slice starting point
            n = 4*(layer_index-2);
            
            pwa_struct.qS_up = obj.partial_wave_amplitudes(:,:,n+3);
            pwa_struct.qS_dw = obj.partial_wave_amplitudes(:,:,n+4);           
            pwa_struct.qL_up = obj.partial_wave_amplitudes(:,:,n+5);   
            pwa_struct.qL_dw = obj.partial_wave_amplitudes(:,:,n+6);   
    end
    
end

function inputCheck(obj, layer_index)
    %INPUECHECK Checks the inputs for the current function.
    %
    % DESCRIPTION
    %   INPUTCHECK(obj, layer_index) checks the inputs for the function
    %   getPartialWaveAmplitudes(...). If any of the inputs are not valid,
    %   the function will break and print errors to screen.
    %
    % USAGE
    %   inputChecks(obj, layer_index);
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 03 - September    - 2019
    %   last update     - 03 - September    - 2019
    
    % check if obj.partial_wave_amplitudes is empty
    if isempty(obj.partial_wave_amplitudes)
        error(['Please use .calculate method before calling',...
            '.getPartialwaveAmplitudes function.'])
    end

    % define attributes
    attributes = {'real','positive'};
    
    % validate the attributes for input 1
    validateattributes(layer_index, {'numeric'},attributes,...
        'setDensity','layer_index',1);
    
end