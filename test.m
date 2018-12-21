compressedCode = [];
t = multibranchesTree;
for i = 1:12
    for j = 1:4
        compressedCode = [compressedCode, t.AddValue(j)];
    end
end
compressedCode = [compressedCode, t.Eof]