classdef RectangleSource < SourceInterface
    % RECTANGLESOURCE
    
    methods
        function obj = RectangleSource(varargin)
            
            obj.setSourceType('Rectangle');
            obj.setSourceAmplitude(1);
            
            switch nargin
                case {1}
                    obj.setSourceLength(varargin{1}); % [m]
                    
                case {2}
                    obj.setSourceLength(varargin{1}); % [m]
                    obj.setSourceAmplitude(varargin{2}); % [Pa]
                    
                otherwise
                    error('Too many inputs')
                    
            end
            
        end
        
        function line_x = sample(obj, sample_locations)
            
            line_x = zeros(size(sample_locations));
            mask = (sample_locations > 0) & ...
                (sample_locations < obj.source_length);
            line_x(mask) = 1;
        end
        
    end
    
end