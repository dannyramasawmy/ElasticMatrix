function obj = disp(obj)
    %% disp v1 date:  2019-01-15
    % 
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %       Displays the medium object using the table class.
    
    % message
    disp('    __________________Medium________________')
    disp(' ')
    
    % copy fields to print
    for idx = 1:length(obj)
        % table 1
        printMe(idx).Index       = idx;
        printMe(idx).Name        = obj(idx).name;
        printMe(idx).Thickness   = obj(idx).thickness;
        printMe(idx).Rho         = obj(idx).density;
        % table 2
        printMe2(idx).Index      = idx;
        printMe2(idx).C11        = obj(idx).cMat(1,1)/1e9;
        printMe2(idx).C13        = obj(idx).cMat(1,3)/1e9;
        printMe2(idx).C33        = obj(idx).cMat(3,3)/1e9;
        printMe2(idx).C55        = obj(idx).cMat(5,5)/1e9;
    end
    
    % display the table
    disp(struct2table(printMe));
    disp(struct2table(printMe2));
    
end