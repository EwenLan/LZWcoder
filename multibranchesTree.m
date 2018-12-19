classdef multibranchesTree < handle
    %% A Multi-branches Tree data struct designed for LZW coding.
    % Pass by refrence, just like java do.
    properties
        rootNode;
        mapLowerBondage;
        mapHigherBondage;
        holdingValue;
        holdingHandle;
        allocatedIndex;
    end
    methods
        function obj = multibranchesTree()
            obj.rootNode = multibranchesTreeNode(0);
            obj.holdingHandle = obj.rootNode;
            obj.mapLowerBondage = hex2dec('00ffffff');
            obj.mapHigherBondage = hex2dec('ffffffff');
            obj.allocatedIndex = obj.mapLowerBondage;
            obj.holdingValue = 0;
        end
        function index = AddValue(obj, value)
            %% Try to put a value to the multi-branches tree and get coded index.
            % If the value exites, return empty and record current value.
            % If the value not exites, return coded index and add a new
            % node into the multi-branches tree.
            k = obj.holdingHandle.GetNextNode(value);
            if k ~= []
                obj.holdingHandle = k;
                index = [];
            else
                if obj.holdingHandle == obj.rootNode
                    index = value;
                else
                    index = obj.holdingHandle.GetIndex;
                end
                if obj.allocatedIndex < obj.mapHigherBondage
                    %% If it has unused code.
                    % Add a new node.
                    obj.allocatedIndex = obj.allocatedIndex + 1;
                    n = multibranchesTreeNode(obj.allocatedIndex);
                    obj.holdingHandle.ForceAddEntry(value, n);
                else
                    %% If not.
                    % Do nothing.
                end
                obj.holdingHandle = obj.rootNode;
            end
        end
    end
end