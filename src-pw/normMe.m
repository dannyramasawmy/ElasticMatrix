function [output_norm] = normMe(input)
    %% normMe.m
    % normalises the input vector or matrix by the largest element in the
    % array and returns the vector after it has been normalised.
    %
    % Author    :   Danny Ramasawmy
    %               rmapdrr@ucl.ac.uk
    %               dannyramasawmy@gmail.com
    % Date      :   2016-10-26  -   created
    %               2016-11-07  -   added absolute of function
    
    
    [max_input,~] = max(abs(input(:)));
    output_norm = input./max_input;
    
end