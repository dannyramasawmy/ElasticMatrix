function obj = setWavenumber(obj, wavenumberRange)
    %% setWavenumber v1 date:  2019-01-15
    % 
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %   Vector of wavenumbers to calculate the model.
    
    % to avoid zero errors
    wavenumberRange(wavenumberRange == 0) = 0.01;
    
    % set the wavenumber range
    obj.wavenumber = wavenumberRange;
end