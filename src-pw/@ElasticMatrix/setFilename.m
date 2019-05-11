function obj = setFilename(obj, filename)
    %% setFilename v1 date:  2019-01-15
    % 
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %   Sets the filename when the function is saved.
    
    % only allow 'char' types
    if class(filename) ~= 'char' 
        error('Invalid filename');
    end
    
    % set the name
    obj.filename = filename;
    
end
