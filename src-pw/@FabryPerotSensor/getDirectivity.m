function [directivity] = getDirectivity(obj, varargin)
    %% getDirectivity v1 date:  2019-05-15
    %
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %   Formats the directivity from the raw complex data.
    %   varargin options:
    %       - raw           - calculated obj.directivity
    %       - real          - imaginary part of obj.directivity
    %       - imag          - real part of obj.directivity
    %       - phase         - phase of obj.directivity
    %       - abs           - obj.directivity
    %       - linear        - normalised to normal incidence respose obj.directivity
    %       - decibel       - decibel of previous
    %       - normalised    - normalised to maximum value of normal incidence
    %       - normal        - normal incidence response
    
    % get the raw directivity
    unprocessedDirectivity = obj.directivity;
    
    % norlise to normal incidence response
    normalisedDirectivity = unprocessedDirectivity ./ ...
        (unprocessedDirectivity(:,1) * ones(1,length(obj.angle)));
    
    % check if varargin is empty
    if isempty(varargin)
        varargin{1} = 'raw';
    end
    
    
    % check against common cases otherwise return raw
    switch varargin{1}
        case 'raw'
            % return complex data
            directivity = unprocessedDirectivity;
            
        case 'real'
            % take real part
            directivity = real(unprocessedDirectivity);
    
        case 'imag'       
            % take imaginary part
            directivity = imag(unprocessedDirectivity);
            
        case 'abs'
            % absolute value
            directivity = abs(unprocessedDirectivity);
            
        case 'phase'
            % returns phase after normalisation to normal incidence
            directivity = angle(unprocessedDirectivity) ;

        case 'linear'
            % absolute value after normalisation
            directivity = abs(normalisedDirectivity);
                                               
        case 'decibel'
            directivity = 20 * log10( obj.getDirectivity('linear'));
            
        case 'normal'
            % returns the normal incidence response
            directivity = normMe( abs(unprocessedDirectivity(:,1)) );
            
        case 'normalise'
            % normalised to the maximum value in the normal incidence
            % response (stops horizontal bands from 0's in the
            % normalisation) - most values will be between 0 and 1
            maxNormalIncidence = max( abs(unprocessedDirectivity(:,1)) );
            directivity = abs(unprocessedDirectivity) ./ maxNormalIncidence;
            
        otherwise
            % otherwise output unprocessed
            obj.getDirectivity('normalise');
    end
    
 
end