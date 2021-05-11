function varargout = dispf(varargin)
    %%DISPF - create strings with both numerical values and characters.
    %
    % DESCRIPTION
    %   DISP takes each input, checks if it is a character or a number and
    %   builds a string to print or return. If an output argument is given
    %   the function will return a string and not print.
    %
    % USAGE:
    %   output_string = dispf(varargin)
    %   dispf('Hello :', 4, ' my world')
    %   >> 'Hello :4 my world'
    %
    % INPUTS:
    %   varargin        - any number of strings and numerics.
    %
    % OPTIONAL INPUTS:
    %   none
    %
    % OUTPUTS:
    %   output_string   - the compounded string.
    %
    % DEPENDENCIES
    %   []              - There are no dependencies.     []
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 11 - May      - 2019
    %   last update     - 11 - May     - 2019
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
    
    global verbose_display
    % check if this variable exists
    if (isempty(verbose_display))
        verbose_display = true;
    end
    
    % if no display and not building a string then do not print
    if (verbose_display==false) && (nargout==0)
        return;
    end
    
    
    % initialise a string array
    output_string = strings(size(varargin));
        
    % build string array and convert numerics
    for idx = 1:length(varargin)
        tmp = varargin(idx);
        if isnumeric(tmp)
            tmp = num2str(tmp);
        end
        output_string(idx) = tmp;
    end
    
    % convert string array to character array
    output_string = output_string.join('').char;
    
    % display or return output
    if nargout > 0; varargout{1} = output_string; else; disp(output_string); end
    
    
    