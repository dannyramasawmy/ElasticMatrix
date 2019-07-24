function obj = save(obj, varargin)
    %SAVE Saves the ElasticMatrix object.
    %
    % DESCRIPTION
    %   SAVE, saves the ElasticMAtrix object with the filename,
    %   obj.filename. If a filename is not specified the file saved to disk
    %   will automatically have the filename: 'elastic_matrix_object'.
    %
    % USEAGE
    %   obj.save;
    %   obj.save(new_filename);
    %
    % INPUTS
    %   []              - there are no inputs           []
    %
    % OPTIONAL INPUTS
    %   new_filename    - filename to assign the ElasticMatrix object
    %
    % OUTPUTS
    %   .mat            - saves a .mat file to disk     []
    %
    % DEPENDENCIES
    %   []              - there are no dependencies     []
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - January  - 2019
    %   last update     - 22 - July     - 2019
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
    
    % copy object
    elastic_matrix_object = obj;
    
    % assign input to filename
    try
        if nargin ~= 1
            obj.setFilename(varargin{1});
        else
            % save the object
            save(obj.filename, 'elastic_matrix_object');
        end
    catch
        warning('Invalid filename, using: elastic_matrix_object')
        obj.setFilename('elastic_matrix_object');
    end
    
    % save the object
    save(obj.filename, 'elastic_matrix_object');
    

end
