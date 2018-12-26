checkerimg = zeros(600, 800, 3, 'uint8');
for i = 1:15
    for j = 1:20
        checkerimg((i - 1)*40 + 1:(i - 1)*40 + 20, (j - 1)*40 + 1:(j - 1)*40 + 20, :) = 255;
    end
    for j = 1:20
        checkerimg((i - 1)*40 + 21:i*40, (j - 1)*40 + 21:j*40, :) = 255;
    end
end
hash = ImageSHA256Hash(checkerimg);
figure;
imshow(checkerimg);
title(['Checker SHA256: ', hash]);
set(gca, 'fontsize', 16);
CompressImage(checkerimg, 'checkerimg.elp');
img = UncompressImage('checkerimg.elp');
figure;
imshow(img);
hash2 = ImageSHA256Hash(img);
title(['Uncompressed Image SHA256: ', hash2]);
set(gca, 'fontsize', 16);