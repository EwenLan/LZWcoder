function hash = ImageSHA256Hash(img)
    s = reshape(img, 1, []);
    hash = SHA256Hash(s);
end