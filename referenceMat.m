classdef referenceMat < handle
    %% Array data struct like array in C++, which can pass by reference.
    
    properties
        array
    end
    
    methods
        function obj = referenceMat(row, column, dataType)
            obj.array = zeros(row, column, dataType);
        end
    end
end

