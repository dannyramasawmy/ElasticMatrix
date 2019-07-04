function obj = save(obj, varargin)
    %% save v1 date:  2019-01-15
    %
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %   Saves the elastic matrix object, varargin{1} is the filename;
    
    % copy object
    elasticMatrixObject = obj;
    
    % assign input to filename
    try
        if nargin ~= 1
            obj.setFilename(varargin{1});
        else
            % save the object
            save(obj.filename, 'elasticMatrixObject');
        end
    catch
        warning('Invalid filename, using: elasticMatrixObject')
        obj.setFilename('elasticMatrixObject');
    end
    
    % save the object
    save(obj.filename, 'elasticMatrixObject');
    
    
    
    
end
