classdef multibranchesTree < handle
    %% A Multi-branches Tree data struct designed for LZW coding.
    % Pass by refrence, just like java do.
    properties
        rootNode;
        mapLowerBondage;
        mapHigherBondage;
        holdingHandle;
        allocatedIndex;
    end
    methods
        function obj = multibranchesTree()
            obj.rootNode = multibranchesTreeNode([]);
            obj.holdingHandle = obj.rootNode;
            obj.mapLowerBondage = hex2dec('00ff');
            obj.mapHigherBondage = hex2dec('010a');
            obj.allocatedIndex = obj.mapLowerBondage;
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
                    n = multibranchesTreeNode(value);
                    obj.rootNode.ForceAddEntry(value, n);
                    index = [];
                    obj.holdingHandle = n;
                else
                    index = obj.holdingHandle.GetIndex();
                    if obj.allocatedIndex < obj.mapHigherBondage
                        %% If it has unused code.
                        % Add a new node.
                        obj.allocatedIndex = obj.allocatedIndex + 1;
                        n = multibranchesTreeNode(obj.allocatedIndex);
                        obj.holdingHandle.ForceAddEntry(value, n);
                        l = obj.rootNode.GetNextNode(value);
                        if ~isempty(l)
                            obj.holdingHandle = l;
                        else
                            n = multibranchesTreeNode(value);
                            obj.rootNode.ForceAddEntry(value, n);
                            obj.holdingHandle = n;
                        end
                    else
                        %% If not.
                        l = obj.rootNode.GetNextNode(value);
                        if ~isempty(l)
                            obj.holdingHandle = l;
                        else
                            n = multibranchesTreeNode(value);
                            obj.rootNode.ForceAddEntry(value, n);
                            obj.holdingHandle = n;
                        end
                    end
                end
            end
        end
        function index = Eof(obj)
            index = obj.holdingHandle.GetIndex();
            obj.holdingHandle = obj.rootNode;
        end
        function dict = GetDict(obj)
            d = referenceMat(obj.allocatedIndex - obj.mapLowerBondage, 2, 'uint16');
            obj.rootNode.PreOrderTraverse(d, obj.mapLowerBondage, obj.rootNode, 0, 0);
            dict = d.array;
        end
    end
end