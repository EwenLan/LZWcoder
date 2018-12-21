%% A function to generate compressend file.
% offset
% +000000 4 Bytes Unsigned Int: Resolution: row pixels.
% +000004 4 Bytes Unsigned Int: Resolution: column pixels.
% +000008 2 Bytes Unsigned Int: Dict Length: n
%  ==== Section 1: Dict Area ====
%  ---- Item 1 ----
% +000000 2 Bytes Unsigned Int: Previous Sequence Index.
% +000002 1 Byte  Unsigned Int: Current Value.
%  ---- Item 2 ----
% +000003 2 Bytes Unsigned Int: Previous Sequence Index.
% +000005 1 Byte  Unsigned Int: Current Value.
%  ......
%  ==== Section 2: Data Area ====
%  ---- Red Channel ----
% 1 byte unsigned value sequence, rearranged by row.
%  ---- Green Channel ----
% 1 byte unsigned value sequence, rearranged by row.
%  ---- Blue Channel ----
% 1 byte unsigned value sequence, rearranged by row.

function CompressImage(img, filename)
    imgsize = size(img);
    t = multibranchesTree;
    compressedCode = zeros(1, imgsize(1)*imgsize(2)*3, 'uint16');
    top = 1;
    for i = 1:3
        for j = 1:imgsize(1)
            for k = 1:imgsize(2)
                l = t.AddValue(img(j, k, i));
                if ~isempty(l)
                    compressedCode(top) = l;
                    top = top + 1;
                end
            end
        end
    end
    compressedCode(top) = t.Eof;
    dict = t.GetDict;
    fd = fopen(filename, 'w');
    fwrite(fd, imgsize(1), 'uint32');
    fwrite(fd, imgsize(2), 'uint32');
    fwrite(fd, t.allocatedIndex - t.mapLowerBorder, 'uint16');
    for i = 1:t.allocatedIndex - t.mapLowerBorder
        fwrite(fd, dict(i, 1), 'uint16');
        fwrite(fd, dict(i, 2), 'uint8');
    end
    for i = 1:top
        fwrite(fd, compressedCode(i), 'uint16');
    end
    fclose(fd);
end

