clc; close all; clear;

% 设置文件夹路径
input_folder = 'D:\医学图像融合\实验部分\train_img\ct';  % 输入图像文件夹
output_folder = './result';  % 结果图像文件夹

% 创建结果文件夹（如果不存在的话）
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% 获取文件夹中的图像文件
img_files = dir(fullfile(input_folder, '*.*'));
valid_extensions = {'.jpg', '.jpeg', '.png', '.gif', '.bmp'};  % 支持的图像格式

for k = 1:length(img_files)
    [~, name, ext] = fileparts(img_files(k).name);
    if ismember(lower(ext), valid_extensions)
        % 读取图像
        img_path = fullfile(input_folder, img_files(k).name);
        img = imread(img_path);
        
        % 图像处理
        img_gray = img;
        if size(img, 3) == 3
            img_gray = rgb2gray(img);
        end
        
        % 高斯滤波去除噪声点
        psf = fspecial('gaussian', [5, 5], 1.6);
        Ix = filter2([-1, 0, 1], img_gray);
        Iy = filter2([-1, 0, 1]', img_gray);
        Ix2 = filter2(psf, Ix.^2);
        Iy2 = filter2(psf, Iy.^2);
        Ixy = filter2(psf, Ix .* Iy);

        % 计算角点的响应函数R
        [m, n] = size(img_gray);
        R = zeros(m, n);
        max_R = 0;
        for i = 1:m
            for j = 1:n
                M = [Ix2(i,j), Ixy(i,j); Ixy(i,j), Iy2(i,j)];  % 自相关矩阵
                R(i,j) = det(M) - 0.04 * (trace(M))^2;
                if R(i,j) > max_R
                    max_R = R(i,j);
                end
            end
        end

        % 进行非极大抑制，窗口大小3x3
        thresh = 0.1;
        tmp = zeros(m, n);
        neighbours = [-1,-1; -1,0; -1,1; 0,-1; 0,1; 1,-1; 1,0; 1,1];
        for i = 2:m-1
            for j = 2:n-1
                if R(i,j) > thresh * max_R
                    is_max = true;
                    for k = 1:8
                        if R(i,j) < R(i + neighbours(k,1), j + neighbours(k,2))
                            is_max = false;
                            break;
                        end
                    end
                    if is_max
                        tmp(i,j) = 1;
                    end
                end
            end
        end

        % 显示结果
        figure;
        subplot(1, 2, 1);
        imshow(img);
        title('原图');
        
        subplot(1, 2, 2);
        imshow(img);
        title('角点检测');
        hold on;
        for i = 2:m-1
            for j = 2:n-1
                if tmp(i,j) == 1
                    plot(j, i, 'rx')
                end
            end
        end
        hold off;

        % 保存结果图像
        result_path = fullfile(output_folder, [name, '_result', ext]);
        frame = getframe(gcf);
        imwrite(frame.cdata, result_path);
        close(gcf);
    end
end
