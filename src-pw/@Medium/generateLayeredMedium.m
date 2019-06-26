function layeredMedium = generateLayeredMedium(varargin)
    %% generateLayeredMedium v1 date:  2019-01-15
    % 
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %       Takes multiple material inputs and returns a multidimensional
    %       class (i.e it can be indexed like a structure). 

   % check if the inputs are even in length
   if mod(nargin,2)
        error('Incorrect number of inputs, type a material name followed by its thickness (''glass'',0.01,...).')
   end
   
   % assign fields
   for idx = 1:2:nargin
       layeredMedium((idx+1)/2) = Medium.getAcousticProperties(varargin{idx});
       layeredMedium((idx+1)/2).thickness = varargin{idx + 1};
   end
   
   % auto set first layer thickness to Inf if not defined at the start
   if layeredMedium(1).thickness ~= Inf
       layeredMedium.setThickness(1, Inf);
   end
   % auto set last layer thickness to Inf if not defined at the start  
   numberLayers = length(layeredMedium);
   if layeredMedium(numberLayers).thickness ~= Inf
       layeredMedium.setThickness(numberLayers, Inf);
   end
   
   
   
end
