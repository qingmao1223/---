function mse = MSE(image1, image2)
    % 读取两张图像并将其转换为灰度图像
    if size(image1, 3) == 3
        image1 = rgb2gray(image1);
    end
    if size(image2, 3) == 3
        image2 = rgb2gray(image2);
    end

    % 将图像转换为双精度浮点数
    image1 = double(image1);
    image2 = double(image2);

    % 确保两张图像的尺寸相同
    if size(image1) ~= size(image2)
        error('The two images must have the same dimensions.');
    end

    % 计算均方误差
    mse = mean((image1(:) - image2(:)).^2);
end
