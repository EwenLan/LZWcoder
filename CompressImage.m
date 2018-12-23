%% A function to generate compressend file.
% offset
% +000000 4 Bytes Unsigned Int: Resolution: pixels in a column.
% +000004 4 Bytes Unsigned Int: Resolution: pixels in a row.
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
% 2 bytes unsigned value sequence, rearranged by row.
%  ---- Green Channel ----
% 2 bytes unsigned value sequence, rearranged by row.
%  ---- Blue Channel ----
% 2 bytes unsigned value sequence, rearranged by row.

function CompressImage(img, filename)
    imgsize = size(img);
    t = multibranchesTree;
    compressedCode = zeros(1, imgsize(1)*imgsize(2)*3, 'uint16');
    top = 1;
    pgc = 0;
    pgf = 0;
    bytes = imgsize(1)*imgsize(2)*3;
    fprintf('Compress: ')
    for i = 1:70
        fprintf(' ');
    end
    for i = 1:3
        for j = 1:imgsize(1)
            for k = 1:imgsize(2)
                l = t.AddValue(img(j, k, i));
                if ~isempty(l)
                    compressedCode(top) = l;
                    top = top + 1;
                end
                if mod(pgc, 10000) == 0
                    pg = pgf / bytes;
                    ProgressBar(pg);
                end
                pgc = pgc + 1;
                pgf = pgf + 1;
            end
        end
    end
    compressedCode(top) = t.Eof;
    ProgressBar(1);
    
    figure;
    histogram(compressedCode(1:top), 0:256:65536, 'Normalization', 'pdf');
    grid on;
    xlim([0, 65535]);
    set(gca, 'fontsize', 16);
    title('Histogram of Codes');
    set(gca, 'yscale', 'log');
    xlabel('Codes');
    ylabel('Probability of Each Code');
    
    figure;
    originalCodes = sum(compressedCode(1:top) < 256);
    extendedCodes = sum(compressedCode(1:top) >= 256);
    pie([originalCodes, extendedCodes]);
    legend({'Original Codes', 'Extended Codes'});
    set(gca, 'fontsize', 16);
    
    pgc = 0;
    pgf = (t.allocatedIndex - t.mapLowerBorder)*3 + 10;
    bytes = (t.allocatedIndex - t.mapLowerBorder)*3 + 10 + top*2;
    fprintf('Save:     ');
    for i = 1:70
        fprintf(' ')
    end
    dict = t.GetDict;
    fd = fopen(filename, 'w');
    fwrite(fd, imgsize(1), 'uint32');
    fwrite(fd, imgsize(2), 'uint32');
    fwrite(fd, t.allocatedIndex - t.mapLowerBorder, 'uint16');
    for i = 1:t.allocatedIndex - t.mapLowerBorder
        fwrite(fd, dict(i, 1), 'uint16');
        fwrite(fd, dict(i, 2), 'uint8');
        if mod(pgc, 10000) == 0
            pgc = 0;
            pg = pgf / bytes;
            ProgressBar(pg);
        end
        pgc = pgc + 1;
        pgf = pgf + 3;
    end
    for i = 1:top
        fwrite(fd, compressedCode(i), 'uint16');
        if mod(pgc, 1000) == 0
            pgc = 0;
            pg = pgf / bytes;
            ProgressBar(pg);
        end
        pgc = pgc + 1;
        pgf = pgf + 1;
    end
    ProgressBar(1);
    fclose(fd);
end

