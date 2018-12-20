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
            obj.mapLowerBondage = hex2dec('00ff');
            obj.mapHigherBondage = hex2dec('010a');
            obj.allocatedIndex = obj.mapLowerBondage;
            obj.holdingValue = 0;
        end
        function index = AddValue(obj, value)
            %% Try to put a value to the multi-branches tree and get coded index.
            % If the value exites, return empty and record current value.
            % If the value not exites, return coded index and add a new
            % node into the multi-branches tree.
            k = obj.holdingHandle.GetNextNode(value);
            if ~isempty(k)
                obj.holdingHandle = k;
                index = [];
            else
                if obj.holdingHandle == obj.rootNode
                    index = value;
                    n = multibranchesTreeNode(value);
                    obj.rootNode.ForceAddEntry(value, n);
                else
                    index = obj.holdingHandle.GetIndex();
                    if obj.allocatedIndex < obj.mapHigherBondage
                        %% If it has unused code.
                        % Add a new node.
                        obj.allocatedIndex = obj.allocatedIndex + 1;
                        n = multibranchesTreeNode(obj.allocatedIndex);
                        obj.holdingHandle.ForceAddEntry(value, n);
                    else
                        %% If not.
                        index = [index, value];
                    end
                end
                obj.holdingHandle = obj.rootNode;
            end
        end
    end
end