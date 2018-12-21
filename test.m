fakeimg = zeros(600, 800, 3, 'uint8');
for i = 1:15
    for j = 1:20
        fakeimg((i - 1)*40 + 1:(i - 1)*40 + 20, (j - 1)*40 + 1:(j - 1)*40 + 20, :) = 255;
    end
    for j = 1:20
        
    end
end
imshow(fakeimg);