function obj = disp(obj)
    %% disp v1 date:  2019-01-15
    % 
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %       Displays the elastic matrix class

   
   disp(['    _____________ElasticMatrix____________'])
   disp(' ')
  
   % get fielnames
   fields = fieldnames(obj);
   
   % copy fields
   for idx = 1:numel(fields)
       tmp.(fields{idx}) = obj.(fields{idx});
   end
   
   % display the fields
   disp(tmp); 
  
   % display the medium object
   obj.medium.disp;
   
   
   
   
end