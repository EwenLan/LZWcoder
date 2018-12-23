%% A function to decode image from customed LZW coding image.

function img = UncompressImage(filename)
    fd = fopen(filename);
    d = dir(filename);
    pgc = 0;
    bytes = d.bytes;
    imgsize = fread(fd, 2, 'uint32');
    img = zeros([imgsize', 3], 'uint8');
    dictlen = fread(fd, 1, 'uint16');
    mapLowerBorder = hex2dec('00ff');
    dict = cell(1, dictlen);
    pgf = 10;
    fprintf('Uncompress: ');
    for i = 1:70
        fprintf(' ');
    end
    for i = 1:dictlen
        psi = fread(fd, 1, 'uint16');
        cv = fread(fd, 1, 'uint8');
        if psi > mapLowerBorder
            psv = [cell2mat(dict(psi - mapLowerBorder)), cv];
        else
            psv = [psi, cv];
        end
        dict(i) = {uint8(psv)};
        if mod(pgc, 10000) == 0
            pg = pgf / bytes;
            ProgressBar(pg);
        end
        pgc = pgc + 1;
        pgf = pgf + 3;
    end
    channel = 1;
    row = 1;
    column = 1;
    while ~feof(fd)
        currentIndex = fread(fd, 1, 'uint16');
        if currentIndex > mapLowerBorder
            serial = cell2mat(dict(currentIndex - mapLowerBorder));
        else
            serial = currentIndex;
        end
        index = 1;
        for i = 1:length(serial)
            img(row, column, channel) = serial(i);
            if column < imgsize(2)
                column = column + 1;
            else
                column = 1;
                if row < imgsize(1)
                    row = row + 1;
                else
                    row = 1;
                    channel = channel + 1;
                end
            end
            index = index + 1;
        end
        if mod(pgc, 10000) == 0
            pg = pgf / bytes;
            ProgressBar(pg);
        end
        pgc = pgc + 1;
        pgf = pgf + 2;
    end
    ProgressBar(1);
end