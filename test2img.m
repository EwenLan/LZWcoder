img = imread('test2.jpg');
hash = ImageSHA256Hash(img);
figure;
imshow(img);
title(['Before Compress SHA256: ', hash]);
set(gca, 'fontsize', 16);
CompressImage(img, 'test2.elp');
newimg = UncompressImage('test2.elp');
figure;
imshow(newimg);
title(['After Compress SHA256: ', hash]);
set(gca, 'fontsize', 16);