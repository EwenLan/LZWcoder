classdef multibranchesTreeNode < handle
    properties(GetAccess=public)
        serialIndex = 0;
        jumpListValue = zeros(0, 'uint32');
        jumpListHandle = [];
    end
    methods
        function obj = multibranchesTreeNode(index)
            obj.serialIndex = index;
        end
        function SetIndex(obj, index)
            obj.serialIndex = index;
        end
        function index = GetIndex(obj)
            index = obj.serialIndex;
        end
        function ForceAddEntry(obj, nextValue, nextHandle)
            obj.jumpListValue = [obj.jumpListValue, nextValue];
            obj.jumpListHandle = [obj.jumpListHandle, nextHandle];
        end
        function nextHandle = GetNextNode(obj, nextValue)
            k = find(obj.jumpListValue == nextValue);
            if k
                nextHandle = obj.jumpListHandle(k(1));
            else
                nextHandle = [];
            end
        end
    end
end